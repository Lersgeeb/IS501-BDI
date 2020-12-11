USE TriggerProcessing;
/*CREAR los números (crea la raíz cuadrada de cada uno usando el trigger)*/
SET @count = 12;
CALL sp_createNumbers();
SELECT * FROM Numbers;
SELECt * FROM NumbersSquared;
/*Previamente se conoce que el cálculo se debe realizar, entonces se planifica dicha operación con un trigger.*/

/*Crea las reaices cuadradas mediante un insert*/
INSERT INTO NumbersSquared_insert(num_id_fk)
    SELECT
        id,
        SQRT(id)
    FROM
        Numbers
;
SELECT * FROM NumbersSquared_insert;
/*Post a la inserción de los datos se encuentra necesidad de realizar el cálculo*/

/*Crea las raices cuadradas cada vez que se visualiza la vista*/
SELECT * FROM vw_NumbersSquared;
/*Si es necesario recalcular los resiltados cada vez que se visualiza la vista*/
