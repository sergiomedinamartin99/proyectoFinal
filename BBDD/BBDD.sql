DROP DATABASE IF EXISTS ProyectoFinal;

CREATE DATABASE ProyectoFinal;

USE ProyectoFinal;

-- Tabla de usuarios
CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(150) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    fechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de perfiles
CREATE TABLE Perfil (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuarioId INT NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    edad INT NOT NULL,
    telefono INT NOT NULL,
    genero ENUM('Masculino', 'Femenino') NOT NULL,
    buscandoPiso BOOLEAN NOT NULL,
    biografia TEXT,
    ubicacion VARCHAR(255) NOT NULL,
    FOREIGN KEY (usuarioId) REFERENCES Usuario(id) ON DELETE CASCADE
);

-- Tabla de likes
CREATE TABLE Likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuarioOrigenId INT NOT NULL,
    usuarioDestinoId INT NOT NULL,
    tipoInteraccion BOOLEAN NOT NULL,
    fechaLike TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuarioOrigenId) REFERENCES Usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (usuarioDestinoId) REFERENCES Usuario(id) ON DELETE CASCADE,
    UNIQUE (usuarioOrigenId, usuarioDestinoId)
);

-- Tabla de matches
CREATE TABLE UserMatch (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario1Id INT NOT NULL,
    usuario2Id INT NOT NULL,
    fechaMatch TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario1Id) REFERENCES Usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario2Id) REFERENCES Usuario(id) ON DELETE CASCADE,
    UNIQUE (usuario1Id, usuario2Id)
);

-- Tabla de chats
CREATE TABLE Chat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matchId INT NOT NULL,
    mensaje TEXT NOT NULL,
    remitenteId INT NOT NULL,
    fechaEnvio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (matchId) REFERENCES UserMatch(id) ON DELETE CASCADE,
    FOREIGN KEY (remitenteId) REFERENCES Usuario(id) ON DELETE CASCADE
);

-- Tabla de imágenes
CREATE TABLE Imagenes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    perfilId INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(255) NOT NULL,
    datos LONGBLOB,
    FOREIGN KEY (perfilId) REFERENCES Perfil(id) ON DELETE CASCADE
);