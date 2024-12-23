CREATE DATABASE IF NOT EXISTS `bgames`
/*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */
/*!80016 DEFAULT ENCRYPTION='N' */
;

USE `bgames`;

-- Crear tabla `adquired_subattribute`
DROP TABLE IF EXISTS `adquired_subattribute`;
CREATE TABLE `adquired_subattribute` (
  `id_adquired_subattribute` int NOT NULL AUTO_INCREMENT,
  `id_players` int NOT NULL,
  `id_subattributes_conversion_sensor_endpoint` int NOT NULL,
  `data` int DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_adquired_subattribute`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `attributes`
DROP TABLE IF EXISTS `attributes`;
CREATE TABLE `attributes` (
  `id_attributes` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  `data_type` varchar(45) DEFAULT NULL,
  `initiated_date` timestamp NULL DEFAULT NULL,
  `last_modified` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_attributes`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `conversion`
DROP TABLE IF EXISTS `conversion`;
CREATE TABLE `conversion` (
  `id_conversion` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  `operations` varchar(200) DEFAULT NULL,
  `initiated_date` timestamp NULL DEFAULT NULL,
  `last_modified` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_conversion`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `expended_attribute`
DROP TABLE IF EXISTS `expended_attribute`;
CREATE TABLE `expended_attribute` (
  `id_expended_attribute` int NOT NULL AUTO_INCREMENT,
  `id_players` int NOT NULL,
  `id_videogame` int NOT NULL,
  `id_modifiable_conversion_attribute` int NOT NULL,
  `data` int NOT NULL,
  `created_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_expended_attribute`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `modifiable_conversion_attribute`
DROP TABLE IF EXISTS `modifiable_conversion_attribute`;
CREATE TABLE `modifiable_conversion_attribute` (
  `id_modifiable_conversion_attribute` int NOT NULL AUTO_INCREMENT,
  `id_attribute` int NOT NULL,
  `id_conversion` int NOT NULL,
  `id_modifiable_mechanic` int NOT NULL,
  PRIMARY KEY (`id_modifiable_conversion_attribute`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `modifiable_mechanic`
DROP TABLE IF EXISTS `modifiable_mechanic`;
CREATE TABLE `modifiable_mechanic` (
  `id_modifiable_mechanic` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `type` set('1', '2', '3', '4', '5') DEFAULT NULL,
  `initiated_date` timestamp NULL DEFAULT NULL,
  `last_modified` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_modifiable_mechanic`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `modifiable_mechanic_videogames`
DROP TABLE IF EXISTS `modifiable_mechanic_videogames`;
CREATE TABLE `modifiable_mechanic_videogames` (
  `id_modifiable_mechanic_videogame` int NOT NULL AUTO_INCREMENT,
  `id_modifiable_mechanic` int NOT NULL,
  `id_videogame` int NOT NULL,
  `options` json DEFAULT NULL,
  PRIMARY KEY (`id_modifiable_mechanic_videogame`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `online_sensor`
DROP TABLE IF EXISTS `online_sensor`;
CREATE TABLE `online_sensor` (
  `id_online_sensor` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `base_url` varchar(1000) DEFAULT NULL,
  `initiated_date` timestamp NULL DEFAULT NULL,
  `last_modified` timestamp NULL DEFAULT NULL,
  `image` blob,
  PRIMARY KEY (`id_online_sensor`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `playerss`
DROP TABLE IF EXISTS `playerss`;
CREATE TABLE `playerss` (
  `name` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `email` varchar(128) NOT NULL,
  `age` int NOT NULL,
  `external_type` varchar(16) NOT NULL,
  `external_id` int NOT NULL,
  `id_players` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_players`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `player_online_sensor`
DROP TABLE IF EXISTS `player_online_sensor`;
CREATE TABLE `player_online_sensor` (
  `id_players_online_sensor` int NOT NULL AUTO_INCREMENT,
  `id_online_sensor` varchar(45) NOT NULL,
  `id_players` int NOT NULL,
  `tokens` json DEFAULT NULL,
  `initiated_date` timestamp NULL DEFAULT NULL,
  `last_modified` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_players_online_sensor`),
  KEY `fk_id_players` (`id_players`),
  CONSTRAINT `fk_id_players` FOREIGN KEY (`id_players`) REFERENCES `playerss` (`id_players`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `players_sensor_endpoint`
DROP TABLE IF EXISTS `players_sensor_endpoint`;
CREATE TABLE `players_sensor_endpoint` (
  `id_players_sensor_endpoint` int NOT NULL AUTO_INCREMENT,
  `id_players` int NOT NULL,
  `Id_sensor_endpoint` int NOT NULL,
  `specific_parameters` json DEFAULT NULL,
  `activated` tinyint(1) DEFAULT NULL,
  `schedule_time` int DEFAULT NULL,
  PRIMARY KEY (`id_players_sensor_endpoint`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `playerss_attributes`
DROP TABLE IF EXISTS `playerss_attributes`;
CREATE TABLE `playerss_attributes` (
  `id_playerss_attributes` int NOT NULL AUTO_INCREMENT,
  `id_playerss` int NOT NULL,
  `id_attributes` int NOT NULL,
  `data` int DEFAULT NULL,
  `last_modified` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_playerss_attributes`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `sensor_endpoint`
DROP TABLE IF EXISTS `sensor_endpoint`;
CREATE TABLE `sensor_endpoint` (
  `id_sensor_endpoint` int NOT NULL AUTO_INCREMENT,
  `sensor_endpoint_id_online_sensor` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `url_endpoint` varchar(1000) DEFAULT NULL,
  `token_parameters` json DEFAULT NULL,
  `specific_parameters` json DEFAULT NULL,
  `watch_parameters` json DEFAULT NULL,
  `initiated_date` timestamp NULL DEFAULT NULL,
  `last_modified` timestamp NULL DEFAULT NULL,
  `dynamic_url` varchar(1000) DEFAULT NULL,
  `header_parameters` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id_sensor_endpoint`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `subattributes`
DROP TABLE IF EXISTS `subattributes`;
CREATE TABLE `subattributes` (
  `id_subattributes` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  `initiated_date` timestamp NULL DEFAULT NULL,
  `last_modified` timestamp NULL DEFAULT NULL,
  `attributes_id_attributes` int NOT NULL,
  PRIMARY KEY (`id_subattributes`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `subattributes_conversion_sensor_endpoint`
DROP TABLE IF EXISTS `subattributes_conversion_sensor_endpoint`;
CREATE TABLE `subattributes_conversion_sensor_endpoint` (
  `id_subattributes_conversion_sensor_endpoint` int NOT NULL AUTO_INCREMENT,
  `id_subattributes` int NOT NULL,
  `id_sensor_endpoint` int NOT NULL,
  `id_conversion` int NOT NULL,
  `parameters_watched` json DEFAULT NULL,
  PRIMARY KEY (`id_subattributes_conversion_sensor_endpoint`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Crear tabla `videogame`
DROP TABLE IF EXISTS `videogame`;
CREATE TABLE `videogame` (
  `id_videogame` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `genre` varchar(45) DEFAULT NULL,
  `engine` varchar(45) DEFAULT NULL,
  `developer` varchar(128) DEFAULT NULL,
  `publisher` varchar(128) DEFAULT NULL,
  `version` varchar(128) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_videogame`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
