USE bgames;
-- 1. Insertar el videojuego WealthQuest
INSERT INTO videogame (
        name,
        genre,
        engine,
        developer,
        publisher,
        version,
        description
    )
VALUES (
        'WealthQuest',
        'Serious game',
        'Unity',
        'Jonathan Soto',
        'none',
        '1.0',
        'Juego educativo de finanzas personales'
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
        'Permite al jugador obtener un intento extra para responder.',
        '1',
        NOW(),
        NOW()
    );
-- 3. Relacionar WealthQuest con la mecánica "more attempts" en modifiable_mechanic_videogames
INSERT INTO modifiable_mechanic_videogame (id_modifiable_mechanic, id_videogame, options)
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
        id_attributes
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