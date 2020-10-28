DROP DATABASE IF EXISTS AdvancedSQLProcedures;
CREATE DATABASE AdvancedSQLProcedures CHARACTER SET utf8;
USE AdvancedSQLProcedures;

    -- Expresiones regulares
    set @record = '{"name":"María García", "age":20, "uid":"0301200001011"}';
    set @pattern = "^08\\d+$";

    SELECT 
        (JSON_UNQUOTE(JSON_EXTRACT(@record, "$.uid"))) AS "UID",
        CASE
            WHEN (JSON_UNQUOTE(JSON_EXTRACT(@record, "$.uid"))) RLIKE @pattern = 0 
            THEN "FALSE"
            ELSE "TRUE"
        END AS "Cumple con el patrón"
    ;

    DROP TABLE IF EXISTS Student;
    CREATE TABLE Student(
        id INT AUTO_INCREMENT PRIMARY KEY,
        jso_record JSON NOT NULL COMMENT "Documento con name, age y uid"
    ) COMMENT "Tabla de estudiantes EA.";


    INSERT INTO Student (jso_record) VALUES
        ('{"name":"María García", "age":20, "uid":"0301200001011"}'),
        ('{"name":"Enrique García", "age":20, "uid":"0501200001011"}'),
        ('{"name":"Juan Almendarez", "age":20, "uid":"1203200002022"}'),
        ('{"name":"Alejandra Almendarez", "age":20, "uid":"1803200002022"}'),
        ('{"name":"Pedro Guillén", "age":19, "uid":"0802199903033"}'),
        ('{"name":"Merced Guillén", "age":19, "uid":"0102199903033"}')
    ;

    /*
        Se desea hacer un recorrido por ciertos departamentos del pais para convencer a estudiantes para que hagan estudios sobre STEM (Science, technology, Engineering and Mathematics). Para ello se requieren estudiantes de dichos departamentos.

        Se desea hacer una tabla que muestre cláramente los estudiantes que estarán involucrados en los siguientes recorridos.

            *Recorrido 1: Atlántida (01), El Paraísoo (07) y Francisco Morazán (08) y Yoro (18).
            *Recorrido 2: La Paz (12), Comayagua (03) y Cortéz (05).
    */

    SELECT
        (JSON_UNQUOTE(JSON_EXTRACT(jso_record,"$.name"))) AS "Nombre del Estudiante",
        CASE
            WHEN (JSON_UNQUOTE(JSON_EXTRACT(jso_record,"$.uid"))) RLIKE "^((0[178])|(1[18]))\\d{11}$" THEN "Recorrido 1"
            WHEN (JSON_UNQUOTE(JSON_EXTRACT(jso_record,"$.uid"))) RLIKE "^((0[35])|(12))\\d{11}$" THEN "Recorrido 2"
        END AS "Recorrido"
    FROM 
        Student
    WHERE
        (JSON_UNQUOTE(JSON_EXTRACT(jso_record,"$.uid"))) RLIKE "^((0[13578])|(1[28]))\\d{11}$"
    ORDER BY
        CASE 
            WHEN (JSON_UNQUOTE(JSON_EXTRACT(jso_record,"$.uid"))) RLIKE "^((0[178])|(1[18]))\\d{11}$" THEN "Recorrido 1"
            WHEN (JSON_UNQUOTE(JSON_EXTRACT(jso_record,"$.uid"))) RLIKE "^((0[35])|(12))\\d{11}$" THEN "Recorrido 2"
        END ASC
    ;
