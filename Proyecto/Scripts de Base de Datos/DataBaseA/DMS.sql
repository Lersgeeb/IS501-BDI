USE BaseA;

/*INSERT INTO Role ( txt_roleName ) VALUES
    ("ADMIN"),
    ("OPERADOR")
;*/

/*INSERT INTO Action ( txt_actionName ) VALUES
    ("VIZUALIZACION"),
    ("MODIFICACION"),
    ("ELIMINACION"),
    ("AUTENTICACION"),
    ("CREACION")
;

INSERT INTO Element ( txt_elementType ) VALUES
    ("DIBUJO"),
    ("CONFIGURACION"),
    ("USUARIO")
;*/

/*TRUNCATE TABLE Account;*/

INSERT INTO Account ( txt_name , txt_password, id_role) VALUES
    ( "root" , "root" , 1)
;

INSERT INTO Account ( txt_name , txt_password) VALUES
    ( "Gabriel" , "1234" ),
    ( "Fernando" , "140403" ),
    ( "Josue" , "hola" ),
    ( "Caleb" , "0000" )
;

/*
INSERT INTO Account ( txt_name , txt_password, id_role) VALUES
    ( HEX(AES_ENCRYPT("root", 'root')) , HEX(AES_ENCRYPT("root", 'root')) , 1)
;

INSERT INTO Account ( txt_name , txt_password) VALUES
    ( HEX(AES_ENCRYPT("Gabriel", 'root')) , HEX(AES_ENCRYPT("1234", 'root')) ),
    ( HEX(AES_ENCRYPT("Fernando", 'root')) , HEX(AES_ENCRYPT("140403", 'root')) ),
    ( HEX(AES_ENCRYPT("Josue", 'root')) , HEX(AES_ENCRYPT("hola", 'root')) ),
    ( HEX(AES_ENCRYPT("Caleb", 'root')) , HEX(AES_ENCRYPT("0000", 'root')) )
;
*/