CREATE DATABASE IF NOT EXISTS `Example`;

USE `EXAMPLE`;

CREATE TABLE IF NOT EXISTS `Measure` (
    `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'AutoIncremental.',
    `device` INT(11) NOT NULL COMMENT 'Device Id.',
    `temperature` DECIMAL(10, 4) DEFAULT NULL COMMENT 'Temperature in celcius.', 
    `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date for the temperature',
    PRIMARY KEY (`id`) 
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Measures Historic Table';