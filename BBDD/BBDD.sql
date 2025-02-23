-- Elimina la base de datos 'ProyectoFinal' si ya existe, para evitar errores.
DROP DATABASE IF EXISTS ProyectoFinal;

-- Crea la base de datos 'ProyectoFinal'.
CREATE DATABASE ProyectoFinal;

-- Selecciona la base de datos 'ProyectoFinal' para trabajar en ella.
USE ProyectoFinal;

-- ====================================
-- Tabla de usuarios
-- ====================================
-- Almacena la información básica de cada usuario.
CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,             -- Identificador único del usuario.
    correo VARCHAR(150) NOT NULL UNIQUE,             -- Email del usuario, debe ser único.
    contrasena VARCHAR(255) NOT NULL,                -- Contraseña del usuario (idealmente encriptada).
    fechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora de registro del usuario.
    esAdministrador BOOLEAN NOT NULL DEFAULT FALSE     -- Indica si el usuario es administrador.
);

-- ====================================
-- Tabla de cuentas bloqueadas
-- ====================================
-- Registra los correos de las cuentas bloqueadas.
CREATE TABLE CuentasBloqueadas (
    id INT AUTO_INCREMENT PRIMARY KEY,     -- Identificador único para cada registro.
    correo VARCHAR(150) NOT NULL UNIQUE      -- Email del usuario bloqueado, debe ser único.
);

-- ====================================
-- Tabla de perfiles
-- ====================================
-- Almacena información personal adicional del usuario.
CREATE TABLE Perfil (
    id INT AUTO_INCREMENT PRIMARY KEY,      -- Identificador único del perfil.
    usuarioId INT NOT NULL UNIQUE,          -- Relación 1:1 con la tabla Usuario.
    nombre VARCHAR(100) NOT NULL,           -- Nombre del usuario.
    apellidos VARCHAR(100) NOT NULL,        -- Apellidos del usuario.
    fecha_nacimiento DATE,                  -- Fecha de nacimiento del usuario.
    telefono INT NOT NULL,                  -- Teléfono del usuario.
    genero ENUM('Masculino', 'Femenino', 'No binario') NOT NULL, -- Género del usuario.
    ubicacion VARCHAR(255) NOT NULL,        -- Ubicación geográfica del usuario.
    buscandoPiso BOOLEAN NOT NULL,          -- Indica si el usuario busca piso (TRUE) o no (FALSE).
    FOREIGN KEY (usuarioId) REFERENCES Usuario(id) ON DELETE CASCADE  -- Si se elimina el usuario, se elimina su perfil.
);

-- ====================================
-- Tabla Buscador
-- ====================================
-- Se utiliza cuando 'buscandoPiso' es TRUE, para usuarios que buscan piso.
CREATE TABLE Buscador (
    id INT AUTO_INCREMENT PRIMARY KEY,      -- Identificador único.
    perfilId INT NOT NULL,                  -- Relación con la tabla Perfil.
    ocupacion VARCHAR(100),                 -- Ocupación del usuario (opcional).
    biografia TEXT NOT NULL,                -- Biografía del usuario.
    FOREIGN KEY (perfilId) REFERENCES Perfil(id) ON DELETE CASCADE  -- Si se elimina el perfil, se elimina este registro.
);

-- ====================================
-- Tabla Propietario
-- ====================================
-- Se utiliza cuando 'buscandoPiso' es FALSE, para usuarios que ofrecen vivienda.
CREATE TABLE Propietario (
    id INT AUTO_INCREMENT PRIMARY KEY,      -- Identificador único.
    perfilId INT NOT NULL,                  -- Relación con la tabla Perfil.
    precio DECIMAL(10, 2) NOT NULL,         -- Precio de la vivienda.
    descripcionVivienda TEXT NOT NULL,      -- Descripción de la vivienda.
    FOREIGN KEY (perfilId) REFERENCES Perfil(id) ON DELETE CASCADE  -- Si se elimina el perfil, se elimina este registro.
);

-- ====================================
-- Tabla de likes
-- ====================================
-- Registra las interacciones (por ejemplo, like o dislike) entre usuarios.
CREATE TABLE Likes (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Identificador único de la interacción.
    usuarioOrigenId INT NOT NULL,                -- Usuario que da la interacción.
    usuarioDestinoId INT NOT NULL,               -- Usuario que recibe la interacción.
    tipoInteraccion BOOLEAN NOT NULL,            -- Tipo de interacción (true/false, por ejemplo: like/dislike).
    fechaLike TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora de la interacción.
    FOREIGN KEY (usuarioOrigenId) REFERENCES Usuario(id) ON DELETE CASCADE,  -- Si se elimina el usuario origen, se eliminan sus likes.
    FOREIGN KEY (usuarioDestinoId) REFERENCES Usuario(id) ON DELETE CASCADE, -- Si se elimina el usuario destino, se eliminan los likes recibidos.
    UNIQUE (usuarioOrigenId, usuarioDestinoId)  -- Evita duplicar interacciones entre el mismo par de usuarios.
);

-- ====================================
-- Tabla de matches
-- ====================================
-- Almacena las coincidencias (matches) entre usuarios.
CREATE TABLE UserMatch (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Identificador único del match.
    usuario1Id INT NOT NULL,                     -- Primer usuario involucrado en el match.
    usuario2Id INT NOT NULL,                     -- Segundo usuario involucrado en el match.
    fechaMatch TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora en que se produjo el match.
    FOREIGN KEY (usuario1Id) REFERENCES Usuario(id) ON DELETE CASCADE, -- Si se elimina el primer usuario, se elimina el match.
    FOREIGN KEY (usuario2Id) REFERENCES Usuario(id) ON DELETE CASCADE, -- Si se elimina el segundo usuario, se elimina el match.
    UNIQUE (usuario1Id, usuario2Id)              -- Evita crear duplicados de match entre los mismos usuarios.
);

-- ====================================
-- Tabla de chats
-- ====================================
-- Almacena los mensajes de chat entre usuarios que han hecho match.
CREATE TABLE Chat (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Identificador único del mensaje.
    matchId INT NOT NULL,                        -- Relación con el match en el que se envía el mensaje.
    mensaje TEXT NOT NULL,                       -- Contenido del mensaje.
    remitenteId INT NOT NULL,                    -- Usuario que envía el mensaje.
    fechaEnvio TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora de envío del mensaje.
    FOREIGN KEY (matchId) REFERENCES UserMatch(id) ON DELETE CASCADE, -- Si se elimina el match, se eliminan los mensajes.
    FOREIGN KEY (remitenteId) REFERENCES Usuario(id) ON DELETE CASCADE -- Si se elimina el remitente, se eliminan sus mensajes.
);

-- ====================================
-- Tabla de imágenes
-- ====================================
-- Almacena imágenes asociadas a los perfiles de usuario.
CREATE TABLE Imagenes (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Identificador único de la imagen.
    perfilId INT NOT NULL,                       -- Relación con la tabla Perfil.
    posicionImagen INT NOT NULL,                 -- Posición u orden de la imagen.
    nombre VARCHAR(255) NOT NULL,                -- Nombre del archivo de imagen.
    tipo VARCHAR(255) NOT NULL,                  -- Tipo o formato de la imagen (por ejemplo, jpg, png).
    datos LONGBLOB,                              -- Datos binarios de la imagen.
    FOREIGN KEY (perfilId) REFERENCES Perfil(id) ON DELETE CASCADE  -- Si se elimina el perfil, se eliminan sus imágenes.
);