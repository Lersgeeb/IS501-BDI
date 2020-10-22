DROP DATABASE IF EXISTS Matrix;

CREATE DATABASE Matrix CHARACTER SET utf8;

USE Matrix;



/*
CREATE TABLE Matrix_A(
    row_index INT AUTO_INCREMENT PRIMARY KEY, 
    c1 INT, 
    c2 INT,
    c3 INT
);

CREATE TABLE Matrix_B(
    row_index INT AUTO_INCREMENT PRIMARY KEY, 
    c1 INT, 
    c2 INT,
    c3 INT
);


INSERT INTO Matrix_A (c1, c2, c3) Values 
    (2, 5, 2),
    (8, 4, 3),
    (3, 1, 5)
;

INSERT INTO Matrix_B (c1, c2, c3) Values 
    (1, 4, 3),
    (2, 5, 8),
    (1, 3, 7)
;


SELECT * FROM Matrix_A CROSS JOIN Matrix_B;
*/


CREATE TABLE Matrix_A(
    row_index INT, 
    col_index INT, 
    pos_value INT
);

CREATE TABLE Matrix_B(
    row_index INT, 
    col_index INT, 
    pos_value INT
);

INSERT INTO Matrix_A (row_index, col_index, pos_value) Values 
    (1,1,2),
    (1,2,4),
    (1,3,5),
    (2,1,6),
    (2,2,8),
    (2,3,5),
    (3,1,1),
    (3,2,1),
    (3,3,2)
;

INSERT INTO Matrix_B (row_index, col_index, pos_value) Values 
    (1,1,3),
    (1,2,4),
    (1,3,6),
    (2,1,2),
    (2,2,4),
    (2,3,2),
    (3,1,9),
    (3,2,6),
    (3,3,2)
;

SELECT * FROM Matrix_A;
SELECT * FROM Matrix_B;

SELECT MA.row_index , MB.col_index, SUM(MA.pos_value*MB.pos_value) FROM Matrix_A AS MA INNER JOIN Matrix_B AS MB ON MA.col_index = MB.row_index GROUP BY MA.row_index, MB.col_index;

SELECT * FROM Matrix_A AS MA INNER JOIN Matrix_B AS MB ON MA.col_index = MB.row_index;
