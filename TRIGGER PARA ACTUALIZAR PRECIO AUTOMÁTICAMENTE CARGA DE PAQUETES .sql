-- ===============================================
-- TRIGGER CORREGIDO PARA APLICAR DESCUENTO DE PAQUETES
-- ===============================================

CREATE OR ALTER TRIGGER tr_actualizar_precio_contrato
ON contratos_servicios
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    PRINT '🔄 Trigger ejecutándose...';
    
    -- Crear tabla temporal con contratos afectados
    DECLARE @contratos_afectados TABLE (contrato_id INT);
    
    -- Obtener contratos afectados
    INSERT INTO @contratos_afectados
    SELECT DISTINCT contrato_id FROM inserted
    UNION
    SELECT DISTINCT contrato_id FROM deleted;
    
    DECLARE @count INT = (SELECT COUNT(*) FROM @contratos_afectados);
    PRINT '📊 Contratos afectados: ' + CAST(@count AS VARCHAR);
    
    -- ⭐ ACTUALIZAR PRECIO CON LÓGICA MEJORADA PARA PAQUETES
    UPDATE c
    SET precio_mensual = ISNULL(totales.precio_final, 0)
    FROM contratos c
    INNER JOIN (
        SELECT 
            cs.contrato_id,
            -- ⭐ DETECTAR SI ES PAQUETE O SERVICIOS INDIVIDUALES
            CASE 
                WHEN COUNT(DISTINCT cs.paquete_nombre) = 1 AND MAX(cs.paquete_nombre) IS NOT NULL 
                THEN 'PAQUETE'
                ELSE 'INDIVIDUAL'
            END AS tipo_contrato,
            
            -- ⭐ CALCULAR PRECIO SEGÚN EL TIPO
            CASE 
                -- Si es PAQUETE: aplicar descuento del paquete
                WHEN COUNT(DISTINCT cs.paquete_nombre) = 1 AND MAX(cs.paquete_nombre) IS NOT NULL 
                THEN SUM(srv.precio_base) * (1 - MAX(ISNULL(paq.descuento_porcentaje, 0)) / 100)
                
                -- Si es INDIVIDUAL: usar descuentos individuales
                ELSE SUM(srv.precio_base * (1 - ISNULL(cs.descuento, 0) / 100))
            END AS precio_final,
            
            MAX(paq.descuento_porcentaje) AS descuento_paquete_aplicado,
            SUM(srv.precio_base) AS precio_base_total
            
        FROM contratos_servicios cs
        INNER JOIN servicios srv ON cs.servicio_nombre = srv.nombre
        LEFT JOIN paquetes paq ON cs.paquete_nombre = paq.nombre
        WHERE cs.estado = 'activo'
            AND cs.contrato_id IN (SELECT contrato_id FROM @contratos_afectados)
        GROUP BY cs.contrato_id
    ) totales ON c.id = totales.contrato_id
    WHERE c.id IN (SELECT contrato_id FROM @contratos_afectados);
    
    -- ⭐ LOG DETALLADO DEL CÁLCULO
    SELECT 
        'CÁLCULO APLICADO' AS info,
        c.numero_contrato,
        totales.tipo_contrato,
        totales.precio_base_total,
        totales.descuento_paquete_aplicado,
        totales.precio_final,
        c.precio_mensual AS precio_actualizado
    FROM contratos c
    INNER JOIN (
        SELECT 
            cs.contrato_id,
            CASE 
                WHEN COUNT(DISTINCT cs.paquete_nombre) = 1 AND MAX(cs.paquete_nombre) IS NOT NULL 
                THEN 'PAQUETE: ' + MAX(cs.paquete_nombre)
                ELSE 'SERVICIOS INDIVIDUALES'
            END AS tipo_contrato,
            MAX(ISNULL(paq.descuento_porcentaje, 0)) AS descuento_paquete_aplicado,
            SUM(srv.precio_base) AS precio_base_total,
            CASE 
                WHEN COUNT(DISTINCT cs.paquete_nombre) = 1 AND MAX(cs.paquete_nombre) IS NOT NULL 
                THEN SUM(srv.precio_base) * (1 - MAX(ISNULL(paq.descuento_porcentaje, 0)) / 100)
                ELSE SUM(srv.precio_base * (1 - ISNULL(cs.descuento, 0) / 100))
            END AS precio_final
        FROM contratos_servicios cs
        INNER JOIN servicios srv ON cs.servicio_nombre = srv.nombre
        LEFT JOIN paquetes paq ON cs.paquete_nombre = paq.nombre
        WHERE cs.estado = 'activo'
            AND cs.contrato_id IN (SELECT contrato_id FROM @contratos_afectados)
        GROUP BY cs.contrato_id
    ) totales ON c.id = totales.contrato_id
    WHERE c.id IN (SELECT contrato_id FROM @contratos_afectados);
    
    PRINT '✅ Precios actualizados con lógica de paquetes mejorada';
END;

===============================================
VERIFICAR EL PROBLEMA ESPECÍFICO
===============================================

===============================================
FORZAR RECÁLCULO DEL CONTRATO
===============================================

