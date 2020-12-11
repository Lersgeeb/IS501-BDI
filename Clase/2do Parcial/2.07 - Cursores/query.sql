USE CursorProssesing;

SELECT COUNT(*) AS "Count" FROM Measure;

SET @minValue = 37;

CALL sp_sumarizeData(@minValue);

SELECT * FROM MeasureSumarized;