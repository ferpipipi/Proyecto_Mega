-- ===============================================
-- PROCEDIMIENTO PARA APLICAR PROMOCIÓN A CONTRATO
-- ===============================================

CREATE OR ALTER PROCEDURE sp_aplicar_promocion_a_contrato
    @numero_contrato VARCHAR(50),
    @codigo_promocional VARCHAR(20) = NULL,
    @promocion_id INT = NULL
AS
BEGIN
    BEGIN TRY
        DECLARE @contrato_id INT;
        DECLARE @promocion_encontrada INT;
        DECLARE @descuento_total DECIMAL(10,2) = 0;
        DECLARE @servicios_afectados VARCHAR(MAX) = '';
        DECLARE @fecha_vencimiento DATE;
        
        -- Obtener contrato_id
        SELECT @contrato_id = id 
        FROM contratos 
        WHERE numero_contrato = @numero_contrato AND estado = 'activo';
        
        IF @contrato_id IS NULL
        BEGIN
            PRINT '❌ ERROR: Contrato no encontrado: ' + @numero_contrato;
            RETURN;
        END
        
        -- Buscar promoción por código o ID
        IF @codigo_promocional IS NOT NULL
        BEGIN
            SELECT @promocion_encontrada = id
            FROM promociones 
            WHERE codigo_promocional = @codigo_promocional 
                AND activo = 1
                AND GETDATE() BETWEEN fecha_inicio AND fecha_fin;
        END
        ELSE IF @promocion_id IS NOT NULL
        BEGIN
            SELECT @promocion_encontrada = id
            FROM promociones 
            WHERE id = @promocion_id 
                AND activo = 1
                AND GETDATE() BETWEEN fecha_inicio AND fecha_fin;
        END
        
        IF @promocion_encontrada IS NULL
        BEGIN
            PRINT '❌ ERROR: Promoción no encontrada o no válida';
            RETURN;
        END
        
        -- Verificar que no tenga ya esta promoción activa
        IF EXISTS (
            SELECT 1 FROM contratos_promociones 
            WHERE contrato_id = @contrato_id 
                AND promocion_id = @promocion_encontrada 
                AND activo = 1
        )
        BEGIN
            PRINT '⚠️ ADVERTENCIA: El contrato ya tiene esta promoción activa';
            RETURN;
        END
        
        -- Calcular fecha de vencimiento
        SELECT @fecha_vencimiento = DATEADD(MONTH, duracion_meses, GETDATE())
        FROM promociones 
        WHERE id = @promocion_encontrada;
        
        -- Aplicar descuentos a servicios específicos
        DECLARE @valor_descuento DECIMAL(10,2);
        DECLARE @es_porcentaje BIT;
        
        SELECT @valor_descuento = valor_descuento, @es_porcentaje = es_porcentaje
        FROM promociones 
        WHERE id = @promocion_encontrada;
        
        -- Actualizar descuentos en contratos_servicios
        UPDATE cs 
        SET descuento = CASE 
            WHEN @es_porcentaje = 1 THEN @valor_descuento
            ELSE ((@valor_descuento / srv.precio_base) * 100)
        END
        FROM contratos_servicios cs
        INNER JOIN servicios srv ON cs.servicio_nombre = srv.nombre
        WHERE cs.contrato_id = @contrato_id 
            AND cs.estado = 'activo'
            AND EXISTS (
                SELECT 1 FROM promociones_servicios ps 
                WHERE ps.promocion_id = @promocion_encontrada 
                    AND ps.servicio_nombre = cs.servicio_nombre
            );
        
        -- Crear registro en contratos_promociones
        INSERT INTO contratos_promociones (
            contrato_id, promocion_id, fecha_aplicacion, 
            fecha_vencimiento, activo, created_at
        ) VALUES (
            @contrato_id, @promocion_encontrada, GETDATE(),
            @fecha_vencimiento, 1, GETDATE()
        );
        
        -- Actualizar contador de usos
        UPDATE promociones 
        SET usos_actuales = usos_actuales + 1
        WHERE id = @promocion_encontrada;
        
        -- Mostrar resultado
        SELECT 
            @numero_contrato AS contrato,
            p.nombre AS promocion_aplicada,
            p.codigo_promocional AS codigo,
            @fecha_vencimiento AS vence_el,
            'Promoción aplicada exitosamente' AS resultado
        FROM promociones p
        WHERE p.id = @promocion_encontrada;
        
        PRINT '✅ Promoción aplicada exitosamente al contrato: ' + @numero_contrato;
        
    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR: ' + ERROR_MESSAGE();
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    END CATCH
END;

-- ===============================================
-- APLICAR PROMOCIONES A CONTRATOS
-- ===============================================

-- Aplicar promoción por código
EXEC sp_aplicar_promocion_a_contrato
    @numero_contrato = 'CTR-2025-001',
    @codigo_promocional = 'STREAM2025';

-- Aplicar promoción por código
EXEC sp_aplicar_promocion_a_contrato
    @numero_contrato = 'CTR-2025-002',
    @codigo_promocional = 'NETFLIX20';

-- Aplicar promoción por ID
EXEC sp_aplicar_promocion_a_contrato
    @numero_contrato = 'CTR-2025-001',
    @promocion_id = 2;


-- 1. Ver precio antes
SELECT 'ANTES DEL DELETE' AS momento, numero_contrato, precio_mensual 
FROM contratos WHERE numero_contrato = 'CTR-2025-001';

-- 2. Ejecutar DELETE (activará el trigger)
DELETE FROM contratos_promociones 
WHERE id = 1;

-- 3. Ver precio después (debería actualizarse automáticamente)
SELECT 'DESPUÉS DEL DELETE' AS momento, numero_contrato, precio_mensual 
FROM contratos WHERE numero_contrato = 'CTR-2025-001';