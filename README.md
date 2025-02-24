# Sensor de Fintual en bGames

El **Sensor de Fintual** es un componente diseñado para evaluar el cumplimiento de metas de ahorro mensual en la plataforma [Fintual](https://fintual.cl). Este sensor se integra en la aplicación **bGames**, permitiendo a los usuarios asociar sus cuentas, validar el cumplimiento de metas y calcular puntos basados en el ahorro.

## Características

- **Conexión a Fintual**: Asociación de cuentas utilizando correo electrónico y contraseña.
- **Validación de Ahorro**: Verificación de metas de ahorro.
- **Otorgamiento de Puntos**: Cálculo de puntos basados en el porcentaje de ahorro mensual.
- **Gestión de Asociación**: Facilidad para asociar o desasociar el sensor.

## Entorno de bGames

### Pre-requisitos

- Docker y Docker Compose instalados en tu sistema.

### Despliegue con Docker Compose

El `docker-compose.yml` necesario para desplegar los principales servicios de bGames está disponible en la sección de **Releases** del repositorio.

### Iniciar los Servicios

Descarga el `docker-compose.yml` desde la sección de Releases del repositorio y sigue estos pasos para levantar los servicios:

```bash
docker-compose up --build
```

### Servicios Incluidos

Los servicios configurados en el `docker-compose.yml` incluyen:

- **API Get (3001)**
- **API Post (3002)**
- **Online Data Capture (3005)**
- **Sensor Management (3007)**
- **Spend Attribute (3008)**
- **Standard Attribute (3009)**
- **User Management (3010)**
- **MySQL (3306)**: Base de datos para bGames, ya poblada para pruebas del Sensor Fintual y el juego WealthQuest.
- **Redis (6379)**: Manejo de sesiones y caché.

### Servicios Opcionales

Puedes agregar los siguientes servicios al `docker-compose.yml` creando y configurando sus respectivas imágenes:

- **Attribute (3003)**
- **Cloud-Desktop (3004)**
- **Sensor User Communication (3006)**
- **Device Data Capture (3011)**
- **Website (8080)**

## Personalización de la Base de Datos

En la sección de Releases, también encontrarás archivos ZIP con diferentes scripts SQL como guía para la población de la base de datos, por si necesitas cambiar la imagen de la base de datos por defecto y personalizarla con datos diferentes.

## Notas Adicionales

### Configuración de Microservicios

Fue necesario ajustar las URLs en los microservicios `standard-routes-microservice` y `spend-routes-microservice` para asegurar la comunicación correcta entre servicios en el entorno Docker. El archivo `urls.js` se  configuro de esta forma:

```javascript
const postHost = 'post-routes:3002';
const getHost = 'get-routes:3001';
const sensorHost = 'management-routes:3007';

export { postHost, getHost, sensorHost };