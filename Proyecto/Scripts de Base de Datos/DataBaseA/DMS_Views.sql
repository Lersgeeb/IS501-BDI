USE BaseA

DROP VIEW IF EXISTS OperatorUsers;

CREATE VIEW OperatorUsers AS
    SELECT
        id,
        AES_DECRYPT(UNHEX(txt_name), 'root') 
    FROM
        Account
    WHERE
        id_role = 2
    ORDER BY
        id ASC
;