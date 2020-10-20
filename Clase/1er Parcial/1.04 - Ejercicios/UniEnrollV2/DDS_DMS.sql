DROP DATABASE IF EXISTS UniEnrollV2;

CREATE DATABASE UniEnrollV2 CHARACTER SET utf8;

USE UniEnrollV2;

CREATE TABLE Student(
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL ,
    tex_first_name TEXT NOT NULL,
    tex_last_name TEXT NOT NULL
);

CREATE TABLE UniSubject(
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    tex_name TEXT NOT NULL,
    int_vu INT NOT NULL,
    chr_code CHAR(6)
);

CREATE TABLE Teacher(
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    tex_first_name TEXT NOT NULL,
    tex_last_name TEXT NOT NULL,
    dec_salary DECIMAL(10,2) NOT NULL
);

/* Another option to add FOREIGN CONSTRAINT: id_subject INT NOT NULL REFERENCES UniSubject (id)*/
CREATE TABLE Section(
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL, 
    id_subject INT NOT NULL,
    id_teacher INT NOT NULL,
    chr_section CHAR(4) NOT NULL
);

CREATE TABLE Enroll(
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    id_student INT NOT NULL,
    id_section INT NOT NULL
);

/*DMS: Adding data and constraints to each table that need it*/
ALTER TABLE Section
    ADD CONSTRAINT Section_SubjectFK
        FOREIGN KEY (id_subject) REFERENCES UniSubject (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    ADD CONSTRAINT Section_teacherFK
        FOREIGN KEY (id_teacher) REFERENCES Teacher (id)
        ON UPDATE CASCADE 
        ON DELETE CASCADE;


ALTER TABLE Enroll
    ADD CONSTRAINT Enroll_StudentFK
        FOREIGN KEY (id_student) REFERENCES Student (id)
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
   
    ADD CONSTRAINT Enroll_SectionFK
        FOREIGN KEY (id_section) REFERENCES Section (id)
        ON UPDATE CASCADE 
        ON DELETE CASCADE;
    
INSERT INTO Student (tex_first_name, tex_last_name) VALUES
    ("Gabriel","Escobar"),
    ("Alejandro", "Flores"),
    ("Karla", "Castillo")
;

INSERT INTO UniSubject(tex_name, int_vu, chr_code) VALUES 
    ("Matemática I", 5, "MM-110"),
    ("Geometría y Trigonometría", 5, "MM-111"),
    ("Programación I ", 3, "MM-314"),
    ("Introducción a la Ingeniería en sistemas ", 3, "IS-110"),
    ("Sociología", 3, "SC-101"),
    ("Español", 3, "EG-011"),
    ("Inglés I", 4, "IN-101")
;

INSERT INTO Teacher(tex_first_name, tex_last_name, dec_salary) VALUES 
    ("Daniel", "Cruz", 60000.00),
    ("Hector", "Goméz", 40000.00),
    ("Xavier", "Bustillo", 40000.00),
    ("Carlos", "Zelaya", 40000.00),
    ("Pablo", "Solorzano", 20000.00)
;

INSERT INTO Section(id_teacher, id_subject)
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

INSERT INTO Enroll(id_student, id_section)
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

