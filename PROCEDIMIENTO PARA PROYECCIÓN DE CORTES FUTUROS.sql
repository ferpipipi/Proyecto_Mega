-- ===============================================
-- PROCEDIMIENTO PARA PROYECCIÓN DE CORTES FUTUROS
-- ===============================================

CREATE OR ALTER PROCEDURE sp_proyeccion_cortes_futuros
    @numero_contrato VARCHAR(50),
    @meses_futuros INT = 6
AS
BEGIN
    BEGIN TRY
        DECLARE @contrato_id INT;
        DECLARE @fecha_base DATE = GETDATE();
        
        -- Obtener contrato_id
        SELECT @contrato_id = id 
        FROM contratos 
        WHERE numero_contrato = @numero_contrato AND estado = 'activo';
        
        IF @contrato_id IS NULL
        BEGIN
            PRINT '❌ ERROR: Contrato no encontrado: ' + @numero_contrato;
            RETURN;
        END
        
        -- Tabla temporal para proyecciones
        CREATE TABLE #proyeccion_cortes (
            mes_proyeccion DATE,
            mes_nombre VARCHAR(20),
            subtotal_servicios DECIMAL(10,2),
            descuentos_promociones DECIMAL(10,2),
            impuestos DECIMAL(10,2),
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
            DECLARE @subtotal DECIMAL(10,2) = 0;
            DECLARE @descuentos DECIMAL(10,2) = 0;
            DECLARE @impuestos DECIMAL(10,2) = 0;
            DECLARE @total DECIMAL(10,2) = 0;
            DECLARE @promociones_activas VARCHAR(500) = '';
            DECLARE @promociones_vencen VARCHAR(500) = '';
            DECLARE @notas VARCHAR(200) = '';
            
            -- 📊 CALCULAR SERVICIOS ACTIVOS PARA ESA FECHA
            SELECT @subtotal = SUM(srv.precio_base)
            FROM contratos_servicios cs
            INNER JOIN servicios srv ON cs.servicio_nombre = srv.nombre
            WHERE cs.contrato_id = @contrato_id 
                AND cs.estado = 'activo'
                AND cs.fecha_inicio <= @fecha_proyeccion
                AND (cs.fecha_fin IS NULL OR cs.fecha_fin >= @fecha_proyeccion);
            
            -- 💰 CALCULAR DESCUENTOS DE PROMOCIONES ACTIVAS
            SELECT 
                @descuentos = SUM(
                    CASE 
                        WHEN p.es_porcentaje = 1 THEN srv.precio_base * (p.valor_descuento / 100)
                        ELSE p.valor_descuento
                    END
                ),
                @promociones_activas = STRING_AGG(p.nombre + ' (-$' + 
                    CAST(CASE 
                        WHEN p.es_porcentaje = 1 THEN srv.precio_base * (p.valor_descuento / 100)
                        ELSE p.valor_descuento
                    END AS VARCHAR) + ')', ', ')
            FROM contratos_promociones cp
            INNER JOIN promociones p ON cp.promocion_id = p.id
            INNER JOIN promociones_servicios ps ON p.id = ps.promocion_id
            INNER JOIN servicios srv ON ps.servicio_nombre = srv.nombre
            INNER JOIN contratos_servicios cs ON cs.contrato_id = @contrato_id 
                AND cs.servicio_nombre = srv.nombre AND cs.estado = 'activo'
            WHERE cp.contrato_id = @contrato_id
                AND cp.activo = 1
                AND cp.fecha_aplicacion <= @fecha_proyeccion
                AND cp.fecha_vencimiento >= @fecha_proyeccion;
            
            -- 🚨 DETECTAR PROMOCIONES QUE VENCEN EN ESE MES
            SELECT @promociones_vencen = STRING_AGG(p.nombre + ' (vence ' + 
                CAST(DAY(cp.fecha_vencimiento) AS VARCHAR) + '/' + 
                CAST(MONTH(cp.fecha_vencimiento) AS VARCHAR) + ')', ', ')
            FROM contratos_promociones cp
            INNER JOIN promociones p ON cp.promocion_id = p.id
            WHERE cp.contrato_id = @contrato_id
                AND cp.activo = 1
                AND YEAR(cp.fecha_vencimiento) = YEAR(@fecha_proyeccion)
                AND MONTH(cp.fecha_vencimiento) = MONTH(@fecha_proyeccion);
            
            -- Calcular impuestos y total
            SET @descuentos = ISNULL(@descuentos, 0);
            SET @impuestos = (@subtotal - @descuentos) * 0.16;
            SET @total = @subtotal - @descuentos + @impuestos;
            
            -- Generar notas explicativas
            IF @promociones_vencen IS NOT NULL
                SET @notas = '⚠️ Promociones vencen - Precio aumentará siguiente mes';
            ELSE IF @descuentos > 0
                SET @notas = '✅ Con descuentos activos';
            ELSE
                SET @notas = '📋 Precio estándar sin promociones';
            
            -- Insertar proyección del mes
            INSERT INTO #proyeccion_cortes VALUES (
                @fecha_proyeccion,
                CASE MONTH(@fecha_proyeccion)
                    WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
                    WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio'
                    WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre'
                    WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
                END + ' ' + CAST(YEAR(@fecha_proyeccion) AS VARCHAR),
                ISNULL(@subtotal, 0),
                @descuentos,
                @impuestos,
                @total,
                @promociones_activas,
                @promociones_vencen,
                @notas
            );
            
            SET @mes_actual = @mes_actual + 1;
        END
        
        -- 📊 MOSTRAR PROYECCIÓN COMPLETA
        SELECT 
            mes_nombre AS 'MES',
            CAST(subtotal_servicios AS VARCHAR) AS 'SERVICIOS',
            CAST(descuentos_promociones AS VARCHAR) AS 'DESCUENTOS',
            CAST(impuestos AS VARCHAR) AS 'IMPUESTOS',
            CAST(total_proyectado AS VARCHAR) AS 'TOTAL A PAGAR',
            ISNULL(promociones_activas, 'Sin promociones') AS 'PROMOCIONES ACTIVAS',
            ISNULL(promociones_vencen, '') AS 'PROMOCIONES QUE VENCEN',
            notas AS 'NOTAS'
        FROM #proyeccion_cortes
        ORDER BY mes_proyeccion;
        
        -- 📈 RESUMEN EJECUTIVO
        SELECT 
            'RESUMEN EJECUTIVO' AS info,
            COUNT(*) AS meses_proyectados,
            MIN(total_proyectado) AS pago_minimo,
            MAX(total_proyectado) AS pago_maximo,
            AVG(total_proyectado) AS pago_promedio,
            SUM(total_proyectado) AS total_6_meses,
            SUM(descuentos_promociones) AS ahorros_totales
        FROM #proyeccion_cortes;
        
        DROP TABLE #proyeccion_cortes;
        
        PRINT '✅ Proyección de cortes generada para contrato: ' + @numero_contrato;
        
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