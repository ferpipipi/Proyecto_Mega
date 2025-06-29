-- ===============================================
-- TABLA PARA LOGS DE FACTURACIÓN
-- ===============================================
-- RESUMEN - LA TABLA SIRVE PARA:
-- ✅ Auditoría completa - Saber qué pasó en cada facturación
-- ✅ Control de errores - Identificar problemas rápidamente
-- ✅ Análisis de rendimiento - Ver tendencias y patrones
-- ✅ Alertas automáticas - Detectar anomalías
-- ✅ Reportes gerenciales - Dashboard para administradores
-- ✅ Debugging - Investigar problemas específicos
-- ✅ Compliance - Cumplir auditorías y regulaciones

-- 🎯 EN POCAS PALABRAS:
-- Es como el "historial clínico" del sistema de facturación:

-- 📅 Cuándo se ejecutó
-- 📊 Cuántas facturas se generaron
-- 💰 Cuánto dinero se facturó
-- ✅ Si fue exitoso o tuvo errores
-- 🔍 Qué errores ocurrieron


CREATE TABLE logs_facturacion (
    id INT IDENTITY(1,1) PRIMARY KEY,
    fecha_proceso DATE NOT NULL,
    facturas_generadas INT DEFAULT 0,
    total_facturado DECIMAL(15,2) DEFAULT 0,
    estado VARCHAR(20) NOT NULL, -- 'completado', 'error', 'parcial'
    error_mensaje TEXT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

PRINT '✅ Tabla logs_facturacion creada';

-- ===============================================
-- TRIGGER PARA ACTUALIZAR FECHA ÚLTIMA FACTURACIÓN
-- ===============================================

-- ===============================================
-- PASO 1: AGREGAR COLUMNA A TABLA CONTRATOS
-- ===============================================

-- Verificar si la columna ya existe antes de agregarla
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID('contratos') 
        AND name = 'ultima_facturacion'
)
BEGIN
    ALTER TABLE contratos ADD ultima_facturacion DATE NULL;
    PRINT '✅ Columna ultima_facturacion agregada a tabla contratos';
END
ELSE
BEGIN
    PRINT '⚠️ La columna ultima_facturacion ya existe en tabla contratos';
END
GO