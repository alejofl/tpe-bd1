CREATE TABLE IF NOT EXISTS clientes_banco
(
    codigo    SERIAL PRIMARY KEY,
    dni       INT UNIQUE NOT NULL,
    telefono  VARCHAR,
    nombre    VARCHAR NOT NULL,
    direccion VARCHAR
);

CREATE TABLE IF NOT EXISTS prestamos_banco
(
    codigo         SERIAL PRIMARY KEY,
    fecha          DATE NOT NULL,
    codigo_cliente INT NOT NULL,
    importe        INT NOT NULL,
    FOREIGN KEY (codigo_cliente) references clientes_banco (codigo)
);

CREATE TABLE IF NOT EXISTS pagos_cuotas
(
    nro_cuota       INT NOT NULL,
    codigo_prestamo INT NOT NULL,
    importe         INT NOT NULL,
    fecha           DATE NOT NULL,
    PRIMARY KEY (nro_cuota, codigo_prestamo),
    FOREIGN KEY (codigo_prestamo) references prestamos_banco (codigo)
);