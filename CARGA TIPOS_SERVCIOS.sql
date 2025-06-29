USE PracticaMega
GO

-- Llenar tabla tipos_servicios con categorías de servicios
INSERT INTO tipos_servicios (sku, nombre, descripcion, activo) VALUES 
-- Internet
('INET', 'Internet', 'Servicios de conexión a internet de alta velocidad con diferentes velocidades y planes', 1),

-- Cable
('CATV', 'Cable', 'Servicios de televisión por cable con canales HD, premium y paquetes deportivos', 1),

-- Telefonía Fija
('FONE', 'Telefonía', 'Servicios de telefonía fija con llamadas locales, nacionales e internacionales', 1),

-- Telefonía Móvil
('MOBILE', 'Telefonía Móvil', 'Servicios de telefonía celular con planes de datos, voz y mensajería', 1),

-- Soporte Técnico
('SUPPORT', 'Soporte Técnico', 'Servicios de soporte técnico especializado, instalación y mantenimiento', 1);

-- Verificar inserción
SELECT * FROM tipos_servicios ORDER BY sku;

