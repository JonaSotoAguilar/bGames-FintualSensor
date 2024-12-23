# Sensor de Fintual

El **Sensor de Fintual** es un componente desarrollado para evaluar el porcentaje de cumplimiento de las metas de ahorro mensual definidas entre los objetivos del usuario en la plataforma [Fintual](https://fintual.cl). Este sensor se integra en una aplicación que permite asociar, validar y calcular puntos basados en el ahorro del usuario.

## Características

- **Conexión a Fintual**: Los usuarios pueden asociar su cuenta de Fintual mediante su correo electrónico y contraseña.
- **Validación del ahorro**: El sensor verifica las metas de ahorro de los objetivos definidos en Fintual.
- **Obtención de puntos**: Calcula un porcentaje de ahorro mensual y otorga puntos que pueden ser utilizados en la aplicación.
- **Asociación y desasociación**: Los usuarios pueden asociar o desasociar el sensor fácilmente.

## Requisitos

1. **Base de datos**:
   - La base de datos de **bGames** debe estar correctamente configurada. Se proveen scripts de creación y población en la carpeta `db-backups`:
     - **bGames_backup.sql**: Creación y población de la base de datos de bGames con datos de prueba y del sensor.
     - **bGames_FintualSensor_backup.sql**: Población de datos específicos del sensor Fintual.
     - **bGames_WealthQuest_backup.sql**: Población de datos específicos del juego WealthQuest.
     - **db_init_backup.sql**: Creación de la base de datos de bGames con sus tablas.
   - Asegúrate de ejecutar los scripts necesarios según el contexto de tu instalación.

2. **Ejecución del Framework de bGames**:
   - Se provee un archivo `docker-compose.yml` y la estructura requerida en la carpeta `bgames-services` para ejecutar los principales servicios del framework de **bGames**. Esto incluye:
     - **Carpeta `db-init/`**: Debe contener el script `.sql` a ejecutar para crear y poblar la base de datos de bGames automáticamente en el contenedor (bGames_backup.sql).
     - **Carpetas de microservicios**:
       - `get-routes-microservice/`: Código del microservicio para rutas de obtención de datos.
       - `management-routes-microservice/`: Código del microservicio para la gestión de sensores.
       - `online-routes-microservice/`: Código del microservicio para rutas en línea.
       - `post-routes-microservice/`: Código del microservicio para rutas de inserción de datos.
       - `spend-routes-microservice/`: Código del microservicio para manejar los gastos.
       - `standard-routes-microservice/`: Código del microservicio para manejar estándares.
       - `user-routes-microservice/`: Código del microservicio para manejar usuarios.
   - Para iniciar los servicios:
     ```bash
     cd bgames-services
     docker-compose up --build
     ```

3. **Configuración de `urls.js`**:
   - Para que los microservicios `standard-routes-microservice` y `spend-routes-microservice` funcionen correctamente en el entorno Docker, debes modificar el archivo `urls.js` en cada uno de estos microservicios con el siguiente contenido:
     ```javascript
     const postHost = 'post-routes:3002';
     const getHost = 'get-routes:3001';
     const sensorHost = 'management-routes:3007';

     export { postHost, getHost, sensorHost };
     ```

## Instalación

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/tu-repositorio.git
   cd tu-repositorio
