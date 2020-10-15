DROP DATABASE IF EXISTS InformationTechnologies;

CREATE DATABASE InformationTechnologies CHARACTER SET utf8;

USE InformationTechnologies;

CREATE TABLE PCInventory(
    id INT AUTO_INCREMENT PRIMARY KEY,
    tex_name TEXT NOT NULL,
    cod_type ENUM('Laptop', 'Desktop', 'Tablet') NOT NULL DEFAULT 'Laptop',
    sma_ram SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    sma_ssd SMALLINT UNSIGNED NOT NULL DEFAULT 0
);

INSERT INTO PCInventory(tex_name, sma_ram, sma_ssd) VALUES
    ("HP P1020", 4, 32),
    ("HP P1021", 8, 32),
    ("HP P1022", 16, 64),
    ("HP P1023", 32, 512),
    ("Dell XPS 12", 32, 512),
    ("Dell XPS 17 1", 16, 2048),
    ("Dell XPS 17 2", 64, 2048),
    ("Dell XPS 17 3", 16, 128),
    ("Dell XPS 17 4", 128, 256),
    ("Dell XPS 17 5", 128, 32),
    ("Dell XPS 17 6", 128, 256),
    ("Asus PD2020", 8, 64),
    ("Acer W28", 8, 128),
    ("Acer W29", 8, 256)
;

-- Listar todos los computadores del inventario
SELECT tex_name AS "Marca", sma_ram AS "RAM", sma_ssd AS "SSD" FROM PCInventory;

-- Listar todos los computadores que tiene 16 o 64 GB de RAM
SELECT tex_name AS "Marca", sma_ram AS "RAM", sma_ssd AS "SSD" FROM PCInventory WHERE sma_ram IN (16, 64); 

-- Listar todos los computadores queson de tipo XPS dentro del nombre de "marca".
SELECT tex_name AS "Marca", sma_ram AS "RAM", sma_ssd AS "SSD" FROM PCInventory WHERE tex_name LIKE "%XPS%";

-- Cuántos computadores hay por cantidad de RAM
SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram;

-- Cuántos computadores hay por cantidad de RAM, mostrando solo los grupos donde hay dos o más dispositivos.
SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram HAVING COUNT(*)>=2;

-- Cuántos computadores hay por cantidad de RAM, mostrando solo 3 registro de los grupos donde hay 2 o más dispositivos.
SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram HAVING COUNT(*)>=2 LIMIT 3;

--  Cuántos computadores hay por cantidad de RAM, mostrando solo 3 registro de los grupos donde hay o más dispositivos, ordenados de mayor a menor.
SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram HAVING COUNT(*)>=2 ORDER BY "Cantidad" DESC LIMIT 3;

-- Cuántos computadores hay por cantidad de RAM, mostrando solo 3 registro de los grupos que cuentan con mas ram, ordenados de mayor a menor
SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram HAVING COUNT(*)>=2 ORDER BY sma_ram DESC LIMIT 3;

-- Liste las computadoras que pertenecen a los 3 grupos mayores de RAM. Si una computadora pertenece a la 4ta mayor agrupacion de RAM , dicha computadora no debe aparecer en la  bisqueda.
SELECT * FROM PCInventory;

SELECT sma_ram FROM PCInventory GROUP BY sma_ram ORDER BY sma_ram DESC LIMIT 3;

SELECT * FROM PCInventory INNER JOIN (SELECT sma_ram FROM PCInventory GROUP BY sma_ram ORDER BY sma_ram DESC LIMIT 3) AS PCGroupRAM ON PCInventory.sma_ram = PCGroupRAM.sma_ram;

/*En clase*/
SELECT tex_name FROM PCInventory JOIN (SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram HAVING COUNT(*)>=2 ORDER BY sma_ram DESC LIMIT 3) PCGroup ON PCInventory.sma_ram = PCGroup.`RAM`;

SELECT * FROM PCInventory JOIN (SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram HAVING COUNT(*)>=2 ORDER BY sma_ram DESC LIMIT 3) PCGroup ON PCInventory.sma_ram = PCGroup.`RAM`;

SELECT * FROM PCInventory LEFT JOIN (SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram HAVING COUNT(*)>=2 ORDER BY sma_ram DESC LIMIT 3) PCGroup ON PCInventory.sma_ram = PCGroup.`RAM`;

-- De las computadoras anteriores que pertenecen a los 3 grupos mayores de Ram, se desea ver de que marca son. De forma anticipada. usted como empleado de la empresa, sabe que la marca de la computadora siempre es "la primer palabra" en el nombre del inventario.
SELECT DISTINCT SUBSTRING_INDEX(tex_name, ' ', 1) FROM (SELECT tex_name FROM PCInventory JOIN (SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram HAVING COUNT(*)>=2 ORDER BY sma_ram DESC LIMIT 3) PCGroup ON PCInventory.sma_ram = PCGroup.`RAM`) AS PCGroupNoBigRam;

SELECT DISTINCT SUBSTRING_INDEX(tex_name, ' ', 1) FROM PCInventory;

-- Todas las computadoras en inventario que no pertenecen a las marcas de los 3 grupos mas grandes de RAM. 
SELECT DISTINCT SUBSTRING_INDEX(tex_name, ' ', 1) AS "Marca Respuesta 1" FROM PCInventory WHERE SUBSTRING_INDEX(tex_name, ' ', 1) NOT IN (SELECT DISTINCT SUBSTRING_INDEX(tex_name, ' ', 1) FROM (SELECT tex_name FROM PCInventory JOIN (SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram HAVING COUNT(*)>=2 ORDER BY sma_ram DESC LIMIT 3) PCGroup ON PCInventory.sma_ram = PCGroup.`RAM`) AS PCGroupNoBigRam);

-- Todas las computadoras en inventario que no pertenecen a las marcas de los 3 grupos mas grandes de RAM. No use el operador IN. en su lugar aplique JOIN para verificar la existecia en las listas.

SELECT GroupNoBigRam.`Marca1` AS "Marca Respuesta 2" FROM (SELECT DISTINCT SUBSTRING_INDEX(tex_name, ' ', 1) AS "Marca1" FROM PCInventory) AS GroupNoBigRam LEFT JOIN (SELECT DISTINCT SUBSTRING_INDEX(tex_name, ' ', 1) AS "Marca2" FROM (SELECT tex_name FROM PCInventory JOIN (SELECT sma_ram AS "RAM", COUNT(*) AS "Cantidad" FROM PCInventory GROUP BY sma_ram HAVING COUNT(*)>=2 ORDER BY sma_ram DESC LIMIT 3) PCGroup ON PCInventory.sma_ram = PCGroup.`RAM`) AS PCGroupNoBigRam) AS GroupBigRam ON GroupNoBigRam.`Marca1` = GroupBigRam.`Marca2` WHERE GroupBigRam.`Marca2` IS NULL;