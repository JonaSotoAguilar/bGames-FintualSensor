import { ipcMain } from 'electron';
import axios from 'axios';

const API_BASE_URL = 'http://localhost:3007';

export const setupSensorServiceHandlers = () => {
  /**
   * Obtener todos los sensores disponibles
   */
  ipcMain.handle('sensor:getAllSensors', async () => {
    try {
      const url = `${API_BASE_URL}/sensors_all`;
      const response = await axios.get(url);
      return response.data;
    } catch (error) {
      handleAxiosError(error);
    }
  });

  /**
   * Obtener un sensor específico por ID
   */
  ipcMain.handle('sensor:getSensorById', async (event, sensorId) => {
    try {
      const url = `${API_BASE_URL}/sensor/${sensorId}`;
      const response = await axios.get(url);
      return response.data;
    } catch (error) {
      handleAxiosError(error);
    }
  });

  /**
   * Obtener endpoints de un sensor específico
   */
  ipcMain.handle('sensor:getEndpointsBySensor', async (event, onlineSensorId) => {
    try {
      const url = `${API_BASE_URL}/sensor_sensor_endpoints/${onlineSensorId}`;
      const response = await axios.get(url);
      return response.data;
    } catch (error) {
      handleAxiosError(error);
    }
  });

  /**
   * Crear asociación de endpoints de un sensor con un jugador
   */
  ipcMain.handle('sensor:createSensorEndpointAssociation', async (event, { playerId, endpointIds, specificParametersArray }) => {
    try {
      const url = `${API_BASE_URL}/sensor_endpoint_batch/${playerId}`;
      const payload = {
        ids_sensor_endpoint: endpointIds,
        specific_parameter_parameters_array: specificParametersArray
      };
      const response = await axios.post(url, payload);
      return response.data;
    } catch (error) {
      handleAxiosError(error);
    }
  });

  /**
   * Guardar token asociado a un sensor para un jugador
   */
  ipcMain.handle('sensor:saveToken', async (event, { playerId, sensorId, email, accessToken }) => {
    try {
      const url = `${API_BASE_URL}/sensor_relation/${playerId}/${sensorId}`;
      const tokens = { email, access_token: accessToken };
      const response = await axios.post(url, { tokens });
      return response.data;
    } catch (error) {
      handleAxiosError(error);
    }
  });

  ipcMain.handle('sensor:getPlayerTokens', async (event, playerId) => {
  try {
    const url = `${API_BASE_URL}/sensor_player/${playerId}`;
    const response = await axios.get(url);
    return response.data; // Devuelve la lista completa de tokens del jugador
  } catch (error) {
    handleAxiosError(error);
  }
  });

  ipcMain.handle('sensor:deleteToken', async (event, { playerId, sensorId }) => {
    try {
        const url = `${API_BASE_URL}/sensor_relation/${playerId}/${sensorId}`;
        const response = await axios.delete(url);
        return response.data;
    } catch (error) {
        handleAxiosError(error);
    }
  }); 

  /**
   * Manejo de errores de Axios
   */
  const handleAxiosError = (error) => {
    if (error.response) {
      const { status, data } = error.response;
      throw new Error(`Error ${status}: ${data?.message || 'Error desconocido'}`);
    } else {
      throw new Error('Error de red o servidor. Por favor, intenta más tarde.');
    }
  };
};
