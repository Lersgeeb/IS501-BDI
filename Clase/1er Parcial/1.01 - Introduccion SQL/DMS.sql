
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