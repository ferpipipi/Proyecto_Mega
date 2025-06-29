-- ===============================================
-- PROCEDIMIENTO PARA FACTURACIÓN AUTOMÁTICA
-- ===============================================

CREATE OR ALTER PROCEDURE sp_facturacion_automatica_completa
AS
BEGIN
    BEGIN TRY
        DECLARE @fecha_actual DATE = GETDATE();
        DECLARE @contador_facturas INT = 0;
        DECLARE @total_facturado DECIMAL(15,2) = 0;
        
        PRINT '🚀 Iniciando facturación automática para fecha: ' + CAST(@fecha_actual AS VARCHAR);
        
        -- Cursor para procesar cada contrato activo
        DECLARE @numero_contrato VARCHAR(50);
        DECLARE @contrato_id INT;
        DECLARE @fecha_inicio_contrato DATE;
        
        DECLARE contrato_cursor CURSOR FOR 
            SELECT numero_contrato, id, fecha_inicio
            FROM contratos 
            WHERE estado = 'activo';
        
        OPEN contrato_cursor;
        FETCH NEXT FROM contrato_cursor INTO @numero_contrato, @contrato_id, @fecha_inicio_contrato;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Variables para cada factura
            DECLARE @subtotal DECIMAL(10,2) = 0;
            DECLARE @descuentos DECIMAL(10,2) = 0;
            DECLARE @impuestos DECIMAL(10,2) = 0;
            DECLARE @total DECIMAL(10,2) = 0;
            DECLARE @numero_factura VARCHAR(50);
            DECLARE @periodo_inicio DATE;
            DECLARE @periodo_fin DATE;
            
            -- Calcular período (del día del mes de inicio del contrato)
            DECLARE @dia_corte INT = DAY(@fecha_inicio_contrato);
            SET @periodo_fin = DATEFROMPARTS(YEAR(@fecha_actual), MONTH(@fecha_actual), @dia_corte);
            SET @periodo_inicio = DATEADD(MONTH, -1, @periodo_fin);
            
            -- Verificar que no exista factura para este período
            IF NOT EXISTS (
                SELECT 1 FROM facturas 
                WHERE contrato_id = @contrato_id 
                    AND periodo_inicio = @periodo_inicio 
                    AND periodo_fin = @periodo_fin
            )
            BEGIN
                -- 📊 CALCULAR AUTOMÁTICAMENTE TODOS LOS COSTOS
                
                -- Subtotal: Suma de todos los servicios activos
                SELECT @subtotal = ISNULL(SUM(srv.precio_base), 0)
                FROM contratos_servicios cs
                INNER JOIN servicios srv ON cs.servicio_nombre = srv.nombre
                WHERE cs.contrato_id = @contrato_id 
                    AND cs.estado = 'activo'
                    AND cs.fecha_inicio <= @periodo_fin;
                
                -- Descuentos: Aplicar promociones activas
                SELECT @descuentos = ISNULL(SUM(
                    srv.precio_base * (ISNULL(cs.descuento, 0) / 100)
                ), 0)
                FROM contratos_servicios cs
                INNER JOIN servicios srv ON cs.servicio_nombre = srv.nombre
                WHERE cs.contrato_id = @contrato_id 
                    AND cs.estado = 'activo'
                    AND cs.fecha_inicio <= @periodo_fin;
                
                -- Impuestos: 16% sobre (subtotal - descuentos)
                SET @impuestos = (@subtotal - @descuentos) * 0.16;
                SET @total = @subtotal - @descuentos + @impuestos;
                
                -- Solo generar factura si hay servicios
                IF @subtotal > 0
                BEGIN
                    -- Generar número de factura único
                    SET @numero_factura = 'FAC-' + FORMAT(@fecha_actual, 'yyyyMM') + '-' + 
                                         RIGHT('000000' + CAST(NEXT VALUE FOR seq_factura AS VARCHAR), 6);
                    
                    -- 💾 INSERTAR FACTURA AUTOMÁTICAMENTE
                    INSERT INTO facturas (
                        contrato_id, numero_factura, periodo_inicio, periodo_fin,
                        subtotal, descuentos, impuestos, total,
                        fecha_vencimiento, estado, fecha_emision
                    ) VALUES (
                        @contrato_id, @numero_factura, @periodo_inicio, @periodo_fin,
                        @subtotal, @descuentos, @impuestos, @total,
                        DATEADD(DAY, 30, @fecha_actual), 'emitida', @fecha_actual
                    );
                    
                    SET @contador_facturas = @contador_facturas + 1;
                    SET @total_facturado = @total_facturado + @total;
                    
                    PRINT '✅ Factura generada: ' + @numero_factura + ' - Contrato: ' + @numero_contrato + ' - Total: $' + CAST(@total AS VARCHAR);
                END
            END
            
            FETCH NEXT FROM contrato_cursor INTO @numero_contrato, @contrato_id, @fecha_inicio_contrato;
        END
        
        CLOSE contrato_cursor;
        DEALLOCATE contrato_cursor;
        
        -- 📊 RESUMEN FINAL
        PRINT '🎉 FACTURACIÓN AUTOMÁTICA COMPLETADA:';
        PRINT '📄 Facturas generadas: ' + CAST(@contador_facturas AS VARCHAR);
        PRINT '💰 Total facturado: $' + CAST(@total_facturado AS VARCHAR);
        
        -- Insertar log de facturación
        INSERT INTO logs_facturacion (fecha_proceso, facturas_generadas, total_facturado, estado)
        VALUES (@fecha_actual, @contador_facturas, @total_facturado, 'completado');
        
    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR EN FACTURACIÓN AUTOMÁTICA: ' + ERROR_MESSAGE();
        
        -- Log de error
        INSERT INTO logs_facturacion (fecha_proceso, facturas_generadas, total_facturado, estado, error_mensaje)
        VALUES (@fecha_actual, @contador_facturas, @total_facturado, 'error', ERROR_MESSAGE());
        
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    END CATCH
END;