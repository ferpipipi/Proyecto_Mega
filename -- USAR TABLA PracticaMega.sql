-- USAR TABLA PracticaMega
USE PracticaMega
GO

CREATE TABLE estados (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE ciudades (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    estados_id INT REFERENCES estados(id)
);

CREATE TABLE colonias (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad_id INT REFERENCES ciudades(id)
);

CREATE TABLE suscriptores (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    alias VARCHAR(100),
    ciudad_id INT REFERENCES ciudades(id),
    colonia_id INT REFERENCES colonias(id),
    estados INT REFERENCES estados(id)
);

-- - Tabla de tipos de suscriptores
CREATE TABLE tipos_suscriptores (
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL UNIQUE,     -- 'RES', 'EMP', 'ESC', etc.
    nombre VARCHAR(100) NOT NULL,           -- 'Casa Habitación', 'Empresas', gobiernos, escuelas, AC, CARIDAD Y DONACIONES.
    descripcion TEXT,
    descuento_porcentaje DECIMAL(5,2) DEFAULT 0,  -- Descuentos especiales
    requiere_contrato_especial BIT DEFAULT 0,     -- Contratos personalizados
    activo BIT DEFAULT 1
);

-- Modificar tabla suscriptores para incluir el tipo
ALTER TABLE suscriptores 
ADD tipo_suscriptor_id INT REFERENCES tipos_suscriptores(id);





-- creamos los SERVICIOS, CONTRATOS, PAQUETES, PROMOCIONES.

ALTER TABLE suscriptores 
ADD CONSTRAINT uq_suscriptores_nombre_correo UNIQUE (nombre, correo);

ALTER TABLE suscriptores 
ADD CONSTRAINT uq_suscriptores_celular_correo UNIQUE (celular, correo);


-- ============================================
-- CATÁLOGOS DE SERVICIOS
-- ============================================

-- Tipos de servicios disponibles
CREATE TABLE tipos_servicios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    sku VARCHAR (12) NOT NULL,
    nombre VARCHAR(100) NOT NULL,           -- 'Internet', 'Cable', 'Telefonía'
    descripcion TEXT,
    activo BIT DEFAULT 1
);

-- Servicios específicos por tipo
CREATE TABLE servicios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,           -- 'Internet 100MB', 'Paquete Premium'
    tipo_servicio_id INT REFERENCES tipos_servicios(id),
    velocidad VARCHAR(50),                  -- '100 Mbps', '200 Mbps'
    precio_base DECIMAL(10,2) NOT NULL,
    descripcion TEXT,
    activo BIT DEFAULT 1
);

-- ============================================
-- PAQUETES Y PROMOCIONES
-- ============================================

-- Paquetes que combinan servicios
CREATE TABLE paquetes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,           -- 'Triple Play', 'Dúo Internet+Cable'
    descripcion TEXT,
    precio_total DECIMAL(10,2) NOT NULL,
    descuento_porcentaje DECIMAL(5,2) DEFAULT 0,
    activo BIT DEFAULT 1
);

-- Servicios incluidos en cada paquete
CREATE TABLE paquetes_servicios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    paquete_id INT REFERENCES paquetes(id),
    servicio_id INT REFERENCES servicios(id),
    cantidad INT DEFAULT 1,
    UNIQUE(paquete_id, servicio_id)
);

-- Promociones y ofertas
CREATE TABLE promociones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,           -- 'Bienvenida', '6 meses gratis'
    descripcion TEXT,
    tipo_promocion VARCHAR(50),             -- 'descuento', 'meses_gratis', 'upgrade'
    valor_descuento DECIMAL(10,2),          -- Monto o porcentaje
    es_porcentaje BIT DEFAULT 0,
    duracion_meses INT DEFAULT 1,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    activo BIT DEFAULT 1
);

-- ============================================
-- CONTRATOS Y SUSCRIPCIONES
-- ============================================

-- Contratos principales
CREATE TABLE contratos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    suscriptor_id INT REFERENCES suscriptores(id),
    numero_contrato VARCHAR(50) UNIQUE NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME,
    estado VARCHAR(20) DEFAULT 'ACTIVO',    -- 'ACTIVO', 'SUSPENDIDO', 'CANCELADO'
    precio_mensual DECIMAL(10,2) NOT NULL,
    notas TEXT,
    created_at DATETIME DEFAULT GETDATE()
);

-- Servicios contratados por contrato
CREATE TABLE contratos_servicios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    contrato_id INT REFERENCES contratos(id),
    servicio_id INT REFERENCES servicios(id),
    paquete_id INT REFERENCES paquetes(id),  -- NULL si es servicio individual
    precio_acordado DECIMAL(10,2) NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME,
    estado VARCHAR(20) DEFAULT 'ACTIVO'
);

-- Promociones aplicadas a contratos
CREATE TABLE contratos_promociones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    contrato_id INT REFERENCES contratos(id),
    promocion_id INT REFERENCES promociones(id),
    fecha_aplicacion DATETIME DEFAULT GETDATE(),
    fecha_vencimiento DATETIME NOT NULL,
    activo BIT DEFAULT 1
);

-- ============================================
-- FACTURACIÓN Y PAGOS
-- ============================================

-- Facturas mensuales
CREATE TABLE facturas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    contrato_id INT REFERENCES contratos(id),
    numero_factura VARCHAR(50) UNIQUE NOT NULL,
    periodo_inicio DATETIME NOT NULL,
    periodo_fin DATETIME NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    descuentos DECIMAL(10,2) DEFAULT 0,
    impuestos DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    fecha_vencimiento DATETIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'PENDIENTE',  -- 'PENDIENTE', 'PAGADA', 'VENCIDA'
    fecha_emision DATETIME DEFAULT GETDATE()
);

-- Pagos realizados
CREATE TABLE pagos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    factura_id INT REFERENCES facturas(id),
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50),                -- 'Efectivo', 'Tarjeta', 'Transferencia'
    referencia VARCHAR(100),
    fecha_pago DATETIME DEFAULT GETDATE(),
    estado VARCHAR(20) DEFAULT 'COMPLETADO'
);


-- Solo los nombres de las FK en suscriptores
SELECT 
    name AS nombre_llave_foranea
FROM sys.foreign_keys 
WHERE parent_object_id = OBJECT_ID('suscriptores');
