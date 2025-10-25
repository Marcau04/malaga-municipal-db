DROP TABLE IF EXISTS gestion;
DROP TABLE IF EXISTS infraccion;
DROP TABLE IF EXISTS tipo_i;
DROP TABLE IF EXISTS tipo_ii;
DROP TABLE IF EXISTS tipo_iii;
DROP TABLE IF EXISTS tipo_iv;
DROP TABLE IF EXISTS parcela;
DROP TABLE IF EXISTS mobiliario_urbano;
DROP TABLE IF EXISTS voladizo;
DROP TABLE IF EXISTS solicitud;
DROP TABLE IF EXISTS establecimiento;
DROP TABLE IF EXISTS titular;

CREATE TABLE titular (
    nif VARCHAR(9) NOT NULL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    apellidos VARCHAR(200) NOT NULL,
    fecha_nacimiento DATE NOT NULL CHECK (fecha_nacimiento <= CURRENT_DATE)
);

CREATE TABLE establecimiento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    hora_apertura TIME NOT NULL,
    horario INTERVAL NOT NULL
);

DROP TYPE IF EXISTS duracion_autorizacion;
CREATE TYPE duracion_autorizacion AS ENUM ('anual', 'temporal', 'ocasional');

CREATE TABLE solicitud (
    id SERIAL PRIMARY KEY,
    id_establecimiento INT NOT NULL,
    fecha_emision DATE NOT NULL CHECK (fecha_emision <= CURRENT_DATE),
    duracion duracion_autorizacion NOT NULL,
    fecha_autorizacion DATE CHECK (fecha_autorizacion <= CURRENT_DATE),
    CONSTRAINT fk_id_establecimiento FOREIGN KEY (id_establecimiento) REFERENCES establecimiento(id)
);

CREATE TABLE gestion (
    inicio_titularidad DATE NOT NULL,
    fin_titularidad DATE CHECK (NULL OR fin_titularidad > inicio_titularidad),
    nif_titular VARCHAR(9) NOT NULL,
    id_establecimiento INT NOT NULL,
    PRIMARY KEY (inicio_titularidad, nif_titular, id_establecimiento),
    CONSTRAINT fk_id_establecimiento FOREIGN KEY (id_establecimiento) REFERENCES establecimiento(id),
    CONSTRAINT fk_nif_titular FOREIGN KEY (nif_titular) REFERENCES titular(nif)
);

DROP TYPE IF EXISTS tipo_infraccion;
CREATE TYPE tipo_infraccion AS ENUM ('leve', 'grave', 'muy grave');

CREATE TABLE infraccion (
    id SERIAL,
    id_solicitud INT NOT NULL,
    tipo tipo_infraccion NOT NULL,
    motivo VARCHAR(1000) NOT NULL,
    multa REAL NOT NULL CHECK (multa > 0),
    retirada_autorizacion BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id, id_solicitud),
    CONSTRAINT fk_id_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id)
);

CREATE TABLE tipo_i (
    id_solicitud INT NOT NULL PRIMARY KEY,
    hora_apertura TIME NOT NULL,
    horario INTERVAL NOT NULL,
    CONSTRAINT fk_id_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id)
);

CREATE TABLE tipo_ii (
    id_solicitud INT NOT NULL PRIMARY KEY,
    fianza REAL NOT NULL CHECK (fianza > 0),
    fecha_cancelacion DATE,
    hora_apertura TIME NOT NULL,
    horario INTERVAL NOT NULL,
    CONSTRAINT fk_id_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id)
);

DROP TYPE IF EXISTS caracter_actividad;
CREATE TYPE caracter_actividad AS ENUM ('particular', 'colectiva', 'empresarial', 'asociativa');

DROP TYPE IF EXISTS tipo_actividad;
CREATE TYPE tipo_actividad AS ENUM ('rodaje cinematografico', 'ocasional', 'promociones comerciales', 'muestras', 'exposiciones', 'mesas para divulgar', 'recabar apoyos', 'vehiculo promocional', 'otros');

CREATE TABLE tipo_iii (
    id_solicitud INT NOT NULL PRIMARY KEY,
    caracter caracter_actividad NOT NULL,
    tipo tipo_actividad NOT NULL,
    descripcion VARCHAR(1000) NOT NULL,
    valoracion_rodaje REAL NOT NULL CHECK (valoracion_rodaje >= 0),
    CONSTRAINT fk_id_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id)
);

DROP TYPE IF EXISTS tipo_aprovechamiento;
CREATE TYPE tipo_aprovechamiento AS ENUM ('puesto', 'barraca', 'caseta de ventas', 'espectaculo', 'atraccion');

CREATE TABLE tipo_iv (
    id_solicitud INT NOT NULL PRIMARY KEY,
    precio REAL NOT NULL CHECK (precio > 0),
    tipo tipo_aprovechamiento NOT NULL,
    ocupacion_real REAL NOT NULL CHECK (ocupacion_real > 0),
    CONSTRAINT fk_id_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id)
);

CREATE TABLE parcela (
    id SERIAL PRIMARY KEY,
    id_solicitud INT NOT NULL,
    metros REAL NOT NULL CHECK (metros > 0),
    CONSTRAINT fk_id_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id)
);

DROP TYPE IF EXISTS tipo_mobiliario_urbano;
CREATE TYPE tipo_mobiliario_urbano AS ENUM ('mesa', 'silla', 'sombrilla', 'jardinera', 'cortaviento', 'celosia', 'otros');

CREATE TABLE mobiliario_urbano (
    id SERIAL PRIMARY KEY,
    tipo tipo_mobiliario_urbano NOT NULL,
    id_solicitud INT NOT NULL,
    ancho REAL NOT NULL CHECK (ancho > 0),
    largo REAL NOT NULL CHECK (largo > 0),
    CONSTRAINT fk_id_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id)
);

DROP TYPE IF EXISTS tipo_voladizo;
CREATE TYPE tipo_voladizo AS ENUM ('toldo abatible', 'toldo enrrollable', 'toldo con soporte rigido', 'voladizo');

CREATE TABLE voladizo (
    id SERIAL PRIMARY KEY,
    tipo tipo_voladizo NOT NULL,
    id_solicitud INT NOT NULL,
    ancho REAL NOT NULL CHECK (ancho > 0),
    largo REAL NOT NULL CHECK (largo > 0),
    alto REAL NOT NULL CHECK (alto > 0),
    forma VARCHAR(200) NOT NULL,
    CONSTRAINT fk_id_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id)
);

INSERT INTO titular (nif, nombre, apellidos, fecha_nacimiento) VALUES
    ('12345678A', 'Juan', 'Pérez García', '1985-05-15'),
    ('87654321B', 'María', 'López Fernández', '1990-09-20'),
    ('35021082H', 'Francisco', 'Sanchez Moroto', '1956-06-29'),
    ('45678912C', 'Carlos', 'Martínez Sánchez', '1975-03-30');

INSERT INTO establecimiento (nombre, direccion, hora_apertura, horario) VALUES
    ('Cafetería Sol', 'Calle Mayor 12', '08:00:00', '10:00:00'),
    ('Librería Luna', 'Avenida Principal 45', '09:30:00', '8:30:00'),
    ('Confiteria Paco', 'Paseo Mayor 84', '05:30:00', '12:00:00'),
    ('Panadería Estrella', 'Plaza Central 3', '07:00:00', '9:00:00');

INSERT INTO solicitud (id_establecimiento, fecha_emision, duracion, fecha_autorizacion) VALUES
    (1, '2023-01-15', 'anual', '2023-01-20'),
    (2, '2023-02-10', 'ocasional', '2023-02-15'),
    (3, '2023-03-05', 'temporal', '2023-03-10'),
    (4, '2023-12-28', 'temporal', '2024-01-07');

INSERT INTO gestion (inicio_titularidad, fin_titularidad, nif_titular, id_establecimiento) VALUES
    ('2023-01-01', '2023-12-31', '12345678A', 1),
    ('2023-02-01', NULL, '87654321B', 2),
    ('2024-01-01', NULL, '35021082H', 3),
    ('2023-03-01', '2023-06-30', '45678912C', 4);

INSERT INTO infraccion (id_solicitud, tipo, motivo, multa, retirada_autorizacion) VALUES
    (1, 'leve', 'Deterioro leve del mobiliario urbano', 750.00, FALSE),
    (2, 'grave', 'Ocupar mayor superfecie que la autorizada', 1500.00, FALSE),
    (3, 'muy grave', 'Ocupación de la vía pública sin autorización', 3000.00, TRUE);

INSERT INTO tipo_i (id_solicitud, hora_apertura, horario) VALUES
    (1, '08:00:00', '10:00:00');

INSERT INTO tipo_ii (id_solicitud, fianza, fecha_cancelacion, hora_apertura, horario) VALUES
    (3, 500.00, '2023-07-01', '07:00:00', '9:00:00');

INSERT INTO tipo_iii (id_solicitud, caracter, tipo, descripcion, valoracion_rodaje) VALUES
    (2, 'particular', 'muestras', 'Exposición de productos artesanales', 1500.00);

INSERT INTO tipo_iv (id_solicitud, precio, tipo, ocupacion_real) VALUES
    (4, 200.00, 'puesto', 15.00);

INSERT INTO parcela (id_solicitud, metros) VALUES
    (4, 70.00);

INSERT INTO mobiliario_urbano (tipo, id_solicitud, ancho, largo) VALUES
    ('mesa', 1, 1.20, 0.80),
    ('silla', 1, 0.50, 0.50),
    ('sombrilla', 1, 2.50, 2.50);

INSERT INTO voladizo (tipo, id_solicitud, ancho, largo, alto, forma) VALUES
    ('toldo abatible', 3, 3.00, 2.00, 2.50, 'rectangular'),
    ('voladizo', 3, 4.00, 2.50, 3.00, 'curvo');