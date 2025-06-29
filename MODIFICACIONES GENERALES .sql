SELECT TOP (1000) [id]
      ,[paquete_id]
      ,[servicio_id]
      ,[cantidad]
  FROM [PracticaMega].[dbo].[paquetes_servicios]

  SELECT * FROM paquetes

  SELECT * FROM servicios 

  SELECT * FROM paquetes_servicios

  -- Ver todos los campos y tipos de datos actuales
SELECT 
    COLUMN_NAME AS campo,
    DATA_TYPE AS tipo,
    CHARACTER_MAXIMUM_LENGTH AS longitud,
    IS_NULLABLE AS permite_null,
    COLUMN_DEFAULT AS valor_defecto
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'paquetes_servicios'
ORDER BY ORDINAL_POSITION;

-- Si quieres agregar campos adicionales útiles
ALTER TABLE paquetes_servicios 
ADD precio_unitario DECIMAL(10,2) NULL;

ALTER TABLE paquetes_servicios 
ADD descuento_porcentaje DECIMAL(5,2) NULL;

ALTER TABLE paquetes_servicios 
ADD activo BIT DEFAULT 1;

ALTER TABLE paquetes_servicios 
ADD fecha_agregado DATETIME DEFAULT GETDATE();

-- Agregar restricción UNIQUE para evitar servicios duplicados en el mismo paquete
ALTER TABLE paquetes_servicios 
ADD CONSTRAINT UQ_paquetes_servicios_unico 
UNIQUE (paquete_id, servicio_id);

-- Ver estructura completa de la tabla servicios
SELECT 
    COLUMN_NAME AS campo,
    DATA_TYPE AS tipo_dato,
    CHARACTER_MAXIMUM_LENGTH AS longitud_maxima,
    NUMERIC_PRECISION AS precision_numerica,
    NUMERIC_SCALE AS escala,
    IS_NULLABLE AS permite_null,
    COLUMN_DEFAULT AS valor_por_defecto
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'servicios'
ORDER BY ORDINAL_POSITION;

SELECT 
    COLUMN_NAME AS campo,
    DATA_TYPE AS tipo_dato,
    CHARACTER_MAXIMUM_LENGTH AS longitud_maxima,
    NUMERIC_PRECISION AS precision_numerica,
    NUMERIC_SCALE AS escala,
    IS_NULLABLE AS permite_null,
    COLUMN_DEFAULT AS valor_por_defecto
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'paquetes_servicios'
ORDER BY ORDINAL_POSITION;

-- Cambiar paquete_nombre a VARCHAR(100)
ALTER TABLE paquetes_servicios ALTER COLUMN paquete_nombre VARCHAR(100);

-- Cambiar servicio_nombre a VARCHAR(100)
ALTER TABLE paquetes_servicios ALTER COLUMN servicio_nombre VARCHAR(100);

PRINT 'Campos cambiados a VARCHAR(100) exitosamente';

-- ===============================================
-- 1. ENCONTRAR Y ELIMINAR CONSTRAINT DEPENDIENTE
-- ===============================================

-- Eliminar el constraint que está causando el problema
ALTER TABLE paquetes_servicios 
DROP CONSTRAINT UQ__paquetes__862A201466CC0F5B;

PRINT 'Constraint dependiente eliminado';

-- ===============================================
-- 2. CAMBIAR TIPOS DE DATOS
-- ===============================================

-- Cambiar paquete_nombre a VARCHAR(100)
ALTER TABLE paquetes_servicios ALTER COLUMN paquete_nombre VARCHAR(100);

-- Cambiar servicio_nombre a VARCHAR(100)
ALTER TABLE paquetes_servicios ALTER COLUMN servicio_nombre VARCHAR(100);

PRINT 'Campos cambiados a VARCHAR(100) exitosamente';

-- ===============================================
-- 3. ELIMINAR OTROS CONSTRAINTS SI EXISTEN
-- ===============================================


-- ============================================
-- LLENAR paquetes_servicios SEGÚN PAQUETES Y SERVICIOS
-- ============================================

-- 1. DÚO BÁSICO: Internet 50MB + Cable Básico
INSERT INTO paquetes_servicios (
    paquete_nombre, servicio_nombre, cantidad, 
    precio_unitario, descuento_porcentaje, activo
) VALUES
('Dúo Básico', 'Internet Básico 50MB', 1, 399.00, 8.0, 1),
('Dúo Básico', 'Cable Básico', 1, 299.00, 8.0, 1);

-- 2. DÚO PREMIUM: Internet 200MB + Cable Premium
INSERT INTO paquetes_servicios (
    paquete_nombre, servicio_nombre, cantidad, 
    precio_unitario, descuento_porcentaje, activo
) VALUES
('Dúo Premium', 'Internet Premium 200MB', 1, 899.00, 12.0, 1),
('Dúo Premium', 'Cable Premium', 1, 549.00, 12.0, 1);

-- 3. TRIPLE PLAY BÁSICO: Internet 100MB + Cable Estándar + Línea Telefónica
INSERT INTO paquetes_servicios (
    paquete_nombre, servicio_nombre, cantidad, 
    precio_unitario, descuento_porcentaje, activo
) VALUES
('Triple Play Básico', 'Internet Estándar 100MB', 1, 599.00, 15.0, 1),
('Triple Play Básico', 'Cable Estándar', 1, 399.00, 15.0, 1),
('Triple Play Básico', 'Línea Telefónica Ilimitada', 1, 249.00, 15.0, 1);

-- 4. TRIPLE PLAY PREMIUM: Internet 500MB + Cable Elite + Línea Telefónica
INSERT INTO paquetes_servicios (
    paquete_nombre, servicio_nombre, cantidad, 
    precio_unitario, descuento_porcentaje, activo
) VALUES
('Triple Play Premium', 'Internet Pro 500MB', 1, 1299.00, 18.0, 1),
('Triple Play Premium', 'Cable Elite', 1, 699.00, 18.0, 1),
('Triple Play Premium', 'Línea Telefónica Ilimitada', 1, 249.00, 18.0, 1);

-- 5. PAQUETE EMPRESARIAL: Internet 1GB + Cable Básico + Línea Telefónica + Soporte Premium
INSERT INTO paquetes_servicios (
    paquete_nombre, servicio_nombre, cantidad, 
    precio_unitario, descuento_porcentaje, activo
) VALUES
('Paquete Empresarial', 'Internet Ultra 1GB', 1, 1999.00, 10.0, 1),
('Paquete Empresarial', 'Cable Básico', 1, 299.00, 10.0, 1),
('Paquete Empresarial', 'Línea Telefónica Ilimitada', 1, 249.00, 10.0, 1),
('Paquete Empresarial', 'Soporte Técnico Premium', 1, 399.00, 10.0, 1);

-- 6. PAQUETE ESTUDIANTE: Internet 100MB + Cable Familiar + Línea Telefónica
INSERT INTO paquetes_servicios (
    paquete_nombre, servicio_nombre, cantidad, 
    precio_unitario, descuento_porcentaje, activo
) VALUES
('Paquete Estudiante', 'Internet Estándar 100MB', 1, 599.00, 20.0, 1),
('Paquete Estudiante', 'Cable Familiar', 1, 449.00, 20.0, 1),
('Paquete Estudiante', 'Línea Telefónica Ilimitada', 1, 249.00, 20.0, 1);