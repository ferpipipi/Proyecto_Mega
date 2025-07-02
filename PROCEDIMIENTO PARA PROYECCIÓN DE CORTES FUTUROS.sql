-- ===============================================
-- PROCEDIMIENTO CORREGIDO PARA PROYECCIÓN DE CORTES
-- ===============================================

CREATE OR ALTER PROCEDURE sp_proyeccion_cortes_futuros
    @numero_contrato VARCHAR(50),
    @meses_futuros INT = 6
AS
BEGIN
    BEGIN TRY
        DECLARE @contrato_id INT;
        DECLARE @precio_base_contrato DECIMAL(10,2);
        DECLARE @fecha_base DATE = GETDATE();
        
        -- Obtener contrato_id y precio mensual real
        SELECT 
            @contrato_id = id,
            @precio_base_contrato = precio_mensual
        FROM contratos 
        WHERE numero_contrato = @numero_contrato AND estado = 'activo';
        
        IF @contrato_id IS NULL
        BEGIN
            PRINT '❌ ERROR: Contrato no encontrado: ' + @numero_contrato;
            RETURN;
        END
        
        PRINT '📋 Contrato encontrado: ' + @numero_contrato + ' - Precio base: $' + CAST(@precio_base_contrato AS VARCHAR);
        
        -- Tabla temporal para proyecciones
        CREATE TABLE #proyeccion_cortes (
            mes_proyeccion DATE,
            mes_nombre VARCHAR(20),
            precio_base_contrato DECIMAL(10,2),
            descuentos_promociones DECIMAL(10,2),
            subtotal_neto DECIMAL(10,2),
            total_proyectado DECIMAL(10,2),
            promociones_activas VARCHAR(500),
            promociones_vencen VARCHAR(500),
            notas VARCHAR(200)
        );
        
        -- Generar proyección para cada mes
        DECLARE @mes_actual INT = 0;
        WHILE @mes_actual < @meses_futuros
        BEGIN
            DECLARE @fecha_proyeccion DATE = DATEADD(MONTH, @mes_actual, @fecha_base);
            DECLARE @descuentos_promocion DECIMAL(10,2) = 0;
            DECLARE @subtotal_neto DECIMAL(10,2) = 0;
            DECLARE @total_final DECIMAL(10,2) = 0;
            DECLARE @promociones_activas VARCHAR(500) = '';
            DECLARE @promociones_vencen VARCHAR(500) = '';
            DECLARE @notas VARCHAR(200) = '';
            
            -- ⭐ CALCULAR DESCUENTOS DE PROMOCIONES ACTIVAS PARA ESA FECHA
            SELECT 
                @descuentos_promocion = SUM(
                    CASE 
                        WHEN p.es_porcentaje = 1 THEN @precio_base_contrato * (p.valor_descuento / 100)
                        ELSE p.valor_descuento
                    END
                ),
                @promociones_activas = STRING_AGG(
                    p.nombre + ' (-$' + 
                    CAST(CASE 
                        WHEN p.es_porcentaje = 1 THEN @precio_base_contrato * (p.valor_descuento / 100)
                        ELSE p.valor_descuento
                    END AS VARCHAR) + ')', ', '
                )
            FROM contratos_promociones cp
            INNER JOIN promociones p ON cp.promocion_id = p.id
            WHERE cp.contrato_id = @contrato_id
                AND cp.activo = 1
                AND cp.fecha_aplicacion <= @fecha_proyeccion
                AND (cp.fecha_vencimiento IS NULL OR cp.fecha_vencimiento >= @fecha_proyeccion);
            
            -- 🚨 DETECTAR PROMOCIONES QUE VENCEN EN ESE MES
            SELECT @promociones_vencen = STRING_AGG(
                p.nombre + ' (vence ' + 
                FORMAT(cp.fecha_vencimiento, 'dd/MM') + ')', ', '
            )
            FROM contratos_promociones cp
            INNER JOIN promociones p ON cp.promocion_id = p.id
            WHERE cp.contrato_id = @contrato_id
                AND cp.activo = 1
                AND YEAR(cp.fecha_vencimiento) = YEAR(@fecha_proyeccion)
                AND MONTH(cp.fecha_vencimiento) = MONTH(@fecha_proyeccion);
            
            -- ⭐ CALCULAR PRECIO FINAL CORRECTO
            SET @descuentos_promocion = ISNULL(@descuentos_promocion, 0);
            SET @subtotal_neto = @precio_base_contrato - @descuentos_promocion;
            SET @total_final = @subtotal_neto; -- NO sumar impuestos porque ya están incluidos
            
            -- Generar notas explicativas
            IF @promociones_vencen IS NOT NULL
                SET @notas = '⚠️ Promociones vencen - Precio aumentará siguiente mes';
            ELSE IF @descuentos_promocion > 0
                SET @notas = '✅ Con descuentos de promociones activas';
            ELSE
                SET @notas = '📋 Precio estándar del contrato (incluye impuestos)';
            
            -- Insertar proyección del mes
            INSERT INTO #proyeccion_cortes VALUES (
                @fecha_proyeccion,
                CASE MONTH(@fecha_proyeccion)
                    WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
                    WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio'
                    WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre'
                    WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
                END + ' ' + CAST(YEAR(@fecha_proyeccion) AS VARCHAR),
                @precio_base_contrato,
                @descuentos_promocion,
                @subtotal_neto,
                @total_final,
                ISNULL(@promociones_activas, 'Sin promociones activas'),
                ISNULL(@promociones_vencen, ''),
                @notas
            );
            
            SET @mes_actual = @mes_actual + 1;
        END
        
        -- 📊 MOSTRAR PROYECCIÓN CORREGIDA
        SELECT 
            mes_nombre AS 'MES',
            '$' + CAST(precio_base_contrato AS VARCHAR) AS 'PRECIO BASE CONTRATO',
            '$' + CAST(descuentos_promociones AS VARCHAR) AS 'DESCUENTOS PROMOCIONES',
            '$' + CAST(subtotal_neto AS VARCHAR) AS 'SUBTOTAL',
            '$' + CAST(total_proyectado AS VARCHAR) AS 'TOTAL A PAGAR',
            promociones_activas AS 'PROMOCIONES ACTIVAS',
            ISNULL(NULLIF(promociones_vencen, ''), 'Ninguna') AS 'PROMOCIONES QUE VENCEN',
            notas AS 'NOTAS'
        FROM #proyeccion_cortes
        ORDER BY mes_proyeccion;
        
        -- 📈 RESUMEN EJECUTIVO CORREGIDO
        SELECT 
            'RESUMEN EJECUTIVO - ' + @numero_contrato AS info,
            COUNT(*) AS meses_proyectados,
            '$' + CAST(@precio_base_contrato AS VARCHAR) AS precio_base_contrato,
            '$' + CAST(MIN(total_proyectado) AS VARCHAR) AS pago_minimo_proyectado,
            '$' + CAST(MAX(total_proyectado) AS VARCHAR) AS pago_maximo_proyectado,
            '$' + CAST(AVG(total_proyectado) AS VARCHAR) AS pago_promedio,
            '$' + CAST(SUM(total_proyectado) AS VARCHAR) AS total_periodo_completo,
            '$' + CAST(SUM(descuentos_promociones) AS VARCHAR) AS ahorros_totales_promociones,
            CASE 
                WHEN SUM(descuentos_promociones) > 0 
                THEN 'Cliente tiene promociones activas'
                ELSE 'Cliente paga precio estándar'
            END AS estado_promociones
        FROM #proyeccion_cortes;
        
        -- 🔍 VERIFICACIÓN DE DATOS
        SELECT 
            'VERIFICACIÓN DE DATOS' AS info,
            @numero_contrato AS contrato,
            c.precio_mensual AS precio_real_bd,
            c.estado AS estado_contrato,
            c.fecha_inicio AS inicio_contrato,
            COUNT(cs.servicio_nombre) AS servicios_activos,
            STRING_AGG(cs.servicio_nombre, ', ') AS servicios_incluidos
        FROM contratos c
        LEFT JOIN contratos_servicios cs ON c.id = cs.contrato_id AND cs.estado = 'activo'
        WHERE c.numero_contrato = @numero_contrato
        GROUP BY c.numero_contrato, c.precio_mensual, c.estado, c.fecha_inicio;
        
        DROP TABLE #proyeccion_cortes;
        
        PRINT '✅ Proyección corregida generada para contrato: ' + @numero_contrato;
        PRINT '💡 Precio base usado: $' + CAST(@precio_base_contrato AS VARCHAR) + ' (incluye impuestos)';
        
    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR: ' + ERROR_MESSAGE();
        IF OBJECT_ID('tempdb..#proyeccion_cortes') IS NOT NULL
            DROP TABLE #proyeccion_cortes;
    END CATCH
END;

-- ===============================================
-- VER PROYECCIÓN DE CORTES PARA UN CONTRATO
-- ===============================================

-- Proyección para 6 meses del contrato CTR-2025-001
EXEC sp_proyeccion_cortes_futuros 
    @numero_contrato = 'CTR-2025-001',
    @meses_futuros = 6;

-- Proyección para 12 meses (anual)
EXEC sp_proyeccion_cortes_futuros 
    @numero_contrato = 'CTR-2025-001',
    @meses_futuros = 12;

