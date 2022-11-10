CREATE OR REPLACE FUNCTION make_backup_clientes()
RETURNS Trigger
AS $$
DECLARE
    cantidad_prestamos INT;
    total_prestamos prestamos_banco.importe %TYPE;
    total_pagado pagos_cuotas.importe %TYPE;
    pagos_pendientes BOOLEAN;

    codigo_unitario prestamos_banco.codigo_cliente %TYPE;
    monto_unitario prestamos_banco.importe %TYPE;
    monto_pagado  pagos_cuotas.importe %TYPE;

    prestamos_cursor CURSOR FOR
    SELECT prestamos_banco.codigo, prestamos_banco.importe
    FROM prestamos_banco
    WHERE old.codigo = prestamos_banco.codigo_cliente;
BEGIN
    cantidad_prestamos := 0;
    total_prestamos := 0;
    total_pagado := 0;
    OPEN prestamos_cursor;

    LOOP
        FETCH prestamos_cursor INTO codigo_unitario, monto_unitario;
        EXIT WHEN NOT FOUND;

        cantidad_prestamos := cantidad_prestamos + 1;
        total_prestamos := total_prestamos + monto_unitario;

        SELECT sum(pagos_cuotas.importe) INTO monto_pagado
        FROM pagos_cuotas
        WHERE pagos_cuotas.codigo_prestamo = codigo_unitario;

        IF monto_pagado IS NOT NULL
        THEN
            total_pagado := total_pagado + monto_pagado;
        END IF;
    END LOOP;

    IF total_pagado < total_prestamos
    THEN
        pagos_pendientes := TRUE;
    ELSE
        pagos_pendientes := FALSE;
    END IF;

    INSERT INTO backup VALUES ( old.dni, old.nombre, old.telefono, cantidad_prestamos, total_prestamos, total_pagado, pagos_pendientes );

    CLOSE prestamos_cursor;
    RETURN old;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER backup_clientes
BEFORE DELETE ON clientes_banco
FOR EACH ROW
EXECUTE PROCEDURE make_backup_clientes();