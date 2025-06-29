USE PracticaMega
GO

-- Llenar tabla paquetes con combinaciones de Internet, Cable y Telefonía
INSERT INTO paquetes (nombre, descripcion, precio_total, descuento_porcentaje, activo) VALUES 

-- ============================================
-- PAQUETE 1: DÚOS (Internet + Cable)
-- ============================================
('Dúo Básico', 
 'Paquete básico que incluye Internet 50MB + Cable Básico. Ideal para hogares pequeños con necesidades básicas de entretenimiento y navegación.', 
 649.00, 8.00, 1),

('Dúo Premium', 
 'Paquete premium con Internet 200MB + Cable Premium. Perfecto para familias que disfrutan del streaming y canales HD.', 
 1299.00, 12.00, 1),

-- ============================================
-- PAQUETE 2: TRIPLE PLAY (Internet + Cable + Telefonía)
-- ============================================
('Triple Play Básico', 
 'Paquete completo con Internet 100MB + Cable Estándar + Línea Telefónica. La solución integral para el hogar moderno.', 
 1099.00, 15.00, 1),

('Triple Play Premium', 
 'Paquete premium con Internet 500MB + Cable Elite + Línea Telefónica. Para familias exigentes que requieren la mejor experiencia.', 
 1899.00, 18.00, 1),

-- ============================================
-- PAQUETE 3: ESPECIALIZADOS
-- ============================================
('Paquete Empresarial', 
 'Solución empresarial con Internet 1GB + Cable Básico + Línea Telefónica + Soporte Técnico Premium. Diseñado para pequeñas y medianas empresas.', 
 2499.00, 10.00, 1),

('Paquete Estudiante', 
 'Paquete económico con Internet 100MB + Cable Familiar + Línea Telefónica. Especial para estudiantes y familias jóvenes.', 
 899.00, 20.00, 1);

-- Verificar inserción
SELECT * FROM paquetes ORDER BY precio_total;

-- Ver paquetes con descuentos
SELECT 
    nombre,
    precio_total,
    descuento_porcentaje,
    ROUND(precio_total * (1 - descuento_porcentaje/100), 2) AS precio_con_descuento,
    ROUND(precio_total * descuento_porcentaje/100, 2) AS ahorro
FROM paquetes
WHERE activo = 1
ORDER BY precio_total;

-- Resumen por tipo de paquete
SELECT 
    CASE 
        WHEN nombre LIKE '%Dúo%' THEN 'Dúo (Internet + Cable)'
        WHEN nombre LIKE '%Triple%' THEN 'Triple Play (Completo)'
        ELSE 'Especializado'
    END AS tipo_paquete,
    COUNT(*) AS cantidad,
    AVG(precio_total) AS precio_promedio,
    AVG(descuento_porcentaje) AS descuento_promedio
FROM paquetes
WHERE activo = 1
GROUP BY 
    CASE 
        WHEN nombre LIKE '%Dúo%' THEN 'Dúo (Internet + Cable)'
        WHEN nombre LIKE '%Triple%' THEN 'Triple Play (Completo)'
        ELSE 'Especializado'
    END
ORDER BY precio_promedio;