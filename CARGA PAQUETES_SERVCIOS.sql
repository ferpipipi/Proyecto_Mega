SELECT TOP (1000) [id]
      ,[paquete_nombre]
      ,[servicio_nombre ]
      ,[cantidad]
      ,[precio_unitario]
      ,[descuento_porcentaje]
      ,[activo]
      ,[fecha_agregado]
  FROM [PracticaMega].[dbo].[paquetes_servicios]

  -- ============================================
-- LLENAR paquetes_servicios SEGÚN PAQUETES Y SERVICIOS
-- ============================================

-- -- 1. DÚO BÁSICO: Internet 50MB + Cable Básico
-- INSERT INTO paquetes_servicios (
--     paquete_nombre, servicio_nombre, cantidad, 
--     precio_unitario, descuento_porcentaje, activo
-- ) VALUES
-- ('Dúo Básico', 'Internet Básico 50MB', 1, 399.00, 8.0, 1),
-- ('Dúo Básico', 'Cable Básico', 1, 299.00, 8.0, 1);

-- -- 2. DÚO PREMIUM: Internet 200MB + Cable Premium
-- INSERT INTO paquetes_servicios (
--     paquete_nombre, servicio_nombre, cantidad, 
--     precio_unitario, descuento_porcentaje, activo
-- ) VALUES
-- ('Dúo Premium', 'Internet Premium 200MB', 1, 899.00, 12.0, 1),
-- ('Dúo Premium', 'Cable Premium', 1, 549.00, 12.0, 1);

-- -- 3. TRIPLE PLAY BÁSICO: Internet 100MB + Cable Estándar + Línea Telefónica
-- INSERT INTO paquetes_servicios (
--     paquete_nombre, servicio_nombre, cantidad, 
--     precio_unitario, descuento_porcentaje, activo
-- ) VALUES
-- ('Triple Play Básico', 'Internet Estándar 100MB', 1, 599.00, 15.0, 1),
-- ('Triple Play Básico', 'Cable Estándar', 1, 399.00, 15.0, 1),
-- ('Triple Play Básico', 'Línea Telefónica Ilimitada', 1, 249.00, 15.0, 1);

-- -- 4. TRIPLE PLAY PREMIUM: Internet 500MB + Cable Elite + Línea Telefónica
-- INSERT INTO paquetes_servicios (
--     paquete_nombre, servicio_nombre, cantidad, 
--     precio_unitario, descuento_porcentaje, activo
-- ) VALUES
-- ('Triple Play Premium', 'Internet Pro 500MB', 1, 1299.00, 18.0, 1),
-- ('Triple Play Premium', 'Cable Elite', 1, 699.00, 18.0, 1),
-- ('Triple Play Premium', 'Línea Telefónica Ilimitada', 1, 249.00, 18.0, 1);

-- -- 5. PAQUETE EMPRESARIAL: Internet 1GB + Cable Básico + Línea Telefónica + Soporte Premium
-- INSERT INTO paquetes_servicios (
--     paquete_nombre, servicio_nombre, cantidad, 
--     precio_unitario, descuento_porcentaje, activo
-- ) VALUES
-- ('Paquete Empresarial', 'Internet Ultra 1GB', 1, 1999.00, 10.0, 1),
-- ('Paquete Empresarial', 'Cable Básico', 1, 299.00, 10.0, 1),
-- ('Paquete Empresarial', 'Línea Telefónica Ilimitada', 1, 249.00, 10.0, 1),
-- ('Paquete Empresarial', 'Soporte Técnico Premium', 1, 399.00, 10.0, 1);

-- -- 6. PAQUETE ESTUDIANTE: Internet 100MB + Cable Familiar + Línea Telefónica
-- INSERT INTO paquetes_servicios (
--     paquete_nombre, servicio_nombre, cantidad, 
--     precio_unitario, descuento_porcentaje, activo
-- ) VALUES
-- ('Paquete Estudiante', 'Internet Estándar 100MB', 1, 599.00, 20.0, 1),
-- ('Paquete Estudiante', 'Cable Familiar', 1, 449.00, 20.0, 1),
-- ('Paquete Estudiante', 'Línea Telefónica Ilimitada', 1, 249.00, 20.0, 1);