-- SELECT TOP (1000) [id]
--       ,[suscriptor_id]
--       ,[numero_contrato]
--       ,[fecha_inicio]
--       ,[fecha_fin]
--       ,[estado]
--       ,[precio_mensual]
--       ,[notas]
--       ,[created_at]
--   FROM [PracticaMega].[dbo].[contratos]


-- ===============================================
-- PROCEDIMIENTO MODIFICADO - USA NUMERO_CONTRATO
-- ===============================================

CREATE OR ALTER PROCEDURE sp_agregar_servicio_a_contrato
    @numero_contrato VARCHAR(50),    -- 🔄 CAMBIO: Ahora usa número de contrato
    @servicio_nombre VARCHAR(100),
    @descuento DECIMAL(5,2) = 0.0,
    @fecha_inicio DATE = NULL
AS
BEGIN
    BEGIN TRY
        SET @fecha_inicio = ISNULL(@fecha_inicio, GETDATE());
        
        DECLARE @contrato_id INT;           -- Variable interna para obtener el ID
        DECLARE @precio_servicio DECIMAL(10,2);
        DECLARE @precio_con_descuento DECIMAL(10,2);
        
        -- ✅ OBTENER contrato_id A PARTIR DEL numero_contrato
        SELECT @contrato_id = id 
        FROM contratos 
        WHERE numero_contrato = @numero_contrato AND estado = 'activo';
        
        -- Validar que el contrato existe y está activo
        IF @contrato_id IS NULL
        BEGIN
            PRINT '❌ ERROR: Contrato no encontrado o no está activo: ' + @numero_contrato;
            RETURN;
        END
        
        -- Obtener precio del servicio
        SELECT @precio_servicio = precio_base 
        FROM servicios 
        WHERE nombre = @servicio_nombre AND activo = 1;
        
        IF @precio_servicio IS NULL
        BEGIN
            PRINT '❌ ERROR: Servicio no encontrado o no está activo: ' + @servicio_nombre;
            RETURN;
        END
        
        -- Verificar que no lo tenga ya activo
        IF EXISTS (
            SELECT 1 FROM contratos_servicios 
            WHERE contrato_id = @contrato_id 
                AND servicio_nombre = @servicio_nombre 
                AND estado = 'activo'
        )
        BEGIN
            PRINT '⚠️ ADVERTENCIA: El contrato ya tiene el servicio activo: ' + @servicio_nombre;
            RETURN;
        END
        
        -- Calcular precio con descuento
        SET @precio_con_descuento = @precio_servicio * (1 - @descuento / 100);
        
        -- Agregar el servicio
        INSERT INTO contratos_servicios (
            contrato_id, servicio_nombre, paquete_nombre, 
            descuento, fecha_inicio, estado
        ) VALUES (
            @contrato_id, @servicio_nombre, NULL,
            @descuento, @fecha_inicio, 'activo'
        );
        
        -- Actualizar precio del contrato
        UPDATE contratos 
        SET precio_mensual = precio_mensual + @precio_con_descuento
        WHERE id = @contrato_id;
        
        -- ✅ MOSTRAR RESULTADO CON NUMERO_CONTRATO
        SELECT 
            @numero_contrato AS numero_contrato,     -- Mostrar número en lugar de ID
            @contrato_id AS contrato_id_interno,     -- ID interno para referencia
            @servicio_nombre AS servicio_agregado,
            @precio_servicio AS precio_original,
            @descuento AS descuento_aplicado,
            @precio_con_descuento AS precio_final,
            'Servicio agregado exitosamente' AS resultado;
            
        PRINT '✅ Servicio agregado: ' + @servicio_nombre + ' al contrato: ' + @numero_contrato;
        PRINT 'Costo adicional: $' + CAST(@precio_con_descuento AS VARCHAR);
        
    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR: ' + ERROR_MESSAGE();
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    END CATCH
END;

-- ===============================================
-- EJEMPLOS DE USO CON NUMERO_CONTRATO
-- ===============================================

-- Ejemplo 1: Agregar PARAMOUNT+ usando número de contrato
EXEC sp_agregar_servicio_a_contrato 
    @numero_contrato = 'CTR-2025-001',
    @servicio_nombre = 'PARAMOUNT+',
    @descuento = 0.0;

-- Ejemplo 2: Agregar NETFLIX Premium con descuento
EXEC sp_agregar_servicio_a_contrato 
    @numero_contrato = 'CTR-2025-001',
    @servicio_nombre = 'NETFLIX Premium',
    @descuento = 0.0;

-- -- Ejemplo 3: Agregar HBO MAX a otro contrato
-- EXEC sp_agregar_servicio_a_contrato 
--     @numero_contrato = 'CTR-2025-003',
--     @servicio_nombre = 'HBO MAX',
--     @descuento = 5.0;

-- -- Ejemplo 4: Agregar Disney+ sin descuento
-- EXEC sp_agregar_servicio_a_contrato 
--     @numero_contrato = 'CTR-2025-001',
--     @servicio_nombre = 'DISNEY+',
--     @descuento = 0.0;