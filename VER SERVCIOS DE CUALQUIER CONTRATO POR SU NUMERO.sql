-- ===============================================
-- SERVICIOS Y PAQUETES DEL CONTRATO CTR-2025-001
-- ===============================================



-- Ver todos los servicios del contrato
SELECT 
    'SERVICIOS CONTRATADOS:' AS detalle,
    cs.id AS servicio_id,
    cs.servicio_nombre,
    cs.paquete_nombre,
    srv.precio_base AS precio_original,
    cs.descuento AS descuento_porcentaje,
    (srv.precio_base * (1 - ISNULL(cs.descuento, 0)/100)) AS precio_con_descuento,
    cs.fecha_inicio AS fecha_contratacion,
    cs.estado AS estado_servicio,
    srv.tipos_servicios_sku AS categoria
FROM contratos_servicios cs
INNER JOIN servicios srv ON cs.servicio_nombre = srv.nombre
INNER JOIN contratos c ON cs.contrato_id = c.id
WHERE c.numero_contrato = 'CTR-2025-001'
    AND cs.estado = 'activo'
ORDER BY cs.fecha_inicio DESC;

-- Resumen por categoría de servicios
SELECT 
    'RESUMEN POR CATEGORÍA:' AS resumen,
    srv.tipos_servicios_sku AS categoria,
    COUNT(*) AS cantidad_servicios,
    SUM(srv.precio_base) AS costo_sin_descuento,
    SUM(srv.precio_base * (1 - ISNULL(cs.descuento, 0)/100)) AS costo_con_descuento,
    SUM(srv.precio_base * (ISNULL(cs.descuento, 0)/100)) AS total_ahorrado
FROM contratos_servicios cs
INNER JOIN servicios srv ON cs.servicio_nombre = srv.nombre
INNER JOIN contratos c ON cs.contrato_id = c.id
WHERE c.numero_contrato = 'CTR-2025-001'
    AND cs.estado = 'activo'
GROUP BY srv.tipos_servicios_sku
ORDER BY costo_con_descuento DESC;

-- Ver promociones activas aplicadas
SELECT 
    'PROMOCIONES ACTIVAS:' AS promociones,
    p.nombre AS promocion,
    p.codigo_promocional AS codigo,
    p.valor_descuento,
    p.es_porcentaje,
    cp.fecha_aplicacion,
    cp.fecha_vencimiento,
    DATEDIFF(DAY, GETDATE(), cp.fecha_vencimiento) AS dias_restantes
FROM contratos_promociones cp
INNER JOIN promociones p ON cp.promocion_id = p.id
INNER JOIN contratos c ON cp.contrato_id = c.id
WHERE c.numero_contrato = 'CTR-2025-001'
    AND cp.activo = 1
    AND cp.fecha_vencimiento > GETDATE();