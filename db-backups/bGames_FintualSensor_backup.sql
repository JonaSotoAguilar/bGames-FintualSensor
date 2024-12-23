USE bgames;
-- 1. Insertar el subatributo "Alfabetización Financiera" relacionado con el atributo "Cognitivo"
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