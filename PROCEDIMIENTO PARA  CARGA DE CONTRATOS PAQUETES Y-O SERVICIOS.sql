-- ===============================================
-- PROCEDIMIENTO COMPLETO: PAQUETES + SERVICIOS INDIVIDUALES
-- ===============================================

CREATE OR ALTER PROCEDURE sp_crear_contrato_completo_mejorado
    @suscriptor_id INT,
    @numero_contrato VARCHAR(50) = NULL,
    @tipo_contrato VARCHAR(50), -- 'paquete' o 'individual'
    @paquete_nombre VARCHAR(100) = NULL,
    @servicios_individuales NVARCHAR(MAX) = NULL, -- JSON: [{"nombre":"Netflix","descuento":0}]
    @fecha_inicio DATE = NULL,
    @notas TEXT = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        SET @fecha_inicio = ISNULL(@fecha_inicio, GETDATE());
        
        DECLARE @contrato_id INT;
        DECLARE @precio_total DECIMAL(10,2) = 0;
        DECLARE @numero_generado VARCHAR(50);
        
        -- GENERAR NÚMERO DE CONTRATO AUTOMÁTICO SI NO SE PROPORCIONA
        IF @numero_contrato IS NULL OR @numero_contrato = ''
        BEGIN
            DECLARE @anio VARCHAR(4) = CAST(YEAR(GETDATE()) AS VARCHAR);
            DECLARE @secuencia INT;
            
            SELECT @secuencia = ISNULL(MAX(CAST(RIGHT(numero_contrato, 3) AS INT)), 0) + 1
            FROM contratos 
            WHERE numero_contrato LIKE 'CTR-' + @anio + '-%';
            
            SET @numero_generado = 'CTR-' + @anio + '-' + RIGHT('000' + CAST(@secuencia AS VARCHAR), 3);
            SET @numero_contrato = @numero_generado;
            
            PRINT '📋 Número de contrato generado automáticamente: ' + @numero_contrato;
        END
        ELSE
        BEGIN
            IF EXISTS (SELECT 1 FROM contratos WHERE numero_contrato = @numero_contrato)
            BEGIN
                PRINT '❌ ERROR: Ya existe el número de contrato: ' + @numero_contrato;
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END
        
        -- ===============================================
        -- OPCIÓN 1: CARGAR PAQUETE COMPLETO
        -- ===============================================
        IF @tipo_contrato = 'paquete' AND @paquete_nombre IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM paquetes WHERE nombre = @paquete_nombre)
            BEGIN
                PRINT '❌ ERROR: El paquete no existe: ' + @paquete_nombre;
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            -- Obtener precio del paquete
            SELECT @precio_total = precio_total 
            FROM paquetes 
            WHERE nombre = @paquete_nombre;
            
            -- Crear contrato principal
            INSERT INTO contratos (
                suscriptor_id, numero_contrato, fecha_inicio, 
                estado, precio_mensual, notas, created_at
            ) VALUES (
                @suscriptor_id, @numero_contrato, @fecha_inicio,
                'activo', @precio_total, @notas, GETDATE()
            );
            
            SET @contrato_id = SCOPE_IDENTITY();
            PRINT '✅ Contrato creado con ID: ' + CAST(@contrato_id AS VARCHAR);
            
            -- Insertar servicios del paquete
            INSERT INTO contratos_servicios (
                contrato_id, servicio_nombre, paquete_nombre, 
                descuento, fecha_inicio, estado
            )
            SELECT 
                @contrato_id,
                ps.servicio_nombre,
                ps.paquete_nombre,
                ps.descuento_porcentaje,
                @fecha_inicio,
                'activo'
            FROM paquetes_servicios ps
            WHERE ps.paquete_nombre = @paquete_nombre AND ps.activo = 1;
            
            PRINT '✅ Servicios del paquete agregados correctamente';
        END
        
        -- ===============================================
        -- OPCIÓN 2: CARGAR SERVICIOS INDIVIDUALES
        -- ===============================================
        ELSE IF @tipo_contrato = 'individual' AND @servicios_individuales IS NOT NULL
        BEGIN
            -- Crear contrato con precio inicial 0 (se calculará automáticamente)
            INSERT INTO contratos (
                suscriptor_id, numero_contrato, fecha_inicio, 
                estado, precio_mensual, notas, created_at
            ) VALUES (
                @suscriptor_id, @numero_contrato, @fecha_inicio,
                'activo', 0, @notas, GETDATE()
            );
            
            SET @contrato_id = SCOPE_IDENTITY();
            PRINT '✅ Contrato creado con ID: ' + CAST(@contrato_id AS VARCHAR);
            
            -- ⭐ PROCESAR SERVICIOS INDIVIDUALES (FORMATO SIMPLE)
            -- Formato esperado: "Netflix,HBO MAX,Internet 100 Mbps"
            DECLARE @servicio_nombre VARCHAR(100);
            DECLARE @pos INT = 1;
            DECLARE @len INT = LEN(@servicios_individuales);
            
            WHILE @pos <= @len
            BEGIN
                DECLARE @next_comma INT = CHARINDEX(',', @servicios_individuales, @pos);
                
                IF @next_comma = 0
                    SET @next_comma = @len + 1;
                
                SET @servicio_nombre = LTRIM(RTRIM(SUBSTRING(@servicios_individuales, @pos, @next_comma - @pos)));
                
                -- Validar que el servicio existe
                IF EXISTS (SELECT 1 FROM servicios WHERE nombre = @servicio_nombre)
                BEGIN
                    INSERT INTO contratos_servicios (
                        contrato_id, servicio_nombre, paquete_nombre,
                        descuento, fecha_inicio, estado
                    ) VALUES (
                        @contrato_id, @servicio_nombre, NULL,
                        0, @fecha_inicio, 'activo'
                    );
                    
                    PRINT '✅ Servicio agregado: ' + @servicio_nombre;
                END
                ELSE
                BEGIN
                    PRINT '⚠️ ADVERTENCIA: Servicio no encontrado: ' + @servicio_nombre;
                END
                
                SET @pos = @next_comma + 1;
            END
            
            PRINT '✅ Servicios individuales procesados';
        END
        ELSE
        BEGIN
            PRINT '❌ ERROR: Tipo de contrato no válido o faltan parámetros';
            PRINT '💡 Usar: @tipo_contrato = ''paquete'' con @paquete_nombre';
            PRINT '💡 O usar: @tipo_contrato = ''individual'' con @servicios_individuales';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        COMMIT TRANSACTION;
        
        -- ✅ RETORNAR INFORMACIÓN DEL CONTRATO CREADO
        SELECT 
            c.id AS contrato_creado,
            c.numero_contrato,
            c.precio_mensual,
            @tipo_contrato AS tipo_contrato,
            CASE 
                WHEN @tipo_contrato = 'paquete' THEN @paquete_nombre
                ELSE 'Servicios individuales'
            END AS detalle_contrato,
            COUNT(cs.id) AS servicios_incluidos,
            STRING_AGG(cs.servicio_nombre, ', ') AS servicios_detalle
        FROM contratos c
        LEFT JOIN contratos_servicios cs ON c.id = cs.contrato_id
        WHERE c.id = @contrato_id
        GROUP BY c.id, c.numero_contrato, c.precio_mensual;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        PRINT '❌ ERROR EN PROCEDIMIENTO:';
        PRINT 'Número de Error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT 'Mensaje: ' + ERROR_MESSAGE();
        PRINT 'Línea: ' + CAST(ERROR_LINE() AS VARCHAR);
    END CATCH
END;


EXEC sp_crear_contrato_completo_mejorado
    @suscriptor_id = 8,
    @numero_contrato = NULL,  -- NULL = genera automáticamente
    @tipo_contrato = 'paquete', -- paquete o individual
    @paquete_nombre = 'Paquete Estudiante',
    @notas = 'Contrato con número generado automáticamente';

-- ===============================================
-- OPCIÓN 2: NÚMERO MANUAL ÚNICO
-- ===============================================

EXEC sp_crear_contrato_completo_mejorado
    @suscriptor_id = 2,
    @numero_contrato = 'CTR-2025-006',  -- Número único manual
    @tipo_contrato = 'paquete',
    @paquete_nombre = 'Triple Play Premium',
    @notas = 'Contrato con número manual único';




