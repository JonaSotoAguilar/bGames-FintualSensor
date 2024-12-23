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
    `type`
    set('1', '2', '3', '4', '5') DEFAULT NULL,
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
-- Crear tabla `playerss_online_sensor`
DROP TABLE IF EXISTS `playerss_online_sensor`;
CREATE TABLE `playerss_online_sensor` (
    `id_players_online_sensor` int NOT NULL AUTO_INCREMENT,
    `id_online_sensor` int NOT NULL,
    `id_players` int NOT NULL,
    `tokens` json DEFAULT NULL,
    `initiated_date` timestamp NULL DEFAULT NULL,
    `last_modified` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id_players_online_sensor`),
    KEY `fk_id_players` (`id_players`),
    KEY `fk_id_online_sensor` (`id_online_sensor`),
    CONSTRAINT `fk_id_players` FOREIGN KEY (`id_players`) REFERENCES `playerss` (`id_players`),
    CONSTRAINT `fk_id_online_sensor` FOREIGN KEY (`id_online_sensor`) REFERENCES `online_sensor` (`id_online_sensor`)
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
-- Población de la base de datos
-- Insertar datos en la tabla `attributes`
INSERT INTO `attributes` (
        name,
        description,
        data_type,
        initiated_date,
        last_modified
    )
VALUES (
        'Social',
        'placeholder',
        'placeholder',
        '2022-04-20 03:14:07',
        '2022-04-20 03:14:07'
    ),
    (
        'Fisica',
        'placeholder',
        'placeholder',
        '2022-04-20 03:14:07',
        '2022-04-20 03:14:07'
    ),
    (
        'Afectivo',
        'placeholder',
        'placeholder',
        '2022-04-20 03:14:07',
        '2022-04-20 03:14:07'
    ),
    (
        'Cognitivo',
        'placeholder',
        'placeholder',
        '2022-04-20 03:14:07',
        '2022-04-20 03:14:07'
    ),
    (
        'Linguistico',
        'placeholder',
        'placeholder',
        '2022-04-20 03:14:07',
        '2022-04-20 03:14:07'
    );
-- Insertar datos en la tabla `conversion`
INSERT INTO `conversion` (
        name,
        description,
        operations,
        initiated_date,
        last_modified
    )
VALUES (
        'conversion',
        'conversion',
        'placeholder',
        '2022-04-20 03:14:07',
        '2022-04-20 03:14:07'
    );
-- Insertar datos en la tabla `modifiable_conversion_attribute`
INSERT INTO `modifiable_conversion_attribute` (
        id_attribute,
        id_conversion,
        id_modifiable_mechanic
    )
VALUES (1, 1, 1),
    (1, 1, 2);
-- Insertar datos en la tabla `modifiable_mechanic`
INSERT INTO `modifiable_mechanic` (
        name,
        description,
        type,
        initiated_date,
        last_modified
    )
VALUES (
        'Bonus Town Size',
        'placeholder',
        '1',
        '2022-04-20 03:14:07',
        '2022-04-20 03:14:07'
    ),
    (
        'Faster Peasants',
        'placeholder',
        '2',
        '2022-04-20 03:14:07',
        '2022-04-20 03:14:07'
    );
-- Insertar datos en la tabla `videogame`
INSERT INTO `videogame` (
        name,
        genre,
        engine,
        developer,
        publisher,
        version,
        description
    )
VALUES (
        'StrategyGame',
        'Strategy',
        'GameMaker',
        'Gerardo Ternero',
        'none',
        '1.0',
        NULL
    ),
    (
        'Minecraft bGames Library',
        'SandBox',
        'Java',
        'GSimken',
        'none',
        '1.19.2',
        NULL
    ),
    (
        'WealthQuest',
        'Serious game',
        'Unity',
        'Jonathan Soto',
        'none',
        '1.0',
        'Juego educativo de finanzas personales'
    );
-- Insertar datos en la tabla `playerss`
INSERT INTO `playerss` (
        name,
        password,
        email,
        age,
        external_type,
        external_id
    )
VALUES ('test', 'asd123', 'test@test.cl', 24, 'none', 0),
    ('user', 'asd123', 'mail@mail.com', 24, 'none', 1),
    ('dev', 'dev', 'dev', 1, 'none', 2);
-- Insertar datos en la tabla `playerss_attributes`
INSERT INTO `playerss_attributes` (id_playerss, id_attributes, data, last_modified)
VALUES (1, 1, 12, '2022-04-20 03:14:07'),
    (2, 1, 1, '2022-04-20 03:14:07'),
    (1, 2, 16, '2022-04-20 03:14:07'),
    (1, 3, 14, '2022-04-20 03:14:07'),
    (2, 4, 29, '2022-04-20 03:14:07');
-- Insertar datos en la tabla `subattributes`
INSERT INTO `subattributes` (
        name,
        description,
        initiated_date,
        last_modified,
        attributes_id_attributes
    )
VALUES (
        'Reconocimiento',
        'placeholder',
        '2022-04-20 03:14:07',
        '2022-04-20 03:14:07',
        1
    );
-- 2. Insertar la mecánica modificable "more attempts" en la tabla modifiable_mechanic
INSERT INTO modifiable_mechanic (
        name,
        description,
        type,
        initiated_date,
        last_modified
    )
VALUES (
        'More attempts',
        'Permite al jugador obtener más intentos en una mecánica específica.',
        '1',
        NOW(),
        NOW()
    );
-- 3. Relacionar WealthQuest con la mecánica "more attempts" en modifiable_mechanic_videogames
INSERT INTO modifiable_mechanic_videogames (id_modifiable_mechanic, id_videogame, options)
VALUES (
        (
            SELECT id_modifiable_mechanic
            FROM modifiable_mechanic
            WHERE name = 'More attempts'
        ),
        (
            SELECT id_videogame
            FROM videogame
            WHERE name = 'WealthQuest'
        ),
        '{"extra_attempts": true}'
    );
-- 4. Insertar la conversión "ahorro mensual a puntos" en la tabla conversion
INSERT INTO conversion (
        name,
        description,
        operations,
        initiated_date,
        last_modified
    )
VALUES (
        'Intentos adicionales a puntos',
        'Convierte un un intento adicional en puntos',
        'x',
        NOW(),
        NOW()
    );
-- 5. Registrar la relación en modifiable_conversion_attribute
INSERT INTO modifiable_conversion_attribute (
        id_modifiable_mechanic,
        id_conversion,
        id_attribute
    )
VALUES (
        (
            SELECT id_modifiable_mechanic
            FROM modifiable_mechanic
            WHERE name = 'more attempts'
        ),
        (
            SELECT id_conversion
            FROM conversion
            WHERE name = 'Intentos adicionales a puntos'
        ),
        (
            SELECT id_attributes
            FROM attributes
            WHERE name = 'Cognitivo'
        )
    );
INSERT INTO subattributes (
        name,
        description,
        initiated_date,
        last_modified,
        attributes_id_attributes
    )
VALUES (
        'Alfabetizacion_Financiera',
        'Habilidad para entender conceptos financieros básicos.',
        NOW(),
        NOW(),
        (
            SELECT id_attributes
            FROM attributes
            WHERE name = 'Cognitivo'
        )
    );
-- 2. Insertar el sensor online "Fintual"
INSERT INTO online_sensor (
        name,
        description,
        base_url,
        initiated_date,
        last_modified
    )
VALUES (
        'Fintual',
        'Cumplimiento de objetivo mensual de ahorro.',
        'https://fintual.cl/api',
        NOW(),
        NOW()
    );
-- 3. Insertar el endpoint del sensor "/percentage_savings" relacionado con "Fintual"
INSERT INTO sensor_endpoint (
        sensor_endpoint_id_online_sensor,
        name,
        description,
        url_endpoint,
        watch_parameters,
        initiated_date,
        last_modified
    )
VALUES (
        (
            SELECT id_online_sensor
            FROM online_sensor
            WHERE name = 'Fintual'
        ),
        'Porcentaje de ahorro mensual',
        'Calcula los puntos en base al porcentaje de ahorro mensual.',
        '/percentage_savings',
        '["saving_percentage"]',
        -- Parámetro observado
        NOW(),
        NOW()
    );
-- 4. Insertar la conversión "%Ahorro mensual a puntos"
INSERT INTO conversion (
        name,
        description,
        operations,
        initiated_date,
        last_modified
    )
VALUES (
        '%Ahorro mensual a puntos',
        'Convierte el porcentaje de ahorro mensual en puntos (formula lineal de 5 a 25).',
        'round(x * 20 + 5)',
        -- Fórmula para calcular los puntos (redondeado hacia abajo)
        NOW(),
        NOW()
    );
-- 5. Relacionar el subatributo "Alfabetización Financiera" y la conversión "%Ahorro mensual a puntos" con el nuevo endpoint del sensor
INSERT INTO subattributes_conversion_sensor_endpoint (
        id_subattributes,
        id_sensor_endpoint,
        id_conversion,
        parameters_watched
    )
VALUES (
        (
            SELECT id_subattributes
            FROM subattributes
            WHERE name = 'Alfabetizacion_Financiera'
        ),
        (
            SELECT id_sensor_endpoint
            FROM sensor_endpoint
            WHERE url_endpoint = '/percentage_savings'
        ),
        (
            SELECT id_conversion
            FROM conversion
            WHERE name = '%Ahorro mensual a puntos'
        ),
        '["saving_percentage"]'
    );