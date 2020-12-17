SELECT 
        LogBook.id,
        LogBook.tim_recordDate AS Fecha_Creación,
        Account.txt_name AS Usuario,
        Action.txt_actionName AS Acción,
        Element.txt_elementType,
        LogBook.txt_elementName
    FROM 
        LogBook 
        JOIN Account ON Account.id = LogBook.accountId 
        JOIN Action ON Action.id= LogBook.actionId 
        JOIN Element ON Element.id = LogBook.elementId
    ORDER BY
        LogBook.id ASC
;

SELECT
        Config.txt_penColor,
        Config.txt_fillColor,
        Config.int_width,
        Config.int_radius,
        Account.txt_name
    FROM
        Config
        JOIN Account ON Config.accountId = Account.id
;