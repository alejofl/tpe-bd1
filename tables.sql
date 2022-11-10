CREATE TABLE IF NOT EXISTS clientes_banco
(
    codigo    SERIAL PRIMARY KEY,
    dni       INT UNIQUE NOT NULL CHECK ( dni > 0 ),
    telefono  VARCHAR,
    nombre    VARCHAR NOT NULL,
    direccion VARCHAR
);

CREATE TABLE IF NOT EXISTS prestamos_banco
(
    codigo         SERIAL PRIMARY KEY,
    fecha          DATE NOT NULL,
    codigo_cliente INT NOT NULL,
    importe        INT NOT NULL CHECK ( importe > 0 ),
    FOREIGN KEY (codigo_cliente) REFERENCES clientes_banco (codigo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS pagos_cuotas
(
    nro_cuota       INT NOT NULL,
    codigo_prestamo INT NOT NULL,
    importe         INT NOT NULL CHECK ( importe > 0 ),
    fecha           DATE NOT NULL,
    PRIMARY KEY (nro_cuota, codigo_prestamo),
    FOREIGN KEY (codigo_prestamo) REFERENCES prestamos_banco (codigo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS backup (
    dni_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR,
    telefono_cliente VARCHAR,
    cantidad_prestamos INT,
    monto_prestamos_otorgados INT,
    monto_pagos_realizados INT,
    pagos_pendientes BOOLEAN
);