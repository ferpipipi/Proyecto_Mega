
  -- ===============================================
-- PROCEDIMIENTO PARA CREAR CONTRATO COMPLETO
-- ===============================================

-- CREATE PROCEDURE sp_crear_contrato_completo
--     @suscriptor_id INT,
--     @numero_contrato VARCHAR(50),
--     @tipo_contrato VARCHAR(50), -- 'paquete' o 'individual'
--     @paquete_nombre VARCHAR(100) = NULL,
--     @servicios_individuales NVARCHAR(MAX) = NULL, -- JSON de servicios
--     @fecha_inicio DATE = NULL,
--     @notas TEXT = NULL
-- AS
-- BEGIN
--     SET @fecha_inicio = ISNULL(@fecha_inicio, GETDATE());
    
--     DECLARE @contrato_id INT;
--     DECLARE @precio_total DECIMAL(10,2) = 0;
    
--     -- Calcular precio según tipo
--     IF @tipo_contrato = 'paquete' AND @paquete_nombre IS NOT NULL
--     BEGIN
--         SELECT @precio_total = precio_total 
--         FROM paquetes 
--         WHERE nombre = @paquete_nombre;
        
--         -- Crear contrato principal
--         INSERT INTO contratos (
--             suscriptor_id, numero_contrato, fecha_inicio, 
--             estado, precio_mensual, notas, created_at
--         ) VALUES (
--             @suscriptor_id, @numero_contrato, @fecha_inicio,
--             'activo', @precio_total, @notas, GETDATE()
--         );
        
--         SET @contrato_id = SCOPE_IDENTITY();
        
--         -- Insertar servicios del paquete
--         INSERT INTO contratos_servicios (
--             contrato_id, servicio_nombre, paquete_nombre, 
--             descuento, fecha_inicio, estado
--         )
--         SELECT 
--             @contrato_id,
--             ps.servicio_nombre,
--             ps.paquete_nombre,
--             ps.descuento_porcentaje,
--             @fecha_inicio,
--             'activo'
--         FROM paquetes_servicios ps
--         WHERE ps.paquete_nombre = @paquete_nombre AND ps.activo = 1;
--     END
    
--     -- Retornar información del contrato creado
--     SELECT 
--         @contrato_id AS contrato_creado,
--         @precio_total AS precio_mensual,
--         COUNT(cs.id) AS servicios_incluidos
--     FROM contratos_servicios cs
--     WHERE cs.contrato_id = @contrato_id;
-- END;

-- -- USO DEL PROCEDIMIENTO
-- EXEC sp_crear_contrato_completo 
--     @suscriptor_id = 1,
--     @numero_contrato = 'CTR-2025-004',
--     @tipo_contrato = 'paquete',
--     @paquete_nombre = 'Dúo Premium',
--     @notas = 'Cliente creado con procedimiento automático';

      
--     -- Crear constraint más flexible
--     ALTER TABLE contratos_servicios
--     ADD CONSTRAINT CHK_descuento_valido
--     CHECK (descuento >= 0 AND descuento <= 50);
    
--     -- Ejecutar procedimiento
--     EXEC sp_crear_contrato_completo 
--         @suscriptor_id = 1,
--         @numero_contrato = 'CTR-2025-001',
--         @tipo_contrato = 'paquete',
--         @paquete_nombre = 'Dúo Premium',
--         @notas = 'Cliente creado con procedimiento automático';
    
--     PRINT '✅ Problema resuelto - Contrato creado exitosamente';    

--         -- Ejecutar procedimiento
--     EXEC sp_crear_contrato_completo 
--         @suscriptor_id = 2,
--         @numero_contrato = 'CTR-2025-002',
--         @tipo_contrato = 'paquete',
--         @paquete_nombre = 'Dúo Básico',
--         @notas = 'Cliente creado con procedimiento automático';
    
--     PRINT '✅ Problema resuelto - Contrato creado exitosamente'; 

    -- ===============================================
    -- PROCEDIMIENTO MEJORADO QUE GENERA NÚMERO AUTOMÁTICO
    -- ===============================================
    
    -- ===============================================
    -- PROCEDIMIENTO CORREGIDO
    -- ===============================================
    
    CREATE OR ALTER PROCEDURE sp_crear_contrato_completo_mejorado
        @suscriptor_id INT,
        @numero_contrato VARCHAR(50) = NULL,  -- Opcional - se genera automático si es NULL
        @tipo_contrato VARCHAR(50), 
        @paquete_nombre VARCHAR(100) = NULL,
        @servicios_individuales NVARCHAR(MAX) = NULL,
        @fecha_inicio DATE = NULL,
        @notas TEXT = NULL
    AS
    BEGIN
        BEGIN TRY
            SET @fecha_inicio = ISNULL(@fecha_inicio, GETDATE());
            
            DECLARE @contrato_id INT;
            DECLARE @precio_total DECIMAL(10,2) = 0;
            DECLARE @numero_generado VARCHAR(50);
            
            -- GENERAR NÚMERO DE CONTRATO AUTOMÁTICO SI NO SE PROPORCIONA
            IF @numero_contrato IS NULL OR @numero_contrato = ''
            BEGIN
                -- Generar número único basado en año y secuencia
                DECLARE @anio VARCHAR(4) = CAST(YEAR(GETDATE()) AS VARCHAR);
                DECLARE @secuencia INT;
                
                -- Obtener el siguiente número de secuencia
                SELECT @secuencia = ISNULL(MAX(CAST(RIGHT(numero_contrato, 3) AS INT)), 0) + 1
                FROM contratos 
                WHERE numero_contrato LIKE 'CTR-' + @anio + '-%';
                
                SET @numero_generado = 'CTR-' + @anio + '-' + RIGHT('000' + CAST(@secuencia AS VARCHAR), 3);
                SET @numero_contrato = @numero_generado;
                
                PRINT '📋 Número de contrato generado automáticamente: ' + @numero_contrato;
            END
            ELSE
            BEGIN
                -- VALIDAR QUE NO EXISTA EL NÚMERO PROPORCIONADO
                IF EXISTS (SELECT 1 FROM contratos WHERE numero_contrato = @numero_contrato)
                BEGIN
                    PRINT '❌ ERROR: Ya existe el número de contrato: ' + @numero_contrato;
                    PRINT '💡 Sugerencia: Deja el parámetro @numero_contrato en NULL para generación automática';
                    RETURN;
                END
            END
            
            -- Validar que el paquete existe
            IF @tipo_contrato = 'paquete' AND @paquete_nombre IS NOT NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM paquetes WHERE nombre = @paquete_nombre)
                BEGIN
                    PRINT '❌ ERROR: El paquete no existe: ' + @paquete_nombre;
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
            
            -- ✅ RETORNAR INFORMACIÓN DEL CONTRATO CREADO (CORREGIDO)
            SELECT 
                c.id AS contrato_creado,
                c.numero_contrato,
                c.precio_mensual,
                COUNT(cs.id) AS servicios_incluidos,
                STRING_AGG(cs.servicio_nombre, ', ') AS servicios_detalle
            FROM contratos c
            LEFT JOIN contratos_servicios cs ON c.id = cs.contrato_id
            WHERE c.id = @contrato_id
            GROUP BY c.id, c.numero_contrato, c.precio_mensual;
            
        END TRY
        BEGIN CATCH
            PRINT '❌ ERROR EN PROCEDIMIENTO:';
            PRINT 'Número de Error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
            PRINT 'Mensaje: ' + ERROR_MESSAGE();
            PRINT 'Línea: ' + CAST(ERROR_LINE() AS VARCHAR);
            
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH
    END;


    EXEC sp_crear_contrato_completo_mejorado
    @suscriptor_id = 1,
    @numero_contrato = NULL,  -- NULL = genera automáticamente
    @tipo_contrato = 'paquete',
    @paquete_nombre = 'Dúo Básico',
    @notas = 'Contrato con número generado automáticamente';

-- ===============================================
-- OPCIÓN 2: NÚMERO MANUAL ÚNICO
-- ===============================================

EXEC sp_crear_contrato_completo_mejorado
    @suscriptor_id = 2,
    @numero_contrato = 'CTR-2025-006',  -- Número único manual
    @tipo_contrato = 'paquete',
    @paquete_nombre = 'Triple Play Básico',
    @notas = 'Contrato con número manual único';



    
    