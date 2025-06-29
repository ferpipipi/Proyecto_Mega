USE PracticaMega
GO

-- Llenar tabla servicios con servicios específicos por tipo
INSERT INTO servicios (nombre, tipo_servicio_id, velocidad, precio_base, descripcion, activo) VALUES 

-- ============================================
-- SERVICIOS DE INTERNET (tipo_servicio_id = 1) - 5 servicios
-- ============================================
('Internet Básico 50MB', 1, '50 Mbps', 399.00, 'Plan básico de internet ideal para navegación web y redes sociales', 1),
('Internet Estándar 100MB', 1, '100 Mbps', 599.00, 'Plan estándar perfecto para streaming y trabajo desde casa', 1),
('Internet Premium 200MB', 1, '200 Mbps', 899.00, 'Plan premium para familias numerosas y uso intensivo', 1),
('Internet Pro 500MB', 1, '500 Mbps', 1299.00, 'Plan profesional para empresas y gamers exigentes', 1),
('Internet Ultra 1GB', 1, '1 Gbps', 1999.00, 'Máxima velocidad disponible para uso comercial y streaming 4K', 1),

-- ============================================
-- SERVICIOS DE CABLE (tipo_servicio_id = 2) - 6 servicios
-- ============================================
('Cable Básico', 2, NULL, 299.00, 'Paquete básico con 80+ canales nacionales e internacionales', 1),
('Cable Estándar', 2, NULL, 399.00, 'Paquete estándar con 120+ canales incluyendo canales HD', 1),
('Cable Premium', 2, NULL, 549.00, 'Paquete premium con 180+ canales HD y canales deportivos', 1),
('Cable Elite', 2, NULL, 699.00, 'Paquete elite con todos los canales premium y HBO', 1),
('Cable Deportivo', 2, NULL, 799.00, 'Paquete especializado en deportes con ESPN, Fox Sports y más', 1),
('Cable Familiar', 2, NULL, 449.00, 'Paquete familiar con canales infantiles, educativos y entretenimiento', 1),

-- ============================================
-- SERVICIOS DE TELEFONÍA (tipo_servicio_id = 3) - 1 servicio
-- ============================================
('Línea Telefónica Ilimitada', 3, NULL, 249.00, 'Servicio de telefonía fija con llamadas nacionales ilimitadas', 1),

-- ============================================
-- SERVICIOS DE TELEFONÍA MÓVIL (tipo_servicio_id = 4) - 4 servicios
-- ============================================
('Plan Móvil Básico 3GB', 4, '4G LTE', 299.00, 'Plan móvil básico con 3GB de datos y llamadas ilimitadas', 1),
('Plan Móvil Estándar 8GB', 4, '4G LTE', 449.00, 'Plan móvil estándar con 8GB de datos y redes sociales gratis', 1),
('Plan Móvil Premium 15GB', 4, '4G/5G', 649.00, 'Plan premium con 15GB de datos y streaming de música gratis', 1),
('Plan Móvil Ilimitado', 4, '5G', 899.00, 'Plan ilimitado con datos sin límite y velocidad 5G', 1),

-- ============================================
-- SERVICIOS DE SOPORTE TÉCNICO (tipo_servicio_id = 5) - 3 servicios
-- ============================================
('Instalación Básica', 5, NULL, 199.00, 'Servicio de instalación básica de equipos y configuración inicial', 1),
('Soporte Técnico Premium', 5, NULL, 399.00, 'Soporte técnico 24/7 con visitas a domicilio incluidas', 1),
('Mantenimiento Preventivo', 5, NULL, 299.00, 'Servicio de mantenimiento preventivo trimestral de equipos', 1);



-- ===============================================
  -- INSERTAR 10 SERVICIOS CATV ADICIONALES
-- ===============================================
  
  INSERT INTO servicios (tipos_servicios_sku, nombre, velocidad, precio_base, descripcion, activo) VALUES
  -- Servicios de Streaming
  ('CATV', 'NETFLIX Premium', NULL, 149.00, 'Plataforma de contenidos streaming - películas y series en 4K', 1),
  ('CATV', 'AMAZON Prime Video', NULL, 139.00, 'Servicio de streaming Amazon con películas, series y deportes', 1),
  ('CATV', 'DISNEY+', NULL, 149.00, 'Plataforma Disney con contenido familiar, Marvel, Star Wars', 1),
  ('CATV', 'HBO MAX', NULL, 169.00, 'Streaming premium con series originales y películas taquilleras', 1),
  ('CATV', 'PARAMOUNT+', NULL, 139.00, 'Contenido de Paramount Pictures y series exclusivas', 1),
  
  -- Canales Premium
  ('CATV', 'GOLDEN PREMIER', NULL, 189.00, 'Canal premium con películas recientes y contenido exclusivo', 1),
  ('CATV', 'FOX Premium Action', NULL, 129.00, 'Canal especializado en acción, suspenso y thrillers', 1),
  ('CATV', 'TNT Series', NULL, 119.00, 'Canal dedicado a las mejores series de televisión', 1),
  
  -- Paquetes Deportivos
  ('CATV', 'ESPN Premium Pack', NULL, 199.00, 'Paquete completo ESPN con todos los deportes en vivo', 1),
  ('CATV', 'FOX Sports Premium', NULL, 179.00, 'Canales deportivos FOX con fútbol internacional y NFL', 1);
  
  PRINT '✅ 10 servicios CATV adicionales insertados correctamente';

  SELECT TOP (1000) [id]
      ,[tipos_servicios_sku]
      ,[nombre]
      ,[velocidad]
      ,[precio_base]
      ,[descripcion]
      ,[activo]
  FROM [PracticaMega].[dbo].[servicios]
-- Verificar inserción
SELECT * FROM servicios;
SELECT COUNT(*) AS total_servicios FROM servicios;

