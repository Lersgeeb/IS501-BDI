
USE EmpresaBD;

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

-- Actualización

--UPDATE TABLA SET CAMPO = VALOR WHERE CONDICIONAL
UPDATE Tarea SET estado = "completada" WHERE id = 1;

--Consultas
SELECT Tarea.id, Tarea.id_lista, Lista.id_usuario, Tarea.descripcion FROM Tarea JOIN Lista On Tarea.id_lista = Lista.id;

SELECT Lista.id_usuario AS "Identidicador de Usuario", COUNT(*) AS "Cantidad de tareas del usuario" FROM Tarea JOIN Lista ON Tarea.id_lista = Lista.id GROUP BY Lista.id_usuario;

SELECT Lista.id_usuario AS "Identificador de Usuario", Tarea.estado AS "Estado de la Tarea", COUNT(*) AS "Cantidad de Tareas" FROM Tarea JOIN Lista ON Tarea.id_lista = Lista.id GROUP BY Lista.id_usuario, Tarea.estado;


--SubConsulta
SELECT Lista.id_usuario AS "Identificador de Usuario", Tarea.estado AS "Estado de la Tarea", COUNT(*) AS "Cantidad de Tareas" , (SELECT COUNT(*) FROM Tarea JOIN Lista ON Tarea.id_lista = Lista.id WHERE Lista.id_usuario = Usuario.id) AS "Total de Registros del Usuario", CONCAT(COUNT(*)/(SELECT COUNT(*) FROM Tarea JOIN Lista ON Tarea.id_lista = Lista.id WHERE Lista.id_usuario = Usuario.id)*100, " %") AS "Porcentaje" FROM Tarea JOIN Lista ON Tarea.id_lista = Lista.id JOIN Usuario on Lista.id_usuario = Usuario.id GROUP BY Lista.id_usuario, Tarea.estado;