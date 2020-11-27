USE Example;

DROP VIEW IF EXISTS FirstDeviceMeasureRecent;

CREATE VIEW FirstDeviceMeasureRecent AS
    SELECT
        *
    FROM
        Measure
    WHERE
        device = 1
    ORDER BY
        id ASC
    LIMIT
        1000
;

SELECT "First Device Measure Recent" AS "View", COUNT(*) AS "Count" FROM FirstDeviceMeasureRecent;

/*
    1) Cree una vista que muestre la cantidad de  registros por cada mes, para el año 2020, llamado "CountMonth2020".
*/

DROP VIEW IF EXISTS CountMonth2020;

CREATE VIEW CountMonth2020 AS
    SELECT
        MONTH(Measure.date) AS "Month",
        COUNT(*) AS "Count"
    FROM 
        Measure
    WHERE
        YEAR(Measure.date) = 2020
    GROUP BY
        MONTH(Measure.date)
    ORDER BY
        MONTH(Measure.date)  ASC
;

SELECT * FROM CountMonth2020;
/*
    2) En el Departamento de TI de una institución financiera se desea registrar de forma permanente la consulta que genera el informe  de la cantidad de elementos de medición por hora del día, para el mes de noviembre de 2020. Esta consulta deberá guardarse comom "CountByDayOnNovember2020".
*/

DROP VIEW IF EXISTS CountByDayOnNovember2020;

CREATE VIEW CountByDayOnNovember2020 AS
    SELECT
        HOUR(Measure.date) AS "Hour",
        COUNT(*) AS "Count"
    FROM
        Measure
    WHERE 
        MONTH(Measure.date) = 11 AND
        YEAR(Measure.date) = 2020
    GROUP BY
        HOUR(Measure.date)
    ORDER BY
        HOUR(Measure.date) ASC
;

SELECT * FROM CountByDayOnNovember2020
