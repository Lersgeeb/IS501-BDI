/*Sí la base de datos existe la borramos para no tener problemas con la inserción de datos.*/
DROP DATABASE IF EXISTS BaseA;

/*Creamos la base de datos con la que vamos a trabajar*/
CREATE DATABASE BaseA CHARACTER SET utf8;

/*Seleccionamos la Base de Datos antes creada para poder manipular los datos mediante consultas.*/
USE BaseA;

DROP TABLE IF EXISTS Role;

/*Borramos la table Account en caso de que exista, para no tener errores en la inserción de datos.*/
DROP TABLE IF EXISTS Account;

/*Borramos la tabla Config en caso de que exista*/
DROP TABLE IF EXISTS Config;

/*Borramos la tabla Drawing en caso de que exista*/
DROP TABLE IF EXISTS Drawing;

DROP TABLE IF EXISTS Action;

DROP TABLE IF EXISTS Element;

/*Borramos la tabla LogBook en caso de que exista*/
DROP TABLE IF EXISTS LogBook;

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
   jso_file JSON,
   CONSTRAINT fk_owner_Id FOREIGN KEY (accountId) REFERENCES Account(id) ON DELETE CASCADE
)COMMENT = "Se llena cuando el usuario crea y guarda los dibujos";

/*Creamos está tabla para poder identificar cada acción que realizan los 
usarios, por ejemplo, moficar o crear un dibujo.*/
CREATE TABLE Action(
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    txt_actionName CHAR(15) NOT NULL
)COMMENT = "Se llena mediante un trigger ";

/*Insertamos valores en la tabla Action, estos nos indicarán que 
acción realizo el usuario cuando este dibujando.*/
INSERT INTO Action ( txt_actionName ) VALUES
    ("VIZUALIZACION"),
    ("MODIFICACION"),
    ("ELIMINACION"),
    ("AUTENTICACION"),
    ("CREACION")
;

/*Creamos esta tabla para poder saber el tipo de elemento que realizo el usuario*/
CREATE TABLE Element(
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    txt_elementType CHAR(15) NOT NULL

)COMMENT = "Se llena cuando el usuario, inicia sesión, identificando";

/*Insertamos valores en la Tabla (Element) esta nos indicará*/
INSERT INTO Element ( txt_elementType ) VALUES
    ("DIBUJO"),
    ("CONFIGURACION"),
    ("USUARIO")
;

/*Creamos esta tabla (LogBook) que es nuestra bitácora con el fin de registrar todas 
las acciones que ha realizado el usario, desde el momento que inicio sesión, su 
configuración y la fecha actual en la que creo o modifico un dibujo.*/
CREATE TABLE LogBook(
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    tim_recordDate TIMESTAMP NOT NULL,
    accountId INT NOT NULL,
    actionId INT NOT NULL,
    elementId INT NOT NULL,
    txt_elementName TEXT NOT NULL DEFAULT 'N/A',
    CONSTRAINT fk_account_id FOREIGN KEY (accountId) REFERENCES Account(id) ON DELETE CASCADE,
    CONSTRAINT fk_actionId FOREIGN KEY (actionId) REFERENCES Action(id) ON DELETE CASCADE,
    CONSTRAINT fk_id_elementId FOREIGN KEY (elementId) REFERENCES Element(id) ON DELETE CASCADE
)COMMENT = "Se llena mediante triggers, registrando todo acerca de los usuarios que iniciaron sesión";


