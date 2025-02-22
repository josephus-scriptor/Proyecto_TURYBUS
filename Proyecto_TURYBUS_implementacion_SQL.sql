-- Crear la Base de Datos
CREATE DATABASE TURYBUS;
GO

USE TURYBUS;
GO

-- Crear el schema
CREATE SCHEMA turybus;
GO

-- Crear las tablas
CREATE TABLE turybus.RUTA (
    id_ruta INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    importe_fijo DECIMAL(10,2) NOT NULL,
    promedio_pasajeros INT,
    descripcion TEXT
);

CREATE TABLE turybus.SERVICIO_DIARIO (
    id_servicio INT IDENTITY(1,1) PRIMARY KEY,
    id_ruta INT NOT NULL,
    hora_salida TIME NOT NULL,
    promedio_pasajeros INT,
    dias_programados VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_ruta) REFERENCES turybus.RUTA(id_ruta)
);

CREATE TABLE turybus.PARADA (
    id_parada INT IDENTITY(1,1) PRIMARY KEY,
    id_ruta INT NOT NULL,
    nombre_lugar VARCHAR(100) NOT NULL,
    llegada_prevista TIME NOT NULL,
    actividad VARCHAR(200),
    duracion_parada INT,  -- Duracion en minutos
    orden_parada INT NOT NULL,
    FOREIGN KEY (id_ruta) REFERENCES turybus.RUTA(id_ruta)
);

CREATE TABLE turybus.AUTOBUS (
    id_matricula VARCHAR(20) PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    fabricante VARCHAR(50) NOT NULL,
    numero_asientos INT NOT NULL,
    caracteristicas TEXT,
    kilometros_diarios INT
);

CREATE TABLE turybus.CONDUCTOR (
    id_DNI VARCHAR(20) PRIMARY KEY,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    kilometros_diarios INT
);

CREATE TABLE turybus.PASAJERO (
    id_pasajero VARCHAR(20) PRIMARY KEY,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    total_horas INT
);

CREATE TABLE turybus.VIAJE (
    id_viaje INT IDENTITY(1,1) PRIMARY KEY,
    id_servicio INT NOT NULL,
    fecha_viaje DATE NOT NULL,
    fecha_hora_salida TIME NOT NULL,
    llegada_prevista TIME NOT NULL,
    id_matricula VARCHAR(20) NOT NULL,
    id_DNI VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_servicio) REFERENCES turybus.SERVICIO_DIARIO(id_servicio),
    FOREIGN KEY (id_matricula) REFERENCES turybus.AUTOBUS(id_matricula),
    FOREIGN KEY (id_DNI) REFERENCES turybus.CONDUCTOR(id_DNI)
);

CREATE TABLE turybus.BILLETE (
    id_billete INT IDENTITY(1,1) PRIMARY KEY,
    id_viaje INT NOT NULL,
    id_pasajero VARCHAR(20) NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    fecha_compra DATE NOT NULL,
    FOREIGN KEY (id_viaje) REFERENCES turybus.VIAJE(id_viaje),
    FOREIGN KEY (id_pasajero) REFERENCES turybus.PASAJERO(id_pasajero)
);

CREATE TABLE turybus.REVISION (
    id_revision INT IDENTITY(1,1) PRIMARY KEY,
    id_matricula VARCHAR(20) NOT NULL,
    fecha_revision DATE NOT NULL,
    diagnostico TEXT NOT NULL,
    FOREIGN KEY (id_matricula) REFERENCES turybus.AUTOBUS(id_matricula)
);

CREATE TABLE turybus.REPARACION (
    id_reparacion INT IDENTITY(1,1) PRIMARY KEY,
    id_revision INT NOT NULL,
    codigo_reparacion VARCHAR(20) NOT NULL,
    duracion_reparacion INT NOT NULL,  -- Tiempo en minutos
    comentarios TEXT,
    FOREIGN KEY (id_revision) REFERENCES turybus.REVISION(id_revision)
);

-- Crear INDEX para mejorar rendimiento
CREATE INDEX idx_ruta_servicio_diario ON turybus.SERVICIO_DIARIO(id_ruta);
CREATE INDEX idx_parada_ruta ON turybus.PARADA(id_ruta);
CREATE INDEX idx_viaje_servicio ON turybus.VIAJE(id_servicio);
CREATE INDEX idx_billete_viaje ON turybus.BILLETE(id_viaje);
CREATE INDEX idx_billete_pasajero ON turybus.BILLETE(id_pasajero);
CREATE INDEX idx_revision_autobus ON turybus.REVISION(id_matricula);
CREATE INDEX idx_revision_reparacion ON turybus.REPARACION(id_revision);
