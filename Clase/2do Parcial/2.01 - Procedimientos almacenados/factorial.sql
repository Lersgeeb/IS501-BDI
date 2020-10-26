DROP DATABASE IF EXISTS AdvancedSQLProcedures;

CREATE DATABASE AdvancedSQLProcedures;

USE AdvancedSQLProcedures;

DELIMITER $$

SET @@SESSION.max_sp_recursion_depth = 25$$

DROP PROCEDURE IF EXISTS sp_factorial$$

CREATE PROCEDURE sp_factorial( IN N INT, OUT FACT INT)
BEGIN

    IF N = 1 THEN
        SELECT 1 INTO FACT;
    ELSE
        CALL sp_factorial(N-1, @TEMP);
        SELECT N*@TEMP INTO FACT;
    END IF;

END $$

DELIMITER ;

SET @fact = 0;

CALL sp_factorial(5, @fact);

SELECT @fact AS "Factorial de 5";

 /*
    SHOW PROCEDURE STATUS WHERE DB = 'ADvancedSQLPRocedures';
 */