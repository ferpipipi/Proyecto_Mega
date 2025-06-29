USE PracticaMega
GO
-- cargado de la base de datos de ESTADOS...
-- Llenar campos de tabla estados con nombres y abreviaturas oficiales
INSERT INTO estados (nombre, abreviatura) VALUES 
('Aguascalientes', 'AGS'),
('Baja California', 'BC'),
('Baja California Sur', 'BCS'),
('Campeche', 'CAM'),
('Chiapas', 'CHIS'),
('Chihuahua', 'CHIH'),
('Coahuila', 'COAH'),
('Colima', 'COL'),
('Durango', 'DGO'),
('Guanajuato', 'GTO'),
('Guerrero', 'GRO'),
('Hidalgo', 'HGO'),
('Jalisco', 'JAL'),
('México', 'MEX'),
('Michoacán', 'MICH'),
('Morelos', 'MOR'),
('Nayarit', 'NAY'),
('Nuevo León', 'NL'),
('Oaxaca', 'OAX'),
('Puebla', 'PUE'),
('Querétaro', 'QRO'),
('Quintana Roo', 'QROO'),
('San Luis Potosí', 'SLP'),
('Sinaloa', 'SIN'),
('Sonora', 'SON'),
('Tabasco', 'TAB'),
('Tamaulipas', 'TAMPS'),
('Tlaxcala', 'TLAX'),
('Veracruz', 'VER'),
('Yucatán', 'YUC'),
('Zacatecas', 'ZAC'),
('Ciudad de México', 'CDMX');

-- Verificar que se insertaron correctamente
SELECT id, nombre, abreviatura FROM estados ORDER BY nombre;
