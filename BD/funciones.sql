--------------------------- Tabla laboratorios ---------------------------

-- Insertar laboratorio
CREATE OR REPLACE FUNCTION fun_laboratorios_create(
    in p_tipoEquipo VARCHAR,    -- Tipo de equipo del laboratorio
    in p_edificio VARCHAR,        -- Nombre del edificio
    in p_idGrupo INT              -- ID del grupo asignado al laboratorio
) RETURNS SETOF Laboratorios
LANGUAGE plpgsql
AS $function$
DECLARE
    newLabId INT;  -- Variable para almacenar el ID del nuevo laboratorio
BEGIN
    -- Inserta el laboratorio y guarda el ID generado
    INSERT INTO Laboratorios (Edificio, Tipo_DeEquipo, idGrupo)
    VALUES (p_edificio, p_tipoDeEquipo, p_idGrupo)
    RETURNING idSalon INTO newLabId;

    -- Retorna el laboratorio recién insertado
    RETURN QUERY SELECT * FROM Laboratorios WHERE idSalon = newLabId;
END
$function$;

-- Leer un laboratorio
CREATE OR REPLACE FUNCTION fun_laboratorios_read(
    in p_idSalon INT
) RETURNS SETOF Laboratorios
LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY SELECT * FROM Laboratorios WHERE idSalon = p_idSalon;
END
$function$;

-- Actualizar laboratorio
CREATE OR REPLACE FUNCTION fun_laboratorios_update(
    in p_idSalon INT,
    in p_edificio VARCHAR DEFAULT NULL,
    in p_tipoDeEquipo VARCHAR DEFAULT NULL,
    in p_idGrupo INT DEFAULT NULL
) RETURNS SETOF Laboratorios
LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE Laboratorios
    SET Edificio = COALESCE(p_edificio, Edificio),
        Tipo_DeEquipo = COALESCE(p_tipoDeEquipo, Tipo_DeEquipo),
        idGrupo = COALESCE(p_idGrupo, idGrupo)
    WHERE idSalon = p_idSalon;

    RETURN QUERY SELECT * FROM Laboratorios WHERE idSalon = p_idSalon;
END
$function$;

-- Eliminar laboratorio

CREATE OR REPLACE FUNCTION fun_laboratorios_remove(
    in p_idSalon INT
) RETURNS SETOF Laboratorios
LANGUAGE plpgsql
AS $function$
BEGIN
    CREATE TEMP TABLE laboratorioEliminadoTabla ON COMMIT DROP
    AS SELECT * FROM Laboratorios WHERE idSalon = p_idSalon;

    DELETE FROM Laboratorios WHERE idSalon = p_idSalon;

    RETURN QUERY SELECT * FROM laboratorioEliminadoTabla;
END
$function$;

--------------------------- Tabla Inmoviliaria ---------------------------
--Crear tabla
CREATE OR REPLACE FUNCTION fun_inmobiliaria_create(
    in p_nombre VARCHAR,
    in p_categoria VARCHAR,
    in p_estado VARCHAR,
    in p_idSalon INT
) RETURNS SETOF Inmobiliaria
LANGUAGE plpgsql
AS $function$
DECLARE
    newInmobiliariaId INT;
BEGIN
    INSERT INTO Inmobiliaria (Nombre, Categoria, Estado, idSalon)
    VALUES (p_nombre, p_categoria, p_estado, p_idSalon)
    RETURNING idInmobiliaria INTO newInmobiliariaId;

    RETURN QUERY SELECT * FROM Inmobiliaria WHERE idInmobiliaria = newInmobiliariaId;
END
$function$;

-- Eliminar inmoviliaria
CREATE OR REPLACE FUNCTION fun_inmobiliaria_remove(
    in p_idInmobiliaria INT
) RETURNS SETOF Inmobiliaria
LANGUAGE plpgsql
AS $function$
BEGIN
    CREATE TEMP TABLE inmobiliariaEliminadaTabla ON COMMIT DROP
    AS SELECT * FROM Inmobiliaria WHERE idInmobiliaria = p_idInmobiliaria;

    DELETE FROM Inmobiliaria WHERE idInmobiliaria = p_idInmobiliaria;

    RETURN QUERY SELECT * FROM inmobiliariaEliminadaTabla;
END
$function$;

-- Leer inmoviliaria
CREATE OR REPLACE FUNCTION fun_inmobiliaria_read(
    in p_idInmobiliaria INT
) RETURNS SETOF Inmobiliaria
LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY SELECT * FROM Inmobiliaria WHERE idInmobiliaria = p_idInmobiliaria;
END
$function$;

-- Actualizar inmobiliaria
CREATE OR REPLACE FUNCTION fun_inmobiliaria_update(
    in p_idInmobiliaria INT,
    in p_nombre VARCHAR DEFAULT NULL,
    in p_categoria VARCHAR DEFAULT NULL,
    in p_estado VARCHAR DEFAULT NULL,
    in p_idSalon INT DEFAULT NULL
) RETURNS SETOF Inmobiliaria
LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE Inmobiliaria
    SET Nombre = COALESCE(p_nombre, Nombre),
        Categoria = COALESCE(p_categoria, Categoria),
        Estado = COALESCE(p_estado, Estado),
        idSalon = COALESCE(p_idSalon, idSalon)
    WHERE idInmobiliaria = p_idInmobiliaria;

    RETURN QUERY SELECT * FROM Inmobiliaria WHERE idInmobiliaria = p_idInmobiliaria;
END
$function$;
--------------------------- Tabla Computadoras ---------------------------
-- Crear computadoras 
CREATE OR REPLACE FUNCTION fun_computadoras_create(
    in p_matriculaAlum VARCHAR,
    in p_idSalon INT,
    in p_silla VARCHAR,
    in p_cables VARCHAR,
    in p_perifericos VARCHAR,
    in p_estado VARCHAR,
    in p_fechaUltimoMantenimiento DATE
) RETURNS SETOF Computadoras
LANGUAGE plpgsql
AS $function$
DECLARE
    newComputadoraId INT;
BEGIN
    INSERT INTO Computadoras (Matricula_Alum, idSalon, Silla, Cables, Perifericos, Estado, FechaUltimoMantenimiento)
    VALUES (p_matriculaAlum, p_idSalon, p_silla, p_cables, p_perifericos, p_estado, p_fechaUltimoMantenimiento)
    RETURNING idComputadora INTO newComputadoraId;

    RETURN QUERY SELECT * FROM Computadoras WHERE idComputadora = newComputadoraId;
END
$function$;

-- Leer computadoras
CREATE OR REPLACE FUNCTION fun_computadoras_read(
    in p_idComputadora INT
) RETURNS SETOF Computadoras
LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY SELECT * FROM Computadoras WHERE idComputadora = p_idComputadora;
END
$function$;

-- Actualizar computadora
CREATE OR REPLACE FUNCTION fun_computadoras_update(
    in p_idComputadora INT,
    in p_matriculaAlum VARCHAR DEFAULT NULL,
    in p_idSalon INT DEFAULT NULL,
    in p_silla VARCHAR DEFAULT NULL,
    in p_cables VARCHAR DEFAULT NULL,
    in p_perifericos VARCHAR DEFAULT NULL,
    in p_estado VARCHAR DEFAULT NULL,
    in p_fechaUltimoMantenimiento DATE DEFAULT NULL
) RETURNS SETOF Computadoras
LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE Computadoras
    SET Matricula_Alum = COALESCE(p_matriculaAlum, Matricula_Alum),
        idSalon = COALESCE(p_idSalon, idSalon),
        Silla = COALESCE(p_silla, Silla),
        Cables = COALESCE(p_cables, Cables),
        Perifericos = COALESCE(p_perifericos, Perifericos),
        Estado = COALESCE(p_estado, Estado),
        FechaUltimoMantenimiento = COALESCE(p_fechaUltimoMantenimiento, FechaUltimoMantenimiento)
    WHERE idComputadora = p_idComputadora;

    RETURN QUERY SELECT * FROM Computadoras WHERE idComputadora = p_idComputadora;
END
$function$;

-- Eliminar computadoras
CREATE OR REPLACE FUNCTION fun_computadoras_remove(
    in p_idComputadora INT
) RETURNS SETOF Computadoras
LANGUAGE plpgsql
AS $function$
BEGIN
    CREATE TEMP TABLE computadoraEliminadaTabla ON COMMIT DROP
    AS SELECT * FROM Computadoras WHERE idComputadora = p_idComputadora;

    DELETE FROM Computadoras WHERE idComputadora = p_idComputadora;

    RETURN QUERY SELECT * FROM computadoraEliminadaTabla;
END
$function$;

--------------------------- Tabla Reportes ---------------------------
-- Crear reporte
CREATE OR REPLACE FUNCTION fun_reportes_create(
    in p_descripcion VARCHAR,
    in p_fecha DATE,
    in p_idComputadora INT DEFAULT NULL,
    in p_idInmobiliaria INT DEFAULT NULL,
    in p_idSalon INT
) RETURNS SETOF Reportes
LANGUAGE plpgsql
AS $function$
DECLARE
    newReporteId INT;
BEGIN
    INSERT INTO Reportes (Descripcion, Fecha, idComputadora, idInmobiliaria, idSalon)
    VALUES (p_descripcion, p_fecha, p_idComputadora, p_idInmobiliaria, p_idSalon)
    RETURNING idReporte INTO newReporteId;

    RETURN QUERY SELECT * FROM Reportes WHERE idReporte = newReporteId;
END
$function$;

-- Leer reporte
CREATE OR REPLACE FUNCTION fun_reportes_read(
    in p_idReporte INT
) RETURNS SETOF Reportes
LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY SELECT * FROM Reportes WHERE idReporte = p_idReporte;
END
$function$;

-- Actualizar reporte
CREATE OR REPLACE FUNCTION fun_reportes_update(
    in p_idReporte INT,
    in p_descripcion VARCHAR DEFAULT NULL,
    in p_fecha DATE DEFAULT NULL,
    in p_idComputadora INT DEFAULT NULL,
    in p_idInmobiliaria INT DEFAULT NULL,
    in p_idSalon INT DEFAULT NULL
) RETURNS SETOF Reportes
LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE Reportes
    SET Descripcion = COALESCE(p_descripcion, Descripcion),
        Fecha = COALESCE(p_fecha, Fecha),
        idComputadora = COALESCE(p_idComputadora, idComputadora),
        idInmobiliaria = COALESCE(p_idInmobiliaria, idInmobiliaria),
        idSalon = COALESCE(p_idSalon, idSalon)
    WHERE idReporte = p_idReporte;

    RETURN QUERY SELECT * FROM Reportes WHERE idReporte = p_idReporte;
END
$function$;


-- Eliminar reporte
CREATE OR REPLACE FUNCTION fun_reportes_remove(
    in p_idReporte INT
) RETURNS SETOF Reportes
LANGUAGE plpgsql
AS $function$
BEGIN
    CREATE TEMP TABLE reporteEliminadoTabla ON COMMIT DROP
    AS SELECT * FROM Reportes WHERE idReporte = p_idReporte;

    DELETE FROM Reportes WHERE idReporte = p_idReporte;

    RETURN QUERY SELECT * FROM reporteEliminadoTabla;
END
$function$;

--------------------------- Tabla Prestamos ---------------------------
-- Crear prestamos
CREATE OR REPLACE FUNCTION fun_prestamos_create(
    in p_fechaInicio DATE,
    in p_fechaFin DATE,
    in p_idComputadora INT DEFAULT NULL,
    in p_idInmobiliaria INT DEFAULT NULL,
    in p_matriculaAlum VARCHAR
) RETURNS SETOF Prestamos
LANGUAGE plpgsql
AS $function$
DECLARE
    newPrestamoId INT;
BEGIN
    INSERT INTO Prestamos (FechaInicio, FechaFin, idComputadora, idInmobiliaria, Matricula_Alum)
    VALUES (p_fechaInicio, p_fechaFin, p_idComputadora, p_idInmobiliaria, p_matriculaAlum)
    RETURNING idPrestamo INTO newPrestamoId;

    RETURN QUERY SELECT * FROM Prestamos WHERE idPrestamo = newPrestamoId;
END
$function$;
 
-- Leer un prestamo 
CREATE OR REPLACE FUNCTION fun_prestamos_read(
    in p_idPrestamo INT
) RETURNS SETOF Prestamos
LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY SELECT * FROM Prestamos WHERE idPrestamo = p_idPrestamo;
END
$function$;

-- Actualizar prestamo
CREATE OR REPLACE FUNCTION fun_prestamos_update(
    in p_idPrestamo INT,
    in p_fechaInicio DATE DEFAULT NULL,
    in p_fechaFin DATE DEFAULT NULL,
    in p_idComputadora INT DEFAULT NULL,
    in p_idInmobiliaria INT DEFAULT NULL,
    in p_matriculaAlum VARCHAR DEFAULT NULL
) RETURNS SETOF Prestamos
LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE Prestamos
    SET FechaInicio = COALESCE(p_fechaInicio, FechaInicio),
        FechaFin = COALESCE(p_fechaFin, FechaFin),
        idComputadora = COALESCE(p_idComputadora, idComputadora),
        idInmobiliaria = COALESCE(p_idInmobiliaria, idInmobiliaria),
        Matricula_Alum = COALESCE(p_matriculaAlum, Matricula_Alum)
    WHERE idPrestamo = p_idPrestamo;

    RETURN QUERY SELECT * FROM Prestamos WHERE idPrestamo = p_idPrestamo;
END
$function$;

-- Eliminar reporte
CREATE OR REPLACE FUNCTION fun_prestamos_remove(
    in p_idPrestamo INT
) RETURNS SETOF Prestamos
LANGUAGE plpgsql
AS $function$
BEGIN
    CREATE TEMP TABLE prestamoEliminadoTabla ON COMMIT DROP
    AS SELECT * FROM Prestamos WHERE idPrestamo = p_idPrestamo;

    DELETE FROM Prestamos WHERE idPrestamo = p_idPrestamo;

    RETURN QUERY SELECT * FROM prestamoEliminadoTabla;
END
$function$;