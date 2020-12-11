USE TriggerProcessing;

DROP TRIGGER IF EXISTS tg_calculateSquaredRoot;

DELIMITER $$

CREATE TRIGGER tg_calculateSquaredRoot
    AFTER INSERT
    ON Numbers FOR EACH ROW

BEGIN
    INSERT INTO NumbersSquared (num_id_fk, num_squared)
    VALUES (new.id, SQRT(new.id))
END ;

DELIMITER ;