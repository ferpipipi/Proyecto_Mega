-- -- ===============================================
-- -- SP PARA SINCRONIZAR SOLO PRECIOS BASE (SIN DESCUENTO)
-- -- ===============================================

-- CREATE OR ALTER PROCEDURE sp_sincronizar_precios_paquetes
-- AS
-- BEGIN
--     BEGIN TRY
--         PRINT '🔄 Sincronizando precios base de paquetes (sin descuento)...';
        
--         -- ⭐ ACTUALIZAR precio_total SOLO CON SUMA DE SERVICIOS (SIN DESCUENTO)
--         UPDATE p
--         SET precio_total = totales.suma_servicios_base
--         FROM paquetes p
--         INNER JOIN (
--             SELECT 
--                 ps.paquete_nombre,
--                 SUM(ps.precio_unitario * ISNULL(ps.cantidad, 1)) AS suma_servicios_base,
--                 COUNT(*) AS cantidad_servicios
--             FROM paquetes_servicios ps
--             WHERE ps.activo = 1
--             GROUP BY ps.paquete_nombre
--         ) totales ON p.nombre = totales.paquete_nombre;
        
--         -- Mostrar resultados
--         SELECT 
--             'PAQUETES SINCRONIZADOS (PRECIO BASE)' AS resultado,
--             p.nombre AS paquete,
--             p.precio_total AS precio_base_actualizado,
--             p.descuento_porcentaje AS descuento_del_paquete,
--             p.precio_total * (1 - p.descuento_porcentaje/100) AS precio_final_con_descuento,
--             COUNT(ps.servicio_nombre) AS servicios_incluidos
--         FROM paquetes p
--         INNER JOIN paquetes_servicios ps ON p.nombre = ps.paquete_nombre
--         WHERE ps.activo = 1
--         GROUP BY p.id, p.nombre, p.precio_total, p.descuento_porcentaje
--         ORDER BY p.nombre;
        
--         PRINT '✅ Precios base sincronizados (descuento se aplica en contratos)';
        
--     END TRY
--     BEGIN CATCH
--         PRINT '❌ ERROR en sincronización: ' + ERROR_MESSAGE();
--     END CATCH
-- END;


===============================================
TRIGGER SIMPLE PARA SINCRONIZAR PRECIOS BASE
===============================================

CREATE OR ALTER TRIGGER tr_sincronizar_precios_base_paquetes
ON paquetes_servicios
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Obtener paquetes afectados
    DECLARE @paquetes_afectados TABLE (paquete_nombre VARCHAR(100));
    
    INSERT INTO @paquetes_afectados
    SELECT DISTINCT paquete_nombre FROM inserted WHERE paquete_nombre IS NOT NULL
    UNION
    SELECT DISTINCT paquete_nombre FROM deleted WHERE paquete_nombre IS NOT NULL;
    
    -- ⭐ ACTUALIZAR SOLO PRECIO BASE (SIN DESCUENTO)
    UPDATE p
    SET precio_total = ISNULL(totales.suma_servicios_base, 0)
    FROM paquetes p
    INNER JOIN (
        SELECT 
            ps.paquete_nombre,
            SUM(ps.precio_unitario * ISNULL(ps.cantidad, 1)) AS suma_servicios_base
        FROM paquetes_servicios ps
        WHERE ps.activo = 1
            AND ps.paquete_nombre IN (SELECT paquete_nombre FROM @paquetes_afectados)
        GROUP BY ps.paquete_nombre
    ) totales ON p.nombre = totales.paquete_nombre
    WHERE p.nombre IN (SELECT paquete_nombre FROM @paquetes_afectados);
    
    PRINT '🔄 Precios base de paquetes sincronizados (descuento se aplica en contratos)';
END;

