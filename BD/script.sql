-- Creación de la tabla Roles
CREATE TABLE Roles (
    idRol SERIAL PRIMARY KEY,
    NombreRol VARCHAR(50) UNIQUE NOT NULL
);

-- Creación de la tabla Usuarios
CREATE TABLE Usuarios (
    idUsuario SERIAL PRIMARY KEY,
    NombreUsuario VARCHAR(100) UNIQUE NOT NULL,
    Contrasena VARCHAR(100) NOT NULL,
    idRol INT NOT NULL,
    FOREIGN KEY (idRol) REFERENCES Roles (idRol)
);

-- Creación de la tabla Alumnos
CREATE TABLE Alumnos (
    Matricula SERIAL PRIMARY KEY,
    NombreAlum VARCHAR(100) NOT NULL,
    ApellidoAlum VARCHAR(100) NOT NULL,
    GrupoAlum VARCHAR(50) NOT NULL,
    CarreraAlum VARCHAR(100) NOT NULL
);

-- Creación de la tabla Laboratorios
CREATE TABLE Laboratorios (
    idSalon SERIAL PRIMARY KEY,
    EdificioLab VARCHAR(50) NOT NULL,
    TipoEquipoLab VARCHAR(100),
    NombreLab VARCHAR(100)
);

-- Tabla para almacenar información específica de las computadoras
CREATE TABLE Computadoras (
    idComputadora SERIAL PRIMARY KEY,
    Matricula_Alum INT,
    idSalon INT,
    Silla VARCHAR (100),
    Cables VARCHAR (300),
    Perifericos VARCHAR(300),
        Estado VARCHAR(50) DEFAULT 'Operativo' CHECK (
            Estado IN (
                'Operativo',
                'En Uso',
                'En Mantenimiento',
                'Fuera de Servicio'
            )
        ),
    FechaRegistro DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (Matricula_Alum) REFERENCES Alumnos (Matricula),
    FOREIGN KEY (idSalon) REFERENCES Laboratorios (idSalon)
);

-- Tabla general de inmobiliaria para otros artículos
CREATE TABLE Inmobiliaria (
    idArticulo SERIAL PRIMARY KEY,
    NombreArticulo VARCHAR(100) NOT NULL,
    CategoriaArtic VARCHAR(100) NOT NULL, -- La categoría como columna directa
    EstadoArtic VARCHAR(50) DEFAULT 'Disponible' CHECK (
        EstadoArtic IN (
            'Disponible',
            'En Uso',
            'En Mantenimiento',
            'Fuera de Servicio'
        )
    ),
    idSalon INT, -- Asignación del laboratorio
    DescripcionArtic TEXT, -- Descripción adicional sobre el artículo (opcional)
    FechaRegistroArtic DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (idSalon) REFERENCES Laboratorios (idSalon)
);

-- Creación de la tabla Reporte
CREATE TABLE Reporte (
    idReporte SERIAL PRIMARY KEY,
    textoReporte TEXT NOT NULL,
    Matricula_alum INT, -- Alumno que genera el reporte
    idSalon INT NOT NULL, -- Relación con el laboratorio
    FechaReporte DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (Matricula_alum) REFERENCES Alumnos (Matricula),
    FOREIGN KEY (idSalon) REFERENCES Laboratorios (idSalon)
);

-- Creación de la tabla Prestamos con restricciones adicionales
CREATE TABLE Prestamos (
    idPrestamo SERIAL PRIMARY KEY,
    Matricula_Alum INT NOT NULL, -- Alumno que realiza el préstamo
    -- idComputadora INT NULL, -- Computadora prestada (si aplica)
    idArticulo INT NULL, -- Artículo de inmobiliaria prestado (si aplica)
    FechaPrestamo DATE DEFAULT CURRENT_DATE, -- Fecha en que se realiza el préstamo
    FechaDevolucion DATE, -- Fecha de devolución esperada
    Estado VARCHAR(50) DEFAULT 'Pendiente' CHECK (
        Estado IN ('Pendiente', 'Devuelto')
    ), -- Estado del préstamo
    FOREIGN KEY (Matricula_Alum) REFERENCES Alumnos (Matricula),
    -- FOREIGN KEY (idComputadora) REFERENCES Computadoras (idComputadora),
    FOREIGN KEY (idArticulo) REFERENCES Inmobiliaria (idArticulo),
    CONSTRAINT chk_fecha_devolucion CHECK (
        FechaDevolucion IS NULL
        OR FechaDevolucion >= FechaPrestamo
    ) /*,
    CONSTRAINT chk_id_computadora_o_articulo CHECK (
        (
            idComputadora IS NOT NULL
            AND idArticulo IS NULL
        )
        OR (
            idComputadora IS NULL
            AND idArticulo IS NOT NULL
        )
    )*/
);

-- Crear un índice en las columnas importantes para mejorar la eficiencia de las consultas
CREATE INDEX idx_estado_prestamo ON Prestamos (Estado);

CREATE INDEX idx_fecha_prestamo ON Prestamos (FechaPrestamo);

CREATE INDEX idx_matricula_alumno ON Prestamos (Matricula_Alum);

-- La siguiente consulta crea una restricción condicional para evitar préstamos simultáneosT 

CREATE UNIQUE INDEX uq_prestamo_articulo ON Prestamos (idArticulo)
WHERE
    Estado = 'Pendiente'
    AND idArticulo IS NOT NULL;

-- Vistas

CREATE or REPLACE VIEW view_Alumnos as SELECT * FROM usuarios

-- Funciones Tabla laboratorios
