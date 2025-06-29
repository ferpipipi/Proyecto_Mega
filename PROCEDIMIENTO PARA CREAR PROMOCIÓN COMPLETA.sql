-- ===============================================
-- PROCEDIMIENTO PARA CREAR PROMOCIÓN COMPLETA
-- ===============================================

CREATE OR ALTER PROCEDURE sp_crear_promocion_completa
    @nombre VARCHAR(100),
    @descripcion TEXT,
    @tipo_promocion VARCHAR(50), -- 'descuento_porcentaje', 'descuento_fijo', 'meses_gratis'
    @valor_descuento DECIMAL(10,2),
    @es_porcentaje BIT,
    @duracion_meses INT,
    @fecha_inicio DATE,
    @fecha_fin DATE,
    @codigo_promocional VARCHAR(20) = NULL,
    @servicios_aplicables VARCHAR(MAX) = NULL, -- JSON o lista separada por comas
    @limite_usos INT = NULL
AS
BEGIN
    BEGIN TRY
        DECLARE @promocion_id INT;
        
        -- Crear promoción principal
        INSERT INTO promociones (
            nombre, descripcion, tipo_promocion, valor_descuento,
            es_porcentaje, duracion_meses, fecha_inicio, fecha_fin,
            codigo_promocional, limite_usos, activo
        ) VALUES (
            @nombre, @descripcion, @tipo_promocion, @valor_descuento,
            @es_porcentaje, @duracion_meses, @fecha_inicio, @fecha_fin,
            @codigo_promocional, @limite_usos, 1
        );
        
        SET @promocion_id = SCOPE_IDENTITY();
        
        -- Si se especificaron servicios, agregarlos
        IF @servicios_aplicables IS NOT NULL
        BEGIN
            -- Insertar servicios (asumiendo lista separada por comas)
            INSERT INTO promociones_servicios (promocion_id, servicio_nombre)
            SELECT 
                @promocion_id,
                LTRIM(RTRIM(value)) AS servicio_nombre
            FROM STRING_SPLIT(@servicios_aplicables, ',')
            WHERE LTRIM(RTRIM(value)) != '';
        END
        
        -- ✅ CONSULTA CORRECTA CON GROUP BY VÁLIDO
        SELECT 
            p.id AS promocion_id,
            p.nombre AS nombre_promocion,
            p.codigo_promocional AS codigo,
            p.fecha_inicio,
            p.fecha_fin,
            COUNT(ps.id) AS servicios_incluidos
        FROM promociones p
        LEFT JOIN promociones_servicios ps ON p.id = ps.promocion_id
        WHERE p.id = @promocion_id
        GROUP BY p.id, p.nombre, p.codigo_promocional, p.fecha_inicio, p.fecha_fin;
        
        PRINT '✅ Promoción creada exitosamente: ' + @nombre;
        
    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR: ' + ERROR_MESSAGE();
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    END CATCH
END;

-- ===============================================
-- CREAR PROMOCIONES DE EJEMPLO
-- ===============================================

-- Promoción 1: 20% descuento en servicios streaming por 3 meses
EXEC sp_crear_promocion_completa
    @nombre = 'Streaming Verano 2025',
    @descripcion = '20% de descuento en todos los servicios de streaming por 3 meses',
    @tipo_promocion = 'descuento_porcentaje',
    @valor_descuento = 20.0,
    @es_porcentaje = 1,
    @duracion_meses = 3,
    @fecha_inicio = '2025-06-01',
    @fecha_fin = '2025-08-31',
    @codigo_promocional = 'STREAM2025',
    @servicios_aplicables = 'NETFLIX Premium,HBO MAX,DISNEY+,PARAMOUNT+',
    @limite_usos = 100;

-- ===============================================
-- PROMOCIÓN REGRESO A CLASES
-- ===============================================

EXEC sp_crear_promocion_completa
    @nombre = 'Regreso a Clases',
    @descripcion = '$99 pesos de descuento en servicios de Internet por 3 meses',
    @tipo_promocion = 'descuento_fijo',
    @valor_descuento = 99.0,
    @es_porcentaje = 0,
    @duracion_meses = 3,
    @fecha_inicio = '2025-08-01',
    @fecha_fin = '2025-09-30',
    @codigo_promocional = 'REGRESO99',
    @servicios_aplicables = 'Internet Básico 50MB,Internet Premium 200MB,Internet Pro 500MB',
    @limite_usos = 75;

        -- Crear promoción solo para Netflix
    EXEC sp_crear_promocion_completa
        @nombre = 'Netflix Solo 20%',
        @descripcion = '20% descuento solo en Netflix Premium',
        @tipo_promocion = 'descuento_porcentaje',
        @valor_descuento = 20.0,
        @es_porcentaje = 1,
        @duracion_meses = 3,
        @fecha_inicio = '2025-06-01',
        @fecha_fin = '2025-08-31',
        @codigo_promocional = 'NETFLIX20',
        @servicios_aplicables = 'NETFLIX Premium',  -- Solo Netflix
        @limite_usos = 100;


-- ===============================================
-- PROMOCIÓN NAVIDEÑA MOBILE
-- ===============================================

EXEC sp_crear_promocion_completa
    @nombre = 'Navidad Mobile 2025',
    @descripcion = '$149 pesos de descuento en planes móviles durante la temporada navideña',
    @tipo_promocion = 'descuento_fijo',
    @valor_descuento = 149.0,
    @es_porcentaje = 0,
    @duracion_meses = 2,
    @fecha_inicio = '2025-12-01',
    @fecha_fin = '2025-12-31',
    @codigo_promocional = 'NAVIDAD149',
    @servicios_aplicables = 'Plan Móvil Premium 15GB,Plan Móvil Ilimitado',
    @limite_usos = 200;
    