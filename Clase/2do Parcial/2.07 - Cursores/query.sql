USE CursorProcessing;

SELECT COUNT(*) AS "Count" FROM Measure;

SET @minValue = 40;

CALL sp_sumarizeData(@minValue);

SELECT * FROM MeasureSumarized;