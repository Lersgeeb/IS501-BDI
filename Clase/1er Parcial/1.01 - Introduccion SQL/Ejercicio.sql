-- Creación de la base de datos.
CREATE DATABASE IF NOT EXISTS EmpresaBD;

-- Se selecciona la base de datos para su uso.
USE EmpresaBD;

--Se crean las tablas de base de datos.
    CREATE TABLE IF NOT EXISTS Gerencia(
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(200) NOT NULL
    ) CHARACTER SET utf8;

    CREATE TABLE IF NOT EXISTS Departamento(
        id INT AUTO_INCREMENT PRIMARY KEY, 
        id_gerencia INT NOT NULL,
        nombre VARCHAR(200) NOT NULL
    ) CHARACTER SET utf8;

    Create TABLE IF NOT EXISTS Usuario(
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_departamento INT NOT NULL,
        nombre VARCHAR(200) NOT NULL
    ) CHARACTER SET utf8;

    CREATE TABLE IF NOT EXISTS Lista(
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_usuario INT NOT NULL,
        nombre TEXT NOT NULL,
        creacion TIMESTAMP DEFAULT NOW(),
        actualizacion TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
        estado ENUM('vigente', 'archivada', 'eliminada') DEFAULT 'vigente'
    ) CHARACTER SET utf8;

    CREATE TABLE IF NOT EXISTS Tarea(
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_lista INT NOT NULL,
        descripcion TEXT NOT NULL,
        creacion TIMESTAMP DEFAULT NOW(),
        actualizacion TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
        estado ENUM('completada', 'no completada') DEFAULT 'no completada'
    ) CHARACTER SET utf8;

-- En caso que no se han creado nuevas tablas, se eliminarán  los datos existentes.
TRUNCATE Gerencia;
TRUNCATE Departamento;
TRUNCATE Usuario;
TRUNCATE Lista;
TRUNCATE Tarea;

-- Se agregan datos de prueba a las tablas.

INSERT INTO Gerencia(nombre) VALUES
    ("Tecnologías de información"),
    ("Mercadeo")
;

INSERT INTO Departamento(id_gerencia, nombre) VALUES
    (1, "Desarrollo Web"),
    (1, "Desarrollo Móvil"),
    (2, "Canales Digitales")
;

INSERT INTO Usuario(id_departamento, nombre) VALUES
    (1, "Alan Vigil"),
    (2, "Alejandra Ramos"),
    (3, "Yelmi Elvir")
;

INSERT INTO Lista(id_usuario, nombre) VALUES
    (1, "Bases de Datos 1"),
    (2, "Videojuegos para los feriados"),
    (3, "Películas pendientes")
;

INSERT INTO Tarea(id_lista, descripcion) VALUES
    (1, "Aprender sobre el modelo ER."),
    (1, "Aprender sobre el modelo Relacional."),
    (1, "Listar todas las sentencias de SQL para insertar, eliminar, modificar y seleccionar registros."),
    (2, "Metal Gear Solid Collection."),
    (3, "El Silencio de los Ino...")
;