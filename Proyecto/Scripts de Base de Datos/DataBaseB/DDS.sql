/*Sí la base de datos existe la borramos para no tener problemas con la inserción de datos.*/
DROP DATABASE IF EXISTS BaseB;

/*Creamos la base de datos con la que vamos a trabajar*/
CREATE DATABASE BaseB CHARACTER SET utf8;

/*Seleccionamos la Base de Datos antes creada para poder manipular los datos mediante consultas.*/
USE BaseB;

DROP TABLE IF EXISTS Role;

/*Borramos la table Account en caso de que exista, para no tener errores en la inserción de datos.*/
DROP TABLE IF EXISTS Account;

/*Borramos la tabla Config en caso de que exista*/
DROP TABLE IF EXISTS Config;

/*Borramos la tabla Drawing en caso de que exista*/
DROP TABLE IF EXISTS Drawing;

/*Creamos la tabla (Role) para poder asignarle un role a cada usuario que sea ingresado en la tabla Account*/
CREATE TABLE Role(
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    txt_roleName TEXT
)COMMENT = "Se llena mediante un insert, para asignarle un rol a cada usuario existente en la tabla Account";

/*Insertamos los roles correspondientes en la tabla (Role)*/
INSERT INTO Role ( txt_roleName ) VALUES
    ( HEX(AES_ENCRYPT("ADMIN", 'root')) ),
    ( HEX(AES_ENCRYPT("OPERADOR", 'root')) )
;

/*Creamos la tabla (Account) es donde guardaremos la información de cada usuario, como su nombre y 
contraseña, ademas le hemos asignado una llave foranea, que hace referencia a la tabla (Role) de esa forma le podes asignar un role. */
CREATE TABLE Account(
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    txt_name TEXT NOT NULL,
    txt_password TEXT NOT NULL,
    id_role INT NOT NULL DEFAULT 2,
    CONSTRAINT fk_id_role FOREIGN KEY (id_role) REFERENCES Role(id) ON DELETE CASCADE
) COMMENT = "Se llena mediante un insert, debe de existir el usuario para que pueda iniciar sesión";

/*Creamos la tabla (Config) con el fin de poder guardar la configuración de casa usuario que realizara 
dibujos, hemos definido varios atributos que se describen en dicha tabla, además hemos 
definido una llave foranea que hace referencia a la tabla (Account) para poder identificar a 
cada usuario, para así guardar su configuracion correspondiente, */
CREATE TABLE Config(
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    txt_penColor TEXT DEFAULT "#000000",
    txt_fillColor TEXT DEFAULT "#000000",
    int_width TEXT,
    int_radius TEXT,
    accountId INT NOT NULL,
    CONSTRAINT fk_accountId FOREIGN KEY (accountId) REFERENCES Account(id) ON DELETE CASCADE
)COMMENT = "Se llena cuando el usario modifica valores en la interfaz gráfica, estos se guardan en dicha tabla";

/*Creamos la tabla (Drawing) con el fin de cuando un usuario cree un dibujo esta pueda guardar 
el dibujo que realizo el usuario en un formato json, asignandole un nombre de archivo a cada 
dibujo, además tenemos una llave foranea referenciada a la tabla (Account) para poder identificar a cada usuario */
CREATE TABLE Drawing(
   id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
   txt_fileName TEXT,
   tim_date TIMESTAMP NOT NULL,
   accountId INT,
   jso_file BLOB,
   CONSTRAINT fk_owner_Id FOREIGN KEY (accountId) REFERENCES Account(id) ON DELETE CASCADE
)COMMENT = "Se llena cuando el usuario crea y guarda los dibujos";