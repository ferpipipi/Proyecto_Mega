-- ===============================================
-- PROCEDIMIENTO CORREGIDO CON VALIDACIÓN AUTOMÁTICA
-- ===============================================

CREATE OR ALTER PROCEDURE sp_crear_contrato_con_servicio
    @suscriptor_id INT,
    @servicio_nombre VARCHAR(100),
    @fecha_inicio DATE = NULL,
    @descuento_inicial DECIMAL(5,2) = 0.0,
    @numero_contrato_personalizado VARCHAR(50) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        SET @fecha_inicio = ISNULL(@fecha_inicio, GETDATE());
        
        DECLARE @nuevo_contrato_id INT;
        DECLARE @numero_contrato VARCHAR(50);
        DECLARE @precio_servicio DECIMAL(10,2);
        DECLARE @precio_con_descuento DECIMAL(10,2);
        DECLARE @precio_con_impuestos DECIMAL(10,2);
        DECLARE @intentos INT = 0;
        
        -- Validar que el suscriptor existe
        IF NOT EXISTS (SELECT 1 FROM suscriptores WHERE id = @suscriptor_id)
        BEGIN
            PRINT '❌ ERROR: Suscriptor no encontrado: ' + CAST(@suscriptor_id AS VARCHAR);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validar que el servicio existe
        SELECT @precio_servicio = precio_base 
        FROM servicios 
        WHERE nombre = @servicio_nombre;
        
        IF @precio_servicio IS NULL
        BEGIN
            PRINT '❌ ERROR: Servicio no encontrado: ' + @servicio_nombre;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- ⭐ GENERAR NÚMERO DE CONTRATO CON VALIDACIÓN AUTOMÁTICA
        IF @numero_contrato_personalizado IS NOT NULL
        BEGIN
            -- Verificar que no exista el número personalizado
            IF EXISTS (SELECT 1 FROM contratos WHERE numero_contrato = @numero_contrato_personalizado)
            BEGIN
                PRINT '❌ ERROR: El número de contrato ya existe: ' + @numero_contrato_personalizado;
                ROLLBACK TRANSACTION;
                RETURN;
            END
            SET @numero_contrato = @numero_contrato_personalizado;
        END
        ELSE
        BEGIN
            -- ⭐ BUSCAR EL SIGUIENTE CONSECUTIVO DISPONIBLE AUTOMÁTICAMENTE
            DECLARE @anio VARCHAR(4) = CAST(YEAR(GETDATE()) AS VARCHAR);
            DECLARE @siguiente_numero INT;
            
            -- Buscar el siguiente número disponible en la secuencia del año actual
            SELECT @siguiente_numero = ISNULL(MAX(CAST(RIGHT(numero_contrato, 3) AS INT)), 0) + 1
            FROM contratos 
            WHERE numero_contrato LIKE 'CTR-' + @anio + '-%';
            
            -- Generar número y validar que no exista (con reintentos)
            WHILE @intentos < 20  -- Máximo 20 intentos
            BEGIN
                SET @numero_contrato = 'CTR-' + @anio + '-' + RIGHT('000' + CAST(@siguiente_numero AS VARCHAR), 3);
                
                -- Verificar si ya existe
                IF NOT EXISTS (SELECT 1 FROM contratos WHERE numero_contrato = @numero_contrato)
                BEGIN
                    PRINT '🔢 Número de contrato generado: ' + @numero_contrato;
                    BREAK; -- Número único encontrado
                END
                
                -- Si existe, probar el siguiente número
                SET @siguiente_numero = @siguiente_numero + 1;
                SET @intentos = @intentos + 1;
                PRINT '⚠️ Número ' + @numero_contrato + ' ya existe. Probando siguiente...';
            END
            
            -- Si no encuentra número único después de 20 intentos
            IF @intentos >= 20
            BEGIN
                SET @numero_contrato = 'CTR-' + @anio + '-' + FORMAT(GETDATE(), 'MMddHHmmss');
                PRINT '🚨 Generando número con timestamp: ' + @numero_contrato;
            END
            
            -- ⭐ ACTUALIZAR SECUENCIA AL NÚMERO CORRECTO (OPCIONAL)
            IF EXISTS (SELECT * FROM sys.sequences WHERE name = 'seq_contratos')
            BEGIN
                DECLARE @sql NVARCHAR(100) = 'ALTER SEQUENCE seq_contratos RESTART WITH ' + CAST(@siguiente_numero + 1 AS VARCHAR);
                EXEC sp_executesql @sql;
                PRINT '🔄 Secuencia actualizada al número: ' + CAST(@siguiente_numero + 1 AS VARCHAR);
            END
        END
        
        -- Calcular precios
        SET @precio_con_descuento = @precio_servicio * (1 - @descuento_inicial / 100);
        SET @precio_con_impuestos = @precio_con_descuento * 1.16; -- 16% IVA
        
        -- 📋 CREAR EL CONTRATO
        INSERT INTO contratos (
            suscriptor_id, numero_contrato, fecha_inicio, 
            precio_mensual, estado, created_at
        ) VALUES (
            @suscriptor_id, @numero_contrato, @fecha_inicio,
            @precio_con_impuestos, 'activo', GETDATE()
        );
        
        SET @nuevo_contrato_id = SCOPE_IDENTITY();
        
        -- 🛠️ AGREGAR EL SERVICIO AL CONTRATO
        INSERT INTO contratos_servicios (
            contrato_id, servicio_nombre, paquete_nombre,
            descuento, fecha_inicio, estado
        ) VALUES (
            @nuevo_contrato_id, @servicio_nombre, NULL,
            @descuento_inicial, @fecha_inicio, 'activo'
        );
        
        COMMIT TRANSACTION;
        
        -- 📊 MOSTRAR RESULTADO
        SELECT 
            @numero_contrato AS numero_contrato_generado,
            @nuevo_contrato_id AS contrato_id,
            s.nombre AS cliente,
            @servicio_nombre AS servicio_contratado,
            @precio_servicio AS precio_base_servicio,
            @descuento_inicial AS descuento_aplicado,
            @precio_con_descuento AS precio_con_descuento,
            @precio_con_impuestos AS precio_mensual_total,
            @fecha_inicio AS fecha_inicio,
            '✅ Contrato creado con consecutivo automático' AS resultado
        FROM suscriptores s
        WHERE s.id = @suscriptor_id;
        
        PRINT '✅ Contrato creado exitosamente: ' + @numero_contrato;
        PRINT '🛠️ Servicio agregado: ' + @servicio_nombre;
        PRINT '💰 Precio mensual: $' + CAST(@precio_con_impuestos AS VARCHAR);
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT '❌ ERROR: ' + ERROR_MESSAGE();
        PRINT '📍 Línea: ' + CAST(ERROR_LINE() AS VARCHAR);
    END CATCH
END;


-- ===============================================
-- CREAR CONTRATO CON DESCUENTO
-- ===============================================

EXEC sp_crear_contrato_con_servicio
    @suscriptor_id = 6,
    @servicio_nombre = 'Internet Estándar 100MB',
    @fecha_inicio = '2025-06-30',
    @descuento_inicial = 0.0; -- 20% de descuento

-- Resultado: Contrato con 20% descuento en Internet

-- ===============================================
-- CREAR CONTRATO CON NÚMERO PERSONALIZADO
-- ===============================================

EXEC sp_crear_contrato_con_servicio
    @suscriptor_id = 3,
    @servicio_nombre = 'HBO MAX',
    @numero_contrato_personalizado = 'VIP-2025-001';

-- Resultado: Contrato VIP-2025-001 con HBO MAX