DROP DATABASE IF EXISTS UniEnroll;
CREATE DATABASE UniEnroll CHARACTER SET utf8;

USE UniEnroll;

CREATE TABLE IF NOT EXISTS Student(
    id INT PRIMARY KEY  AUTO_INCREMENT NOT NULL,
    txt_first_name TEXT NOT NULL,
    txt_last_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Class(
    id INT PRIMARY KEY  AUTO_INCREMENT NOT NULL,
    txt_name TEXT NOT NULL,
    tiny_uv TINYINT NOT NULL,
    chr_code CHAR(6)
);

CREATE TABLE IF NOT EXISTS Teacher(
    emp_id INT PRIMARY KEY  AUTO_INCREMENT NOT NULL,
    txt_first_name TEXT NOT NULL,
    txt_last_name TEXT NOT NULL,
    dec_salary DECIMAL(8,2)
);

CREATE TABLE IF NOT EXISTS Enroll(
    id INT PRIMARY KEY  AUTO_INCREMENT NOT NULL,
    id_student INT NOT NULL,
    id_class INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Work_on(
    id INT PRIMARY KEY  AUTO_INCREMENT NOT NULL,
    id_teacher INT NOT NULL,
    id_class INT NOT NULL
);

ALTER TABLE Enroll
ADD CONSTRAINT ENROLL_STD_FK
    FOREIGN KEY (id_student) REFERENCES Student (id),
ADD CONSTRAINT ENROLL_CLSS_FK
    FOREIGN KEY (id_class) REFERENCES Class (id);

ALTER TABLE Work_on
ADD CONSTRAINT WORK_TCHR_FK
    FOREIGN KEY (id_teacher) REFERENCES Teacher (emp_id),
ADD CONSTRAINT WORK_CLSS_FK
    FOREIGN KEY (id_class) REFERENCES Class (id);


INSERT INTO Student(txt_first_name, txt_last_name)
VALUES 
    ("Gabriel","Escobar"),
    ("Alejandro", "Flores"),
    ("Karla", "Castillo")
;

INSERT INTO Class(txt_name, int_uv, chr_code)
VALUES 
    ("Matemática I", 5, "MM-110"),
    ("Geometría y Trigonometría", 5, "MM-111"),
    ("Programación I ", 3, "MM-314"),
    ("Introducción a la Ingeniería en sistemas ", 3, "IS-110"),
    ("Sociología", 3, "SC-101"),
    ("Español", 3, "EG-011"),
    ("Inglés I", 4, "IN-101")
;

INSERT INTO Teacher(txt_first_name, txt_last_name, dec_salary)
VALUES 
    ("Daniel", "Cruz", 60000.00),
    ("Hector", "Goméz", 40000.00),
    ("Xavier", "Bustillo",40000.00),
    ("Carlos", "Zelaya",40000.00),
    ("Pablo", "Solorzano", 20000.00)
;

INSERT INTO Enroll(id_student, id_class)
VALUES 
   (1,1),
   (1,2),
   (1,4),
   (1,5),
   (1,7),
   (2,1),
   (2,5),
   (2,6),
   (2,7),
   (3,2),
   (3,3),
   (3,5)
;

INSERT INTO Work_on(id_teacher, id_class)
VALUES 
    (1,1),
    (1,2),
    (1,3),
    (2,3),
    (2,4),
    (3,1),
    (3,2),
    (4,6),
    (4,7),
    (5,5)
;


/*
SELECT * FROM Student;
SELECT * FROM Class;
SELECT * FROM Teacher;
SELECT * FROM Enroll;
SELECT * FROM Work_on;

/*Consultas
    Clases matriculadas por cada estudiante
        
        SELECT e.id_student AS "ID Estudiante", s.txt_first_name AS "Primer Nombre", s.txt_last_name AS "Primer Apellido", COUNT(*) AS "Clases matriculadas" FROM Enroll AS e INNER JOIN Student AS s ON e.id_student=s.id GROUP BY e.id_student;
        
        simplificado:
        SELECT e.id_student, COUNT(*) AS "Class_total" FROM Enroll AS e GROUP BY e.id_student;
        
    1.Promedio de asignaturas que matricula un estudiante.
      SELECT CAST(AVG(prom.Class_total) AS DECIMAL(4,2)) AS "Promedio matriculas" FROM (SELECT e.id_student, COUNT(*) AS "Class_total" FROM Enroll AS e GROUP BY e.id_student) AS prom;
      
      simplificado:
      SELECT AVG(prom.Class_total) FROM (SELECT e.id_student, COUNT(*) AS "Class_total" FROM Enroll AS e GROUP BY e.id_student) AS prom;

    Promedio de asignaturas asignadas a un catedrático.
*/