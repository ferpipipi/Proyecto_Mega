-- ===============================================
-- TRIGGER PARA ACTUALIZAR PRECIO AUTOMÁTICAMENTE
-- ===============================================

CREATE OR ALTER TRIGGER tr_actualizar_precio_contrato
ON contratos_servicios
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Crear tabla temporal con contratos afectados
    DECLARE @contratos_afectados TABLE (contrato_id INT);
    
    -- Obtener contratos afectados por INSERT/UPDATE
    INSERT INTO @contratos_afectados
    SELECT DISTINCT contrato_id FROM inserted
    UNION
    SELECT DISTINCT contrato_id FROM deleted;
    
    -- Actualizar precio para cada contrato afectado
    UPDATE c
    SET precio_mensual = ISNULL(totales.precio_total, 0)
    FROM contratos c
    INNER JOIN (
        -- Calcular precio total con descuentos por contrato
        SELECT 
            cs.contrato_id,
            SUM(srv.precio_base * (1 - ISNULL(cs.descuento, 0) / 100)) AS precio_total
        FROM contratos_servicios cs
        INNER JOIN servicios srv ON cs.servicio_nombre = srv.nombre
        WHERE cs.estado = 'activo'
            AND cs.contrato_id IN (SELECT contrato_id FROM @contratos_afectados)
        GROUP BY cs.contrato_id
    ) totales ON c.id = totales.contrato_id
    WHERE c.id IN (SELECT contrato_id FROM @contratos_afectados);
    
    -- Actualizar a 0 si no tiene servicios activos
    UPDATE c
    SET precio_mensual = 0
    FROM contratos c
    WHERE c.id IN (SELECT contrato_id FROM @contratos_afectados)
        AND NOT EXISTS (
            SELECT 1 FROM contratos_servicios cs 
            WHERE cs.contrato_id = c.id AND cs.estado = 'activo'
        );
END;