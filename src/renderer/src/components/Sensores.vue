<template>
  <div class="sensores-container">
    <h1 class="titulo">Sensores</h1>
    <div class="sensores-list">
      <div v-for="sensor in sensores" :key="sensor.id_online_sensor" class="sensor-card">
        <h2 class="sensor-title">{{ sensor.name }}</h2>
        <p>{{ sensor.description }}</p>
        <p v-if="sensor.expired" class="expired-message">Conexión expirada. Vuelva a conectarse</p>

        <!-- Mostrar mensaje de carga mientras se valida el token -->
        <div v-if="sensor.loading" class="loading-message">Validando conexión...</div>

        <!-- Mostrar botones solo si no está en estado de carga -->
        <div class="button-group" v-if="!sensor.loading && sensor.token">
          <button
            class="connect-button disconnect"
            @click="confirmDesassociate(sensor)"
            :disabled="isProcessing"
          >
            Desasociar
          </button>
          <button
            class="connect-button refresh"
            @click="confirmGetMonthlyScore(sensor, sensor.token)"
            :disabled="isProcessing || monthlyScoreObtained"
            :title="monthlyScoreObtained ? 'Ya canjeaste los puntos de este mes, espera al siguiente.' : ''"
          >
            Reclamar puntos
          </button>
        </div>

        <!-- Botón asociar si no tiene token y no está en carga -->
        <button
          v-else-if="!sensor.loading"
          class="connect-button"
          @click="openPopup(sensor)"
          :disabled="isProcessing"
        >
          Asociar
        </button>
      </div>
      <div v-if="sensores.length === 0">No hay sensores disponibles.</div>
    </div>

    <!-- Popup para asociar -->
    <div v-if="isPopupOpen" class="popup-overlay">
      <div class="popup-content">
        <h2 class="popup-title">Instrucción de asociación al sensor Fintual</h2>
        <p class="description">
          El sensor de Fintual evalúa el porcentaje total de cumplimiento de las metas de ahorro mensual
          definidas entre sus objetivos. <br><br>
          El sensor no almacenará información personal ni saldos, solo se utilizará para calcular el porcentaje de ahorro.<br><br>
          *Aquellos objetivos sin un monto de depósito mensual definido no serán considerados en el cálculo 
          del porcentaje de ahorro. Debe tener al menos un objetivo con un monto mensual definido para obtener puntos.*<br>
        </p>
        <form @submit.prevent="associateSensorFintual">
          <p class="step">1) Ingrese su email y contraseña:</p>
          <div class="input-container">
            <label for="email">Email</label>
            <input
              type="email"
              id="email"
              v-model="form.email"
              placeholder="Ingresa tu email"
              required
              :disabled="isProcessing"
            />
          </div>
          <div class="input-container">
            <label for="password">Contraseña</label>
            <input
              type="password"
              id="password"
              v-model="form.password"
              placeholder="Ingresa tu contraseña"
              required
              :disabled="isProcessing"
            />
          </div>
          <p class="description">
            2) Cuando se conecte con éxito, aparecera el botón "Reclamar puntos", 
            el cual al presionarlo calcula el porcentaje ahorrado del mes y le otorga 
            puntos, tras ello el botón se deshabilitará hasta el siguiente mes.
          </p>
          <div class="button-container">
            <button
              type="button"
              class="cancel-button"
              @click="closePopup"
              :disabled="isProcessing"
            >
              Cancelar
            </button>
            <button
              type="submit"
              class="submit-button"
              :disabled="isProcessing"
            >
              Asociar
            </button>
          </div>
        </form>
        <p v-if="token">Token obtenido: {{ token }}</p>
        <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import fintualService from '../services/fintualService';
import sensorService from '../services/sensorService';
import standardService from '../services/standardService';
import { getPlayer } from '../services/playerStorage';
import useMonthObtained from '../composables/useMonthObtained';

const { getMonthObtained, setMonthObtained } = useMonthObtained();

const sensores = ref([]);
const isPopupOpen = ref(false);
const selectedSensor = ref({});
const form = ref({ email: '', password: '' });
const token = ref('');
const errorMessage = ref('');
const monthlyScoreObtained = ref(false);
const isProcessing = ref(false);

const loadSensors = async () => {
  try {
    const player = await getPlayer();
    if (!player) throw new Error('No se encontró un jugador logueado.');

    // Cargar todos los sensores inicialmente
    const sensorsFromAPI = await sensorService.getAllSensors();

    // Mapear los sensores para agregar campos de estado
    sensores.value = sensorsFromAPI.map((sensor) => ({
      ...sensor,
      token: null,
      expired: false,
      loading: sensor.name === 'Fintual', // Mostrar "loading" solo para Fintual
    }));

    // Procesar cada sensor de manera asíncrona
    for (const sensor of sensores.value) {
      const token = await sensorService.getToken(player.id_players, sensor.id_online_sensor);

      if (sensor.name === 'Fintual' && token) {
        try {
          // Verificar si el token de Fintual es válido
          await fintualService.getGoals(token.email, token.access_token);
          sensor.token = token;
        } catch (error) {
          if (error.message.includes('Token inválido')) {
            sensor.expired = true;
            await desassociateSensor(sensor);
          }
        } finally {
          sensor.loading = false; 
        }
      } else {
        // Asignar el token para otros sensores y ocultar el estado de carga
        sensor.token = token;
        sensor.loading = false;
      }
    }

    monthlyScoreObtained.value = getMonthObtained();
  } catch (error) {
    console.error('Error al cargar los sensores:', error);
  }
};

const openPopup = (sensor) => {
  selectedSensor.value = sensor;
  form.value = { email: '', password: '' };
  token.value = '';
  errorMessage.value = '';
  isPopupOpen.value = true;
};

const closePopup = () => {
  isPopupOpen.value = false;
};

const associateSensorFintual = async () => {
  try {
    isProcessing.value = true;
    errorMessage.value = '';

    // Obtener el token de acceso
    const tokenResult = await fintualService.getAccessToken(
      form.value.email,
      form.value.password
    );

    token.value = tokenResult;

    // Obtener al jugador logueado
    const player = await getPlayer();
    if (!player) throw new Error('No se encontró un jugador logueado.');

    // Guardar el token del sensor
    await sensorService.saveToken(
      player.id_players,
      selectedSensor.value.id_online_sensor,
      form.value.email,
      tokenResult
    );

    // Obtener los endpoints del sensor
    const endpoints = await sensorService.getEndpointsBySensor(selectedSensor.value.id_online_sensor);
    if (!endpoints || endpoints.length === 0) {
      throw new Error('No se encontraron endpoints para el sensor seleccionado.');
    }

    // Asociar el endpoint al jugador (tomamos el primer endpoint del array)
    const endpointId = endpoints[0].id_sensor_endpoint;
    await sensorService.createSensorEndpointAssociation(player.id_players, [endpointId], []);

    // Recargar sensores y cerrar el popup
    await loadSensors();
    closePopup();

    // Mensaje de éxito
    alert('Sensor asociado exitosamente.');
  } catch (error) {
    errorMessage.value = `Error: ${error.message}`;
    // Mensaje de error
    alert('Error al asociar el sensor. Intenta nuevamente.');
  } finally {
    isProcessing.value = false;
  }
};

const confirmDesassociate = (sensor) => {
  if (confirm(`¿Estás seguro que deseas desasociar el sensor ${sensor.name}?`)) {
    desassociateSensor(sensor);
  }
};

const desassociateSensor = async (sensor) => {
  try {
    isProcessing.value = true;
    const player = await getPlayer();
    if (!player) throw new Error('No se encontró un jugador logueado.');

    await sensorService.deleteToken(player.id_players, sensor.id_online_sensor);

    alert('Sensor desasociado exitosamente.');

    await loadSensors();
  } catch (error) {
    console.error('Error al desasociar el sensor:', error);
    alert('Error al desasociar el sensor. Intenta nuevamente.');
  } finally {
    isProcessing.value = false;
  }
};

const confirmGetMonthlyScore = (sensor, token) => {
  if (
    confirm(
      '¿Estás seguro de que deseas obtener el puntaje mensual para este sensor?\n\n' +
      'Asegúrate de haber realizado tu ahorro mensual, ya que solo puedes obtener puntos una vez por mes. ' +
      'Después de confirmar, no podrás obtener puntos nuevamente hasta el próximo mes.'
    )
  ) {
    getMonthlyScore(sensor, token);
  }
};

const getMonthlyScore = async (sensor, token) => {
  try {
    isProcessing.value = true;
    const player = await getPlayer();
    if (!player) throw new Error('No se encontró un jugador logueado.');

    const endpoints = await sensorService.getEndpointsBySensor(sensor.id_online_sensor);
    if (endpoints.length === 0) {
      throw new Error(`No se encontró ningún endpoint para el sensor.`);
    }

    const endpointId = endpoints[0].id_sensor_endpoint;

    const { email, access_token } = token;
    if (!access_token) throw new Error('No se encontró un token de acceso para este sensor.');

    const savingsPercentage = await fintualService.getSavingsPercentage(email, access_token);

    if (savingsPercentage === 0) {
      alert('No tienes ningún ahorro registrado este mes. Intenta ahorrar para obtener puntos.');
      return;
    }

    await standardService.registerAcquiredPoints(
      player.id_players,
      endpointId,
      [savingsPercentage],
      [['saving_percentage']]
    );

    alert('¡Puntos adquiridos con éxito!');
    setMonthObtained(true);
    monthlyScoreObtained.value = true;
  } catch (error) {
    console.error('Error al obtener el puntaje mensual:', error.message);
    alert('Fallo al adquirir puntos.');
  } finally {
    isProcessing.value = false;
  }
};

onMounted(() => {
  loadSensors();
});
</script>

<style scoped>
.sensores-container {
  padding: 20px;
  background-color: #ecf0f1;
}

.titulo {
  font-size: 36px;
  color: #2c3e50;
  margin-bottom: 20px;
  text-align: center;
}

.sensores-list {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.sensor-card {
  flex: 1 1 300px;
  max-width: 400px;
  min-width: 300px;
  background-color: #ffffff;
  border-radius: 10px;
  box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
  padding: 20px;
  text-align: center;
  color: #34495e;
}

.sensor-card p {
  margin-bottom: 15px; /* Espacio entre la descripción y los botones */
}

.sensor-title {
  font-size: 24px;
  margin-bottom: 10px;
}

.expired-message {
  color: red;
  font-size: 14px;
  margin-bottom: 10px;
}

.button-group {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}

.connect-button {
  background-color: #27ae60;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.connect-button:disabled {
  background-color: #95a5a6;
  cursor: not-allowed;
}

.connect-button.disconnect {
  background-color: #e74c3c;
}

.connect-button.refresh {
  background-color: #27ae60;
}

.connect-button.refresh:hover {
  background-color: #218c54;
}

.popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.popup-content {
  background: white;
  padding: 20px;
  border-radius: 10px;
  text-align: left;
  box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
  width: 400px;
}

.popup-title {
  font-size: 24px;
  color: #2c3e50;
  margin-bottom: 10px;
  text-align: center;
}

.description {
  font-size: 14px;
  color: #34495e;
  margin-bottom: 20px;
  text-align: justify;
}

.step {
  font-size: 14px;
  color: #34495e;
  margin: 10px 0;
}

.input-container {
  margin-bottom: 10px;
}

.input-container label {
  display: block;
  font-size: 12px;
  color: #34495e;
  margin-bottom: 5px;
}

.input-container input {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 5px;
}

.button-container {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}

.cancel-button {
  background-color: #e74c3c;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  cursor: pointer;
}

.submit-button {
  background-color: #27ae60;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  cursor: pointer;
}

.error-message {
  color: #e74c3c;
  margin-top: 15px;
  font-size: 14px;
}
</style>