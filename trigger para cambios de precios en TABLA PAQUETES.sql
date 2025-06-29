--  ============================================================================================================
--  TRIGGER PARA CALCULAR AUTOMÁTICAMENTE precio_total EN TABLA PAQUETES:
--  ============================================================================================================

-- ===============================================
-- TRIGGER PARA CÁLCULO AUTOMÁTICO DE PRECIO_TOTAL
-- ===============================================

CREATE OR ALTER TRIGGER tr_calcular_precio_total_paquetes
ON paquetes_servicios
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Declarar tabla temporal para paquetes afectados
    DECLARE @paquetes_afectados TABLE (paquete_nombre VARCHAR(100));
    
    -- Obtener nombres de paquetes afectados por INSERT/UPDATE
    IF EXISTS(SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO @paquetes_afectados (paquete_nombre)
        SELECT DISTINCT paquete_nombre 
        FROM inserted 
        WHERE paquete_nombre IS NOT NULL;
    END
    
    -- Obtener nombres de paquetes afectados por DELETE
    IF EXISTS(SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO @paquetes_afectados (paquete_nombre)
        SELECT DISTINCT paquete_nombre 
        FROM deleted 
        WHERE paquete_nombre IS NOT NULL
            AND paquete_nombre NOT IN (SELECT paquete_nombre FROM @paquetes_afectados);
    END
    
    -- Actualizar precio_total para cada paquete afectado
    UPDATE p
    SET precio_total = ROUND(
        ISNULL(calc.suma_precio_unitario, 0) * 
        (1 - ISNULL(p.descuento_porcentaje, 0) / 100.0), 
        2
    )
    FROM paquetes p
    INNER JOIN @paquetes_afectados pa ON p.nombre = pa.paquete_nombre
    LEFT JOIN (
        SELECT 
            ps.paquete_nombre,
            SUM(ps.precio_unitario * ps.cantidad) AS suma_precio_unitario
        FROM paquetes_servicios ps
        WHERE ps.activo = 1
        GROUP BY ps.paquete_nombre
    ) calc ON p.nombre = calc.paquete_nombre;
    
    -- Mensaje informativo (opcional - remover en producción)
    PRINT 'Trigger ejecutado: precio_total actualizado para paquetes afectados';
    
END;

--  ============================================================================================================
-- TRIGGER ADICIONAL PARA CAMBIOS EN TABLA PAQUETES:
--  ============================================================================================================

-- ===============================================
-- TRIGGER PARA CAMBIOS EN DESCUENTO_PORCENTAJE
-- ===============================================

CREATE OR ALTER TRIGGER tr_recalcular_precio_por_descuento
ON paquetes
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Solo ejecutar si cambió descuento_porcentaje
    IF UPDATE(descuento_porcentaje)
    BEGIN
        UPDATE p
        SET precio_total = ROUND(
            ISNULL(calc.suma_precio_unitario, 0) * 
            (1 - ISNULL(p.descuento_porcentaje, 0) / 100.0), 
            2
        )
        FROM paquetes p
        INNER JOIN inserted i ON p.id = i.id
        LEFT JOIN (
            SELECT 
                ps.paquete_nombre,
                SUM(ps.precio_unitario * ps.cantidad) AS suma_precio_unitario
            FROM paquetes_servicios ps
            WHERE ps.activo = 1
            GROUP BY ps.paquete_nombre
        ) calc ON p.nombre = calc.paquete_nombre;
        
        PRINT 'Precio recalculado por cambio en descuento_porcentaje';
    END
END;


--  ============================================================================================================
--  VERIFICACIÓN Y PRUEBA DEL TRIGGER:
--  ============================================================================================================

-- ===============================================
-- PRUEBAS DEL TRIGGER
-- ===============================================

-- Ver estado actual antes de la prueba
SELECT 
    'ANTES DE LA PRUEBA:' AS estado,
    p.nombre AS paquete,
    ISNULL(calc.suma_servicios, 0) AS suma_servicios,
    p.descuento_porcentaje AS descuento,
    p.precio_total AS precio_actual
FROM paquetes p
LEFT JOIN (
    SELECT 
        ps.paquete_nombre,
        SUM(ps.precio_unitario * ps.cantidad) AS suma_servicios
    FROM paquetes_servicios ps
    WHERE ps.activo = 1
    GROUP BY ps.paquete_nombre
) calc ON p.nombre = calc.paquete_nombre
ORDER BY p.nombre;

-- PRUEBA 1: Insertar un nuevo servicio a un paquete
INSERT INTO paquetes_servicios (
    paquete_nombre, servicio_nombre, cantidad, precio_unitario, activo
) VALUES 
('Dúo Básico', 'Instalación Básica', 1, 199.00, 1);

-- PRUEBA 2: Cambiar descuento de un paquete
UPDATE paquetes 
SET descuento_porcentaje = 15.0 
WHERE nombre = 'Dúo Premium';

-- Ver resultado después de las pruebas
SELECT 
    'DESPUÉS DE LA PRUEBA:' AS estado,
    p.nombre AS paquete,
    ISNULL(calc.suma_servicios, 0) AS suma_servicios,
    p.descuento_porcentaje AS descuento,
    p.precio_total AS precio_actualizado,
    ROUND(ISNULL(calc.suma_servicios, 0) * (1 - p.descuento_porcentaje/100), 2) AS precio_esperado
FROM paquetes p
LEFT JOIN (
    SELECT 
        ps.paquete_nombre,
        SUM(ps.precio_unitario * ps.cantidad) AS suma_servicios
    FROM paquetes_servicios ps
    WHERE ps.activo = 1
    GROUP BY ps.paquete_nombre
) calc ON p.nombre = calc.paquete_nombre
ORDER BY p.nombre;