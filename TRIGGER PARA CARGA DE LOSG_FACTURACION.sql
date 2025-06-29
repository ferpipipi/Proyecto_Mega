
-- ===============================================
-- PASO 2: CREAR TRIGGER (EN BATCH SEPARADO)
-- ===============================================

CREATE OR ALTER TRIGGER tr_actualizar_ultima_facturacion
ON facturas
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE c
    SET ultima_facturacion = i.fecha_emision
    FROM contratos c
    INNER JOIN inserted i ON c.id = i.contrato_id;
    
    -- Opcional: Mostrar mensaje de confirmación
    DECLARE @facturas_procesadas INT;
    SELECT @facturas_procesadas = COUNT(*) FROM inserted;
    PRINT '✅ Trigger ejecutado - Contratos actualizados: ' + CAST(@facturas_procesadas AS VARCHAR);
END;
GO

PRINT '✅ Trigger tr_actualizar_ultima_facturacion creado correctamente';