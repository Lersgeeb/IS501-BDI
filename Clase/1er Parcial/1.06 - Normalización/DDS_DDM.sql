DROP DATABASE IF EXISTS InformationTechnologies;

CREATE DATABASE InformationTechnologies CHARACTER SET utf8;

USE InformationTechnologies;

CREATE TABLE PCInventory(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_brand INT NOT NULL COMMENT "id de Marca del listado de marcas",
    id_ramConfig INT NOT NULL COMMENT "id de configuración de RAM del listado de configuraciones",
    id_ssdConfig INT NOT NULL COMMENT "id de configuración de SSD del listado de configuraciones",
    id_screenPanelConfig INT NOT NULL COMMENT "id de configuración del panel/pantalla del listado de configuraciones",
    tex_modelName TEXT NOT NULL COMMENT "Detalle del modelo del computador",
    tex_description TEXT NOT NULL COMMENT "Descripción del computador",
    num_amount INT NOT NULL DEFAULT 0 COMMENT "Cantidad de elementos del producto que existen en inventario"
) COMMENT "Inventario de computadores del área de TI";

CREATE TABLE PartBrand(
    id INT AUTO_INCREMENT PRIMARY KEY,
    tex_name TEXT NOT NULL COMMENT "Nombre de la marca"
) COMMENT "Tabla de Marcas o Fabricantes de computadores y sus componentes";

CREATE TABLE PCRamConfiguration(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_brand INT NOT COMMENT "Id de marca del listado de marcas",
    num_amount SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT "Cantidad de RAM en GB",
    num_speed SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT "Velocidad de RAM en GHz"
) COMMENT "Características de la memoria RAM por configuración";

CREATE TABLE PCSSDConfiguration(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_brand INT NOT COMMENT "Id de marca del listado de marcas",
    id_ssdType INT NOT NULL COMMENT "Id del tipo de SSD",
    num_amount SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT "Cantidad de SSD en GB",
    num_speed SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT "Velocidad de SSD en GHz"
) COMMENT "Características de la memoria SSD por configuración";

CREATE TABLE PCSSDConfigurationType(
    id INT AUTO_INCREMENT PRIMARY KEY,
    tex_type VARCHAR(20) NOT NULL COMMENT "Tipo del SSD"
) COMMENT "";

CREATE TABLE PCScreenPanelConfiguratio(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_screenRatio INT NOT NULL COMMENT "Id de Dimensiones de la pantalla",
    id_panelType INT NOT NULL COMMENT "Id del tipo de panel de la pantalla"
) COMMENT "";


CREATE TABLE PcScreenPanelType(
    id INT AUTO_INCREMENT PRIMARY KEY,
    tex_type VARCHAR(20) NOT NULL COMMENT "Tipo de panel"
) COMMENT "";

CREATE TABLE PcScreenPanelRatio(
    id INT AUTO_INCREMENT PRIMARY KEY,
    num_width TINYINT UNSIGNED NOT NULL DEFAULt 1 COMMENT "Anchura de la pantalla",
    num_height  TINYINT UNSIGNED NOT NULL DEFAULt 1 COMMENT "Altura de la pantalla"
) COMMENT "";