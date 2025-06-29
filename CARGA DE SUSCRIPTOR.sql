USE PracticaMega
GO

-- Llenar tabla suscriptores con un suscriptor por cada tipo
INSERT INTO suscriptores (nombre, alias, ciudad_id, colonia_id, estados_id, correo, celular, tipo_suscriptor_id) VALUES 

-- Casa Habitacional (tipo_suscriptor_id = 1)
('Juan Carlos Pérez Hernández', 'JC', 121, 1, 13, 'juan.perez@email.com', '3331234567', 1),

-- Empresas (tipo_suscriptor_id = 2)
('Comercializadora ABC S.A. de C.V.', 'ABC Corp', 122, 21, 13, 'contacto@abccorp.com.mx', '3339876543', 2),

-- Empleados (tipo_suscriptor_id = 3)
('María Elena González López', 'Mari', 121, 5, 13, 'maria.gonzalez@megacable.com', '3335555432', 3),

-- Asociaciones Civiles (tipo_suscriptor_id = 4)
('Fundación Niños Felices A.C.', 'Fundación NF', 122, 25, 13, 'admin@ninosfelices.org', '3337778899', 4),

-- Gobierno Público (tipo_suscriptor_id = 5)
('Ayuntamiento de Guadalajara', 'H. Ayto GDL', 121, 1, 13, 'sistemas@guadalajara.gob.mx', '3336661122', 5),

-- Escuelas (tipo_suscriptor_id = 6)
('Instituto Tecnológico Superior', 'ITS Campus', 121, 8, 13, 'direccion@its.edu.mx', '3334445566', 6),

-- Donaciones Caridad (tipo_suscriptor_id = 7)
('Casa Hogar San José A.C.', 'Casa SJ', 122, 30, 13, 'contacto@casasanjose.org', '3332223344', 7),

-- Cliente Interno (tipo_suscriptor_id = 8)
('Roberto Silva Martínez', 'Rob Silva', 121, 12, 13, 'roberto.silva@megacable.com', '3338887766', 8);

-- Verificar inserción
SELECT * FROM suscriptores
SELECT COUNT(*) AS total_suscriptores FROM suscriptores;

-- Ver suscriptores con su tipo
SELECT 
    s.nombre AS suscriptor,
    s.alias,
    ts.nombre AS tipo_suscriptor,
    ts.descuento_porcentaje,
    s.correo,
    s.celular
FROM suscriptores s
INNER JOIN tipos_suscriptores ts ON s.tipo_suscriptor_id = ts.id
ORDER BY ts.id;

-- Ver suscriptores por ciudad y colonia
SELECT 
    s.nombre AS suscriptor,
    c.nombre AS ciudad,
    col.nombre AS colonia,
    e.nombre AS estado
FROM suscriptores s
INNER JOIN ciudades c ON s.ciudad_id = c.id
INNER JOIN colonias col ON s.colonia_id = col.id
INNER JOIN estados e ON s.estados_id = e.id
ORDER BY c.nombre;