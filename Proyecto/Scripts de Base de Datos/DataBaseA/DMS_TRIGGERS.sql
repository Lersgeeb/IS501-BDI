USE BaseA;

/*Eliminamos los triggers en caso de que existan y así sucesivamente para cada triggers*/
DROP TRIGGER IF EXISTS drawingCreated_trigger;
DROP TRIGGER IF EXISTS drawingModified_trigger;
DROP TRIGGER IF EXISTS drawingDeleted_trigger;
DROP TRIGGER IF EXISTS encryptDrawing_trigger;
DROP TRIGGER IF EXISTS encryptAccount_trigger;
DROP TRIGGER IF EXISTS encryptAccountUpdate_trigger;
DROP TRIGGER IF EXISTS encryptDrawingUpdate_trigger;
DROP TRIGGER IF EXISTS encryptConfingUpdate_trigger;
DROP TRIGGER IF EXISTS accountCreated_trigger;
DROP TRIGGER IF EXISTS accountModified_trigger;
DROP TRIGGER IF EXISTS accountDeleted_trigger;


delimiter $$
/*Creamos este Trigger para que después que se inserte en la tabla Drawing, registrar cuando un usuario crea 
un dibujo nuevo, de esa forma poder insertar en la tabla LogBook(Bitácora) el id del usuario que creo el dibujo 
así poder identificarlo y además asignándole la fecha y hora actual de creación. */

CREATE TRIGGER drawingCreated_trigger 
    AFTER INSERT 
    ON Drawing FOR EACH ROW
        BEGIN 
            INSERT INTO LogBook (accountId,actionId, elementId, txt_elementName, tim_recordDate) VALUES 
                (
                    NEW.accountId,
                    5,
                    1,
                    AES_DECRYPT(UNHEX(NEW.txt_fileName), 'root'),
                    NOW()
                );
        END$$

/*delimiter ;        
/*Después que se actualicé, en este caso modiqué un dibujo por el usuario,se guardara en la tabla Drawing dicho cambio, e insertaremos en 
la tabla LogBook(Bitácora) registrando ese cambio, como una modificación. */
/*delimiter $$*/

CREATE TRIGGER drawingModified_trigger
    AFTER UPDATE
    ON Drawing FOR EACH ROW
        BEGIN
            INSERT INTO LogBook (accountId,actionId, elementId, txt_elementName, tim_recordDate) VALUES (
                NEW.accountId,
                2,
                1,
                AES_DECRYPT(UNHEX(NEW.txt_fileName), 'root'),
                NOW()
            );
        END$$

/*Creamos este trigger para poder registrar en la bítacora cuando se elimina un dibujo*/
CREATE TRIGGER drawingDeleted_trigger
    BEFORE DELETE
    ON Drawing FOR EACH ROW
        BEGIN
            INSERT INTO LogBook (accountId,actionId, elementId, txt_elementName, tim_recordDate) VALUES (
                1,
                3,
                1,
                AES_DECRYPT(UNHEX(OLD.txt_fileName), 'root'),
                NOW()
            );

            DELETE FROM BaseB.Drawing WHERE BaseB.Drawing.id = OLD.id;
        END$$

CREATE TRIGGER encryptDrawing_trigger
    BEFORE INSERT
    ON Drawing FOR EACH ROW
        BEGIN
            SET NEW.txt_fileName = HEX(AES_ENCRYPT(NEW.txt_fileName, 'root'));
        END$$

CREATE TRIGGER encryptAccount_trigger
    BEFORE INSERT
    ON Account FOR EACH ROW
        BEGIN
            SET NEW.txt_name = HEX(AES_ENCRYPT(NEW.txt_name, 'root'));
            SET NEW.txt_password = HEX(AES_ENCRYPT(NEW.txt_password, 'root'));
        END$$

CREATE TRIGGER encryptAccountUpdate_trigger
    BEFORE UPDATE
    ON Account FOR EACH ROW
        BEGIN
            SET NEW.txt_name = HEX(AES_ENCRYPT(NEW.txt_name, 'root'));
            SET NEW.txt_password = HEX(AES_ENCRYPT(NEW.txt_password, 'root'));

            UPDATE BaseB.Account SET
                BaseB.Account.txt_name = NEW.txt_name,
                BaseB.Account.txt_password = NEW.txt_password
            WHERE
                BaseB.Account.id = NEW.id;
        END$$


CREATE TRIGGER encryptConfingUpdate_trigger
    BEFORE UPDATE
    ON Config FOR EACH ROW
        BEGIN
            SET NEW.txt_penColor = HEX(AES_ENCRYPT(NEW.txt_penColor, 'root'));
            SET NEW.txt_fillColor = HEX(AES_ENCRYPT(NEW.txt_fillColor, 'root'));
            SET NEW.int_width = HEX(AES_ENCRYPT(NEW.int_width, 'root'));
            SET NEW.int_radius = HEX(AES_ENCRYPT(NEW.int_radius, 'root'));

            UPDATE BaseB.Config SET
                BaseB.Config.txt_penColor = NEW.txt_penColor,
                BaseB.Config.txt_fillColor = NEW.txt_fillColor,
                BaseB.Config.int_width = NEW.int_width,
                BaseB.Config.int_radius = NEW.int_radius
            WHERE
                BaseB.Config.accountId = NEW.accountId;
        END$$
/*delimiter ;
/*Este Trigger lo definimos para que después de que se inserte en Account, registre ciertos 
atributos que hemos definido en la tabla LogBook(Bitácora) para así llevar un registro de algunas acciones del usuario*/
/*delimiter $$*/

CREATE TRIGGER accountCreated_trigger
    AFTER INSERT
    ON Account FOR EACH ROW
        BEGIN
           INSERT INTO BaseB.Account SELECT * FROM BaseA.Account WHERE BaseA.Account.id = NEW.id;

            /*Se crea una archivo config para el usuario*/
            INSERT INTO Config (txt_penColor, txt_fillColor,int_width, int_radius, accountId) VALUES(
                HEX(AES_ENCRYPT("#000000", 'root')),
                HEX(AES_ENCRYPT("#000000", 'root')),
                HEX(AES_ENCRYPT("1", 'root')),
                HEX(AES_ENCRYPT("10", 'root')),
                NEW.id
                );
                
            /*Se registra que el usuario se creó por parte del único administrador*/
            INSERT INTO LogBook (accountId, actionId, elementId, txt_elementName, tim_recordDate) VALUES
                (
                    1,
                    5,
                    3,
                    AES_DECRYPT(UNHEX(NEW.txt_name), 'root'),
                    NOW()
                );
        END$$

CREATE TRIGGER accountModified_trigger
    AFTER UPDATE
    ON Account FOR EACH ROW
        BEGIN
            INSERT INTO LogBook (accountId, actionId, elementId, txt_elementName, tim_recordDate) VALUES (
                1,
                2,
                3,
                AES_DECRYPT(UNHEX(NEW.txt_name), 'root'),
                NOW()
            );
        END$$

CREATE TRIGGER accountDeleted_trigger
    BEFORE DELETE
    ON Account FOR EACH ROW
        BEGIN
            INSERT INTO LogBook (accountId,actionId, elementId, txt_elementName, tim_recordDate) VALUES (
                1,
                3,
                3,
                AES_DECRYPT(UNHEX(OLD.txt_name), 'root'),
                NOW()
            );

        DELETE FROM BaseB.Account WHERE OLD.id = BaseB.Account.id;


        END$$

CREATE TRIGGER configCreated_trigger
    AFTER INSERT ON Config
    FOR EACH ROW
    BEGIN
        INSERT INTO BaseB.Config SELECT * FROM BaseA.Config WHERE BaseA.Config.id = NEW.id;
    END$$

delimiter ;
