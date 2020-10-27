DROP DATABASE IF EXISTS AdvancedSQLProcedures;
CREATE DATABASE AdvancedSQLProcedures;
USE AdvancedSQLProcedures;

    -- Se define una variable con el contenido de un caso de uso
    SET @sampleCategory = "folder";

    -- Se aplica un caso de selección
    SELECT 
        CASE 
            WHEN @sampleCategory = "folder" THEN "01f02"
            WHEN @sampleCategory = "file" THEN "01f03"
            ELSE "UNK000"
        END AS "Type of Item as a Code"
    ;

    -- Se crea tabla de cola de peticiones
    DROP TABLE IF EXISTS RequestQueue;
    CREATE TABLE RequestQueue(
        id INT AUTO_INCREMENT PRIMARY KEY,
        jso_request JSON NOT NULL COMMENT "Petición API en formato JSON",
        bit_read BIT NOT NULL COMMENT "Estado de la petición: atendida o no atendida"
    ) COMMENT "Tabla de peticiones de usuario en forma de cola";

    

    INSERT INTO RequestQueue (jso_request, bit_read) VALUES
        ('{"service":"00f21x2", "user":"bdi", "command":"INBOX"}', 1),
        ('{"service":"00f21x2", "user":"bdi", "command":"TRASH"}', 0)
    ;

    -- Seleccione el último registro de petición no atendido. Almacenar en un espacio de memoria temporal, el valor resultante
    SET @lastRequest = (SELECT jso_request FROM RequestQueue WHERE bit_read = 0 ORDER BY id ASC LIMIT 1);

    -- Obtener del último registri no atendido, el comando recibido
    SET @lastCommand = JSON_EXTRACT(@lastRequest, "$.command");
    SET @lastCommand = REPLACE( @lastCommand, "\"", "");

    -- Se demuestra que las variables contienen la información deseada
    SELECT @lastRequest AS "Ultima petición en Queue", @lastCommand AS "Ultimo comando";

    -- Se realiza un caso dependiendo del dato obtenido
    SELECT
        @lastCommand AS "Ultimo comando", 
        CASE
            WHEN @lastCommand = "INBOX" THEN "Solicitud de Inbox SMTP de la bandeja de correo."
            WHEN @lastCommand = "TRASH" THEN "Solicitud de TRASH SMTP de la bandeja de correo."
            ELSE "Instrucción desconocida"
        END AS "Acción solicitada (=)",
        CASE
            WHEN @lastCommand = "INBOX" THEN "Solicitud de Inbox SMTP de la bandeja de correo."
            WHEN @lastCommand = "TRASH" THEN "Solicitud de TRASH SMTP de la bandeja de correo."
            ELSE "Instrucción desconocida"
        END AS "Acción solicitada (LIKE)",
        CASE
            WHEN @lastCommand = "INBOX" THEN "Solicitud de Inbox SMTP de la bandeja de correo."
            WHEN @lastCommand = "TRASH" THEN "Solicitud de TRASH SMTP de la bandeja de correo."
            ELSE "Instrucción desconocida"
        END AS "Acción solicitada (STRCMP)"
    ;

    -- Se realiza un caso dependiendo del dato obtenido, limpiando las cadenas con TRIM
    SELECT
        @lastCommand AS "Ultimo comando", 
        CASE
            WHEN TRIM(@lastCommand) = "INBOX" THEN "Solicitud de Inbox SMTP de la bandeja de correo."
            WHEN TRIM(@lastCommand) = "TRASH" THEN "Solicitud de TRASH SMTP de la bandeja de correo."
            ELSE "Instrucción desconocida"
        END AS "Acción solicitada (=)",
        CASE
            WHEN TRIM(@lastCommand) LIKE "INBOX" THEN "Solicitud de Inbox SMTP de la bandeja de correo."
            WHEN TRIM(@lastCommand) LIKE "TRASH" THEN "Solicitud de TRASH SMTP de la bandeja de correo."
            ELSE "Instrucción desconocida"
        END AS "Acción solicitada (LIKE)",
        CASE
            WHEN STRCMP(TRIM(@lastCommand), "INBOX") THEN "Solicitud de Inbox SMTP de la bandeja de correo."
            WHEN STRCMP(TRIM(@lastCommand), "TRASH") THEN "Solicitud de trash SMTP de la bandeja de correo."
            ELSE "Instrucción desconocida"
        END AS "Acción solicitada (STRCMP)"
    ;


/*
    Al estudiante:
    * Encapsular en un SP, los componentes núcleos de este ejercicio.
    * Aplicar la correcta implementacion del método STRCMP.
*/
