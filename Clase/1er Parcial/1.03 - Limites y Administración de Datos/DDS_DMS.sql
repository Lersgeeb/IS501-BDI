DROP DATABASE IF EXISTS SQL Testing;

CREATE DATABASE SQLTesting CHARACTER SET utf8;

CREATE TABLE DataType(
    id INT AUTO_INCREMENT PRIMARY KEY,
    bit_active BIT NOT NULL,
    big_population BIGINT NOT NULL,
    tin_students TINYINT UNSIGNED NOT NULL,
    jso_graph JSON NOT NULL,
    dec_salary DECIMAL(8,2),
    flo_bigNumberA FLOAT NOT NULL,
    dou_bigNumberB DOUBLE NOT NULL
);

INSERT INTO DataType(
    bit_active,
    big_population,
    tin_students,
    jso_graph,
    dec_salary,
    flo_bigNumberA,
    dou_bigNumberB
) VALUES
    (0, 8000000000000, 60, '{"vertex1":{"w":12.1, "edges":["vertex2"]},{"vertex2":{"w":1, "edges":[]}}', 0.7, 0.7, 0.7),
    (0, 8000000000000, 60, '{"vertex1":{"w":12.1, "edges":["vertex2"]},{"vertex2":{"w":1, "edges":[]}}', 0.8, 0.8, 0.8),
    (0, 8000000000000, 60, '{"vertex1":{"w":12.1, "edges":["vertex2"]},{"vertex2":{"w":1, "edges":[]}}', 0.8, 0.9, 0.9),
    (0, 8000000000000, 60, '{"vertex1":{"w":12.1, "edges":["vertex2"]},{"vertex2":{"w":1, "edges":[]}}', 0.71, 0.71, 0.71)
;

SELECT
    source.id AS id,
    source.dec_salary AS Salary,
    source.flo_bigNumberA AS bigA,
    source.dou_bigNumberB AS bigB
FROM 
    DataType AS source
WHERE 
    source.id BETWEEN 2 AND 4
LIMIT
    2,2  --Comenzar despues de x, mostrar las y siguientes
;

