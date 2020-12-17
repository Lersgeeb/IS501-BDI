USE BaseA;

/* Eliminamos los procedimiento en caso de que existan y así sucesivamente para cada procedimiento definido*/
DROP PROCEDURE IF EXISTS Auth_SP;
DROP PROCEDURE IF EXISTS GetRole_SP;
DROP PROCEDURE IF EXISTS CreateDrawing_SP;
DROP PROCEDURE IF EXISTS UpdateDrawingByID_SP;
DROP PROCEDURE IF EXISTS GetDrawingByID_SP;
DROP PROCEDURE IF EXISTS DeleteDrawingByID_SP;
DROP PROCEDURE IF EXISTS AddAccount_SP;
DROP PROCEDURE IF EXISTS UpdateAccount_SP;
DROP PROCEDURE IF EXISTS DeleteAccountByID_SP;
DROP PROCEDURE IF EXISTS UpdateConfigByAdmin_SP;
DROP PROCEDURE IF EXISTS UpdateConfigByUser_SP;

delimiter //

/*Este procedimento auténtica y registra en bítacora utilizando un binary para que haga match con la cadena(password, account) incluyendo mayúsculas y minuscalas*/
CREATE PROCEDURE Auth_SP (IN username TEXT,IN accPassword TEXT, OUT userID INT)
       BEGIN
         SELECT Account.id INTO userID FROM Account
         WHERE (BINARY Account.txt_name = HEX(AES_ENCRYPT(username, 'root')) ) AND ( BINARY Account.txt_password = HEX(AES_ENCRYPT(accPassword, 'root')) );

         IF userID IS NOT NULL THEN
            INSERT INTO LogBook(accountId, actionId, elementId, txt_elementName, tim_recordDate) VALUES(
                userID,
                4,
                3,
                CONCAT(username,'-AUTHED'),
                NOW()
              );
          COMMIT;

          END IF;


       END//
delimiter ;

delimiter //

/*DROP PROCEDURE GetRole;*/
/*Este procedimiento lo creamos para obtener el role de usario, recibe el y username y password, así obtenemos el role*/
CREATE PROCEDURE GetRole_SP (IN username TEXT,IN accPassword TEXT, OUT typeAcc TEXT)
       BEGIN
         SELECT AES_DECRYPT(UNHEX(Role.txt_roleName), 'root') INTO typeAcc FROM Account JOIN Role ON Account.id_role = Role.id
         WHERE (BINARY Account.txt_name = HEX(AES_ENCRYPT(username, 'root'))) AND (BINARY Account.txt_password = HEX(AES_ENCRYPT(accPassword, 'root'))) ;
       END//

/*Creamos este procedimiento con el fin de obtener un dibujo esto lo hacemos mediante el id y sólo si existe, esto se registrará en la bítacora*/
CREATE PROCEDURE GetDrawingByID_SP (IN drawingID INT, OUT drawing_json JSON)
      BEGIN
        DECLARE drawingName TEXT;
        DECLARE accountID INT;

        SELECT Drawing.jso_file INTO drawing_json FROM Drawing WHERE Drawing.id = drawingID;        

        IF drawing_json IS NOT NULL THEN


          SELECT Drawing.accountId INTO accountID FROM Drawing WHERE id=drawingID;
          SELECT AES_DECRYPT(UNHEX(Drawing.txt_fileName), 'root') INTO drawingName FROM Drawing WHERE id=drawingID;

          INSERT INTO LogBook(accountId, actionId, elementId, txt_elementName, tim_recordDate) VALUES(
                  accountID,
                  1,
                  1,
                  drawingName,
                  NOW()
                );
          COMMIT;

        END IF;
        
      END//

/*Creamos este procedimento con el fin de crear un dibujo nuevo en la base de datos,el usuario que lo realiza es identificado mediante id, esta creción es registrada en la bítacora*/
CREATE PROCEDURE CreateDrawing_SP(IN drawingName TEXT, IN userID INT, IN fileContents JSON, IN blobContents JSON, OUT exist INT)
      BEGIN
        SELECT Drawing.id INTO exist FROM Drawing WHERE (BINARY Drawing.txt_fileName = drawingName) AND (Drawing.accountId = userID);

        IF exist IS NULL THEN
          INSERT INTO BaseA.Drawing (txt_fileName, tim_date, accountId, jso_file) VALUES (
            drawingName,
            NOW(),
            userID,
            fileContents
          );
          
          INSERT INTO BaseB.Drawing (txt_fileName, tim_date, accountId, jso_file) VALUES (
            drawingName,
            NOW(),
            userID,
            blobContents
          );
          
          SELECT Drawing.id INTO exist FROM Drawing WHERE (BINARY Drawing.txt_fileName = HEX(AES_ENCRYPT(drawingName, 'root'))) AND (Drawing.accountId = userID);
          COMMIT;
        ELSE
          SELECT NULL INTO exist;

        END IF;

      END//

CREATE PROCEDURE UpdateDrawingByID_SP(IN drawingID INT, IN jsonFile JSON, IN blobFile JSON)
      BEGIN
        /*Para la base A*/
        UPDATE BaseA.Drawing SET
          BaseA.Drawing.jso_file = jsonFile
        WHERE
          BaseA.Drawing.id = drawingID;

        /*Para la base B*/
        UPDATE BaseB.Drawing SET
          BaseB.Drawing.jso_file = blobFile
        WHERE
          BaseB.Drawing.id = drawingID;

        COMMIT;
        
      END//

/*Creamos este procedimiento para poder borrar el dibujo sí este existe en la base de datos.*/
CREATE PROCEDURE DeleteDrawingByID_SP(IN drawingID INT)
      BEGIN
        DECLARE drawingExists INT;

        SELECT Drawing.id INTO drawingExists FROM Drawing WHERE BINARY drawingID = Drawing.id;
        
        IF drawingExists IS NOT NULL THEN
          DELETE FROM Drawing
          WHERE Drawing.id = drawingID;
          COMMIT;
        END IF;
        
      END//

/*Creamos esté procedimento para poder agregar un usuario nuevo, recibiendo el userName y la password. */
CREATE PROCEDURE AddAccount_SP (IN username TEXT, IN accPassword TEXT, OUT valid INT)
      BEGIN
        SELECT Account.id INTO valid FROM Account WHERE (Account.txt_name = HEX(AES_ENCRYPT(username, 'root')) );

        IF valid IS NULL THEN
          INSERT INTO Account(txt_name, txt_password) 
          VALUES
          (
            username,
            accPassword
          );
          COMMIT;
        END IF;

      END//

/*Creamos este procedimento para poder actualizar los datos del usuario previamente registrado en la base de datos*/
CREATE PROCEDURE UpdateAccount_SP (IN affectedUser INT, IN username TEXT, IN accPassword TEXT, OUT exist INT)
  BEGIN

    SELECT Account.id INTO exist FROM Account WHERE (Account.txt_name = HEX(AES_ENCRYPT(username, 'root')) );

        IF exist IS NULL THEN
          UPDATE Account SET
            txt_name = username,
            txt_password = accPassword
          WHERE id = affectedUser;

          COMMIT;
        END IF;

    COMMIT;
  END//

/*Creamos este procedimento con el fin de borrar un usuario existente en la base de datos*/
CREATE PROCEDURE DeleteAccountByID_SP (IN accountID INT)
      BEGIN
        DECLARE accountExists INT;

        SELECT Account.id INTO accountExists FROM Account WHERE BINARY accountID = Account.id;
        
        IF accountExists IS NOT NULL THEN
          DELETE FROM Account
          WHERE Account.id = accountId;

          COMMIT;
        END IF;    
      END//

/*Creamos este procedimento con el fin de actualizar la configuración(penColor, fillColor, radius, width), cabe mencionar que esta configuración sólo puede ser actualizar por el admin, además estos cambios serán registrados en la bítacora*/
CREATE PROCEDURE UpdateConfigByAdmin_SP (IN affectedUserID INT, IN pencolor TEXT, IN fillcolor TEXT, IN radius TEXT, IN width TEXT)
  BEGIN
    DECLARE userName TEXT;

    UPDATE Config SET
      txt_penColor = pencolor,
      txt_fillColor = fillcolor,
      int_radius = radius,
      int_width = width
    WHERE
      accountID = affectedUserID;

    SELECT Account.txt_name INTO userName FROM Account WHERE (BINARY Account.id = affectedUserID);

    INSERT INTO LogBook (accountId, actionId, elementId, txt_elementName, tim_recordDate) VALUES (
      1,
      2,
      2,
      CONCAT(AES_DECRYPT(UNHEX(username), 'root'), '_configFile'),
      NOW()
    );
    COMMIT;
  END//

/*Creamos este procedimiento con el fin de que el usuario pueda actualizar su información de configuración, estos cambios son registrados en la bítacora*/
CREATE PROCEDURE UpdateConfigByUser_SP (IN affectedUserID INT, IN pencolor TEXT, IN fillcolor TEXT, IN radius TEXT, IN width TEXT)
  BEGIN
    UPDATE Config SET
      txt_penColor = pencolor,
      txt_fillColor = fillcolor,
      int_width = width,
      int_radius = radius
    WHERE
      accountID = affectedUserID;

    INSERT INTO LogBook (accountId, actionId, elementId, tim_recordDate) VALUES (
      affectedUserID,
      2,
      2,
      NOW()
    );
    COMMIT;
  END//

delimiter ; 
/*
Mirar TODOS los Procedimientos almacenados 

SELECT  ROUTINE_CATALOG, ROUTINE_SCHEMA, ROUTINE_NAME, ROUTINE_TYPE  FROM INFORMATION_SCHEMA.ROUTINES
  WHERE ROUTINE_TYPE = 'PROCEDURE';
*/