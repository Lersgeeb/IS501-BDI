/*USE TriggerProcessing;*/

DROP PROCEDURE IF EXISTS sp_createNumbers;

DELIMITER $$

CREATE PROCEDURE sp_createNumbers (
    IN max_count INT
)
BEGIN
    DECLARE counter INT DEFAULT 1;
    WHILE (counter <= max_count) DO
        INSERT INTO Numbers() VALUES ();
        SET counter = counter + 1;
    END WHILE;
END $$

DELIMITER ;