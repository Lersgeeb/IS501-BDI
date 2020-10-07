-- Creación de la base de datos, únicamente si esta no existe.

CREATE DATABASE IF NOT EXISTS GameCatalogue;

-- Se selecciona la base de datos para su uso.
USE GameCatalogue;

-- Se crean las tablas de base de datos.
    CREATE TABLE IF NOT EXISTS Player(
        id INT AUTO_INCREMENT PRIMARY KEY,
        tex_name TEXT NOT NULL,        
        tim_creation TIMESTAMP DEFAULT NOW(),
        cod_state ENUM('active', 'blocked', 'inactive') DEFAULT 'active'
    ) CHARACTER SET utf8;

    CREATE TABLE IF NOT EXISTS Game(
        id INT AUTO_INCREMENT PRIMARY KEY,
        tex_name TEXT NOT NULL
    ) CHARACTER SET utf8;

    CREATE TABLE IF NOT EXISTS GamePlayer(
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_player INT NOT NULL, -- Aplicar la restricción de integridad referencial
        id_game INT NOT NULL, -- Aplicar la restricción de integridad referencial
        tim_lastPlayed TIMESTAMP DEFAULT NOW(),
        cod_state ENUM('on-progress', 'not-played', 'beated') DEFAULT 'not-played'
    ) CHARACTER SET utf8;

/*
USE GameCatalogue;
-- ELliminar Tablas
DROP TABLE Player;
DROP TABLE Game;
DROP TABLE GamePlayer;

-- ELliminar la Base de Datos
DROP DATABASE GameCatalogue;
*/


/*
    Se le pide al estudiante:
        - Crear el diagrama y el modelo ER.
        - Aplicar en SQl las restricciones de integridad de Foreign Key basado en su ER.
        - Aplicar las restricciones de integridad mediante CREATE TABLE y mediante ALTER TABLE.
*/

    ALTER TABLE GamePlayer
    ADD CONSTRAINT PLAYERFK
            FOREIGN KEY (id_player) REFERENCES Player (id)
                ON DELETE RESTRICT ON UPDATE RESTRICT,
    ADD CONSTRAINT GAMEFK
            FOREIGN KEY (id_game) REFERENCES Game (id)
                ON DELETE RESTRICT ON UPDATE RESTRICT;
    
    
/*  
Ver información de las restricciones

USE information_schema
SELECT * FROM TABLE_CONSTRAINTS;
*/

    