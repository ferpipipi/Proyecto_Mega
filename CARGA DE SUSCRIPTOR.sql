-- USE PracticaMega
-- GO

-- -- Llenar tabla suscriptores con un suscriptor por cada tipo
-- INSERT INTO suscriptores (nombre, alias, ciudad_id, colonia_id, estados_id, correo, celular, tipo_suscriptor_id) VALUES 

-- -- Casa Habitacional (tipo_suscriptor_id = 1)
-- ('Juan Carlos Pérez Hernández', 'JC', 121, 1, 13, 'juan.perez@email.com', '3331234567', 1),

-- -- Empresas (tipo_suscriptor_id = 2)
-- ('Comercializadora ABC S.A. de C.V.', 'ABC Corp', 122, 21, 13, 'contacto@abccorp.com.mx', '3339876543', 2),

-- -- Empleados (tipo_suscriptor_id = 3)
-- ('María Elena González López', 'Mari', 121, 5, 13, 'maria.gonzalez@megacable.com', '3335555432', 3),

-- -- Asociaciones Civiles (tipo_suscriptor_id = 4)
-- ('Fundación Niños Felices A.C.', 'Fundación NF', 122, 25, 13, 'admin@ninosfelices.org', '3337778899', 4),

-- -- Gobierno Público (tipo_suscriptor_id = 5)
-- ('Ayuntamiento de Guadalajara', 'H. Ayto GDL', 121, 1, 13, 'sistemas@guadalajara.gob.mx', '3336661122', 5),

-- -- Escuelas (tipo_suscriptor_id = 6)
-- ('Instituto Tecnológico Superior', 'ITS Campus', 121, 8, 13, 'direccion@its.edu.mx', '3334445566', 6),

-- -- Donaciones Caridad (tipo_suscriptor_id = 7)
-- ('Casa Hogar San José A.C.', 'Casa SJ', 122, 30, 13, 'contacto@casasanjose.org', '3332223344', 7),

-- -- Cliente Interno (tipo_suscriptor_id = 8)
-- ('Roberto Silva Martínez', 'Rob Silva', 121, 12, 13, 'roberto.silva@megacable.com', '3338887766', 8);

-- -- Verificar inserción
-- SELECT * FROM suscriptores
-- SELECT COUNT(*) AS total_suscriptores FROM suscriptores;

-- -- Ver suscriptores con su tipo
-- SELECT 
--     s.nombre AS suscriptor,
--     s.alias,
--     ts.nombre AS tipo_suscriptor,
--     ts.descuento_porcentaje,
--     s.correo,
--     s.celular
-- FROM suscriptores s
-- INNER JOIN tipos_suscriptores ts ON s.tipo_suscriptor_id = ts.id
-- ORDER BY ts.id;

-- -- Ver suscriptores por ciudad y colonia
-- SELECT 
--     s.nombre AS suscriptor,
--     c.nombre AS ciudad,
--     col.nombre AS colonia,
--     e.nombre AS estado
-- FROM suscriptores s
-- INNER JOIN ciudades c ON s.ciudad_id = c.id
-- INNER JOIN colonias col ON s.colonia_id = col.id
-- INNER JOIN estados e ON s.estados_id = e.id
-- ORDER BY c.nombre;

-- ===============================================
-- PROBAR INSERCIÓN DESPUÉS DE ELIMINAR RESTRICCIÓN
-- ===============================================

-- Crear el procedimiento primero (descomenta el código)
CREATE OR ALTER PROCEDURE sp_agregar_suscriptor_final
    @nombre VARCHAR(100),
    @alias VARCHAR(100) = NULL,
    @correo VARCHAR(50),
    @celular VARCHAR(50) = NULL,
    @ciudad_id INT,
    @colonia_id INT,
    @estados_abreviatura VARCHAR(50) = 'JAL',
    @tipo_codigo VARCHAR(12) = 'RES'
AS
BEGIN
    BEGIN TRY
        -- Validar código de tipo suscriptor
        IF @tipo_codigo NOT IN ('RES', 'EMP', 'EMPL', 'AC', 'GOB', 'ESC', 'CARIDAD', 'INTERNO')
        BEGIN
            PRINT '❌ ERROR: Tipo de suscriptor no válido: ' + @tipo_codigo;
            PRINT 'Tipos válidos: RES, EMP, EMPL, AC, GOB, ESC, CARIDAD, INTERNO';
            RETURN;
        END
        
        -- Validar que no exista el correo
        IF EXISTS (SELECT 1 FROM suscriptores WHERE correo = @correo)
        BEGIN
            PRINT '❌ ERROR: Ya existe un suscriptor con el correo: ' + @correo;
            RETURN;
        END
        
        -- Insertar suscriptor
        INSERT INTO suscriptores (
            nombre, alias, correo, celular,
            ciudad_id, colonia_id, estados_abreviatura, tipo_suscriptor_codigo
        ) VALUES (
            @nombre, @alias, @correo, @celular,
            @ciudad_id, @colonia_id, @estados_abreviatura, @tipo_codigo
        );
        
        DECLARE @nuevo_id INT = SCOPE_IDENTITY();
        
        -- Mostrar resultado
        SELECT 
            'SUSCRIPTOR CREADO EXITOSAMENTE' AS resultado,
            s.id,
            s.nombre,
            s.alias,
            s.correo,
            s.tipo_suscriptor_codigo,
            ts.nombre AS tipo_suscriptor
        FROM suscriptores s
        INNER JOIN tipos_suscriptores ts ON s.tipo_suscriptor_codigo = ts.codigo
        WHERE s.id = @nuevo_id;
        
        PRINT '✅ Suscriptor creado con ID: ' + CAST(@nuevo_id AS VARCHAR);
        
    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;

-- Probar el procedimiento
EXEC sp_agregar_suscriptor_final
    @nombre = 'María Fernanda González Ruiz',
    @alias = 'Mafer',
    @correo = 'maria.gonzalez@gmail.com',
    @celular = '33-1234-5678',
    @ciudad_id = 121,
    @colonia_id = 5,
    @estados_abreviatura = 'JAL',
    @tipo_codigo = 'RES';

-- Usar el procedimiento corregido
EXEC sp_agregar_suscriptor_final
    @nombre = 'María Fernanda González Ruiz',
    @alias = 'Mafer',
    @correo = 'maria.gonzalez@gmail.com',
    @celular = '33-1234-5678',
    @ciudad_id = 121,
    @colonia_id = 5,
    @estados_abreviatura = 'JAL',
    @tipo_codigo = 'RES';


        -- ===============================================
    -- INSERTAR MÚLTIPLES SUSCRIPTORES DEL MISMO TIPO
    -- ===============================================
    
    INSERT INTO suscriptores (nombre, alias, correo, celular, ciudad_id, colonia_id, estados_abreviatura, tipo_suscriptor_codigo) VALUES 
    
    -- Múltiples RES
    ('Ana Patricia Morales', 'Paty', 'ana.morales@gmail.com', '33-1111-2222', 121, 10, 'JAL', 'RES'),
    ('Luis Fernando Torres', 'Luisfer', 'luis.torres@hotmail.com', '33-3333-4444', 122, 18, 'JAL', 'RES'),
    
    -- Múltiples EMP
    ('Tecnología S.A.', 'Tech SA', 'contacto@tech.com', '33-5555-6666', 121, 25, 'JAL', 'EMP'),
    ('Consultores SC', 'ConSC', 'info@consultores.mx', '33-7777-8888', 122, 30, 'JAL', 'EMP');
    
    -- Verificar resultado
    SELECT 
        tipo_suscriptor_codigo,
        COUNT(*) AS cantidad,
        STRING_AGG(nombre, '; ') AS suscriptores
    FROM suscriptores
    GROUP BY tipo_suscriptor_codigo
    ORDER BY tipo_suscriptor_codigo;


    {
  "nombre": "Luis Eduardo Martinez Gonzalez de la Torre",
  "alias": "LuisEduardo2025",
  "correo": "luis.eduardo.martinez@hotmail.com",
  "celular": "81-9999-1111",
  "ciudadId": 121,
  "coloniaId": 5,
  "estadosAbreviatura": "NL",
  "tipoSuscriptorCodigo": "RES"
}


