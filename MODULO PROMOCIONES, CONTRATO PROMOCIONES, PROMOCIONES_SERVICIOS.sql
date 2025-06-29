-- Agregar campos faltantes
ALTER TABLE promociones 
ADD aplicable_a VARCHAR(50) DEFAULT 'todos'; -- 'servicios', 'paquetes', 'todos'

ALTER TABLE promociones 
ADD limite_usos INT NULL; -- Límite de veces que se puede usar

ALTER TABLE promociones 
ADD usos_actuales INT DEFAULT 0; -- Contador de usos

ALTER TABLE promociones 
ADD requiere_servicios_minimos INT DEFAULT 0; -- Servicios mínimos para aplicar

ALTER TABLE promociones 
ADD codigo_promocional VARCHAR(20) NULL; -- Código para aplicar promoción

-- Crear índices para mejor rendimiento
CREATE INDEX IX_promociones_fechas ON promociones (fecha_inicio, fecha_fin);
CREATE INDEX IX_promociones_activo ON promociones (activo);
CREATE INDEX IX_promociones_codigo ON promociones (codigo_promocional);


-- ===============================================
-- TABLA PARA RELACIONAR PROMOCIONES CON SERVICIOS
-- ===============================================

CREATE TABLE promociones_servicios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    promocion_id INT NOT NULL,
    servicio_nombre VARCHAR(100) NOT NULL,
    descuento_especifico DECIMAL(5,2) NULL, -- Descuento específico para este servicio
    activo BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_promociones_servicios_promocion 
        FOREIGN KEY (promocion_id) REFERENCES promociones(id),
    CONSTRAINT UQ_promociones_servicios_unico 
        UNIQUE (promocion_id, servicio_nombre)
);

PRINT '✅ Tabla promociones_servicios creada';

-- ===============================================
-- MEJORAS A TABLA CONTRATOS_PROMOCIONES
-- ===============================================

-- Agregar campos para mejor control
ALTER TABLE contratos_promociones 
ADD descuento_aplicado DECIMAL(10,2) NULL; -- Descuento real aplicado en pesos

ALTER TABLE contratos_promociones 
ADD servicios_afectados TEXT NULL; -- Lista de servicios afectados

ALTER TABLE contratos_promociones 
ADD created_at DATETIME DEFAULT GETDATE();

ALTER TABLE contratos_promociones 
ADD created_by VARCHAR(100) NULL; -- Usuario que aplicó la promoción

-- Crear índices
CREATE INDEX IX_contratos_promociones_contrato ON contratos_promociones (contrato_id);
CREATE INDEX IX_contratos_promociones_promocion ON contratos_promociones (promocion_id);
CREATE INDEX IX_contratos_promociones_fechas ON contratos_promociones (fecha_aplicacion, fecha_vencimiento);