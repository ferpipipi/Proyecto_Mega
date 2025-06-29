USE PracticaMega
GO

-- Llenar tabla tipos_suscriptores con diferentes categorías
INSERT INTO tipos_suscriptores (codigo, nombre, descripcion, descuento_porcentaje, requiere_contrato_especial, activo) VALUES 
-- Casa Habitacional
('RES', 'Casa Habitacional', 'Suscriptores residenciales para uso doméstico familiar', 0.00, 0, 1),

-- Empresas
('EMP', 'Empresas', 'Empresas privadas, comercios y negocios', 5.00, 1, 1),

-- Empleados
('EMPL', 'Empleados', 'Empleados de la empresa con descuento especial', 15.00, 0, 1),

-- Asociaciones Civiles
('AC', 'Asociaciones Civiles', 'Organizaciones sin fines de lucro y asociaciones civiles', 25.00, 1, 1),

-- Gobierno Público
('GOB', 'Gobierno Público', 'Dependencias gubernamentales y oficinas públicas', 12.00, 1, 1),

-- Escuelas
('ESC', 'Escuelas', 'Instituciones educativas públicas y privadas', 20.00, 1, 1),

-- Donaciones y Caridad
('CARIDAD', 'Donaciones Caridad', 'Organizaciones benéficas y de asistencia social', 30.00, 1, 1),

-- Cliente Interno
('INTERNO', 'Cliente Interno', 'Personal interno de la empresa y familiares', 50.00, 0, 1);

-- Verificar inserción
SELECT * FROM tipos_suscriptores ORDER BY descuento_porcentaje;

-- Ver resumen por descuentos
SELECT 
    codigo,
    nombre,
    descuento_porcentaje,
    CASE 
        WHEN requiere_contrato_especial = 1 THEN 'Sí'
        ELSE 'No'
    END AS contrato_especial,
    CASE 
        WHEN activo = 1 THEN 'Activo'
        ELSE 'Inactivo'
    END AS estado
FROM tipos_suscriptores
ORDER BY descuento_porcentaje DESC;