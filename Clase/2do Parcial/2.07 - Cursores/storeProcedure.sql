DROP DATABASE IF EXISTS CursorProcessing;
CREATE DATABASE CursorProcessing CHARACTER SET utf8;
USE CursorProcessing;

DROP TABLE IF EXISTS Measure;
DROP TABLE IF EXISTS MeasureReviewed;
DROP TABLE IF EXISTS MeasureSumarized;

CREATE TABLE Measure (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT "AutoIncremental.",
    num_device INT NOT NULL COMMENT "Identificador del dispositivo.",
    num_temperature DECIMAL (10,4) DEFAULT NULL COMMENT "Temperatura en celcius.",
    dat_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "Fecha de la captura."
) COMMENT = "Histórico de mediciones";

CREATE TABLE MeasureReviewed (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT "AutoIncremental.",
    num_measure_fk INT NOT NULL COMMENT "Identificador de la medición",
    dat_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "Fecha de la revisión.",
    FOREIGN KEY (num_measure_fk) REFERENCES Measure(id) ON DELETE CASCADE ON UPDATE CASCADE
) COMMENT="Histórico de versiones automáticas";

INSERT INTO Measure(num_device, num_temperature,dat_date) VALUES (1,36.42,'2020-12-01 20:45:11'),
(3,37.25,'2020-12-01 20:45:11'),
(1,37.22,'2020-12-01 20:45:11'),
(2,38.66,'2020-12-01 20:45:11'),
(2,38.32,'2020-12-01 20:45:12'),
(3,38.40,'2020-12-01 20:45:12'),
(1,39.52,'2020-12-01 20:45:12'),
(2,39.11,'2020-12-01 20:45:12'),
(1,40.25,'2020-12-01 20:45:13'),
(3,40.22,'2020-12-01 20:45:13'),
(1,41.62,'2020-12-01 20:45:13'),
(2,41.38,'2020-12-01 20:45:14'),
(2,42.16,'2020-12-01 20:45:14'),
(3,42.58,'2020-12-01 20:45:14'),
(1,42.29,'2020-12-01 20:45:15'),
(2,43.32,'2020-12-01 20:45:15'),
(1,43.60,'2020-12-01 20:45:15')
;

CREATE TABLE MeasureSumarized (
    num_lower INT NOT NULL DEFAULT 0 COMMENT "Cantidad de valores de mayor temperatura",
    num_higher INT NOT NULL DEFAULT 0 COMMENT "Cantidad de valores de mayor temperatura"
) COMMENT="Histórico de revisiones automáticas";

-- Insert one registry for MeasureSumarized
INSERT INTO MeasureSumarized() VALUES ();

DROP PROCEDURE IF EXISTS sp_sumarizeData;

DELIMITER $$

CREATE PROCEDURE sp_sumarizeData(
    IN minValue INT
)
BEGIN

    DECLARE finished INT DEFAULT 0;
    DECLARE theId INT DEFAULT 0;
    DECLARE theTemp FLOAT DEFAULT 0.0;
    DECLARE lowerCounter INT DEFAULT 0;
    DECLARE higherCounter INT DEFAULT 0;

    DECLARE cursorCounter
        CURSOR FOR
            SELECT id,num_temperature FROM Measure; /*--JOIN MeasureReviewed ... cambio para no recorrer los registros ya revisados*/

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    OPEN cursorCounter;
        getCounter: LOOP
            FETCH cursorCounter INTO theId, theTemp;

            IF finished = 1 THEN
                LEAVE getCounter;
            END IF;

            IF theTemp <= minValue THEN
                SET lowerCounter = lowerCounter + 1;
            ELSE
                SET higherCounter = higherCounter + 1;
            END IF;

        END LOOP getCounter;
    CLOSE cursorCounter;
    UPDATE MeasureSumarized SET num_lower = lowerCounter, num_higher = higherCounter;

END$$

DELIMITER ;