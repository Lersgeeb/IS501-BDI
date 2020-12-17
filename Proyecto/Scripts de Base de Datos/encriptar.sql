/*DECLARE @mensaje TEXT;
DECLARE @decrypted TEXT;*/

SELECT HEX(AES_ENCRYPT('hola mundo', 'root')) INTO @mensaje;

SELECT @mensaje;

SELECT AES_DECRYPT(UNHEX(@mensaje), 'root') INTO @decrypted;

SELECT @decrypted;