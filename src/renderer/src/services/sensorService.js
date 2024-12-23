const { ipcRenderer } = require('electron');

const sensorService = {
  /**
   * Obtener todos los sensores disponibles
   */
  getAllSensors: async () => {
    return await ipcRenderer.invoke('sensor:getAllSensors');
  },

  /**
   * Obtener un sensor específico por ID
   */
  getSensorById: async (sensorId) => {
    return await ipcRenderer.invoke('sensor:getSensorById', sensorId);
  },

  /**
   * Obtener endpoints de un sensor específico
   */
  getEndpointsBySensor: async (onlineSensorId) => {
    return await ipcRenderer.invoke('sensor:getEndpointsBySensor', onlineSensorId);
  },

  /**
   * Crear asociación de endpoints de un sensor con un jugador
   */
  createSensorEndpointAssociation: async (playerId, endpointIds, specificParametersArray) => {
    return await ipcRenderer.invoke('sensor:createSensorEndpointAssociation', {
      playerId,
      endpointIds,
      specificParametersArray
    });
  },

  /**
   * Obtener el token de un jugador para un sensor específico
   */
  getToken: async (playerId, onlineSensorId) => {
    // Obtén todos los sensores y sus tokens asociados al jugador
    const tokens = await ipcRenderer.invoke('sensor:getPlayerTokens', playerId);

    // Busca el sensor con el id_online_sensor especificado
    const sensor = tokens.find((token) => token.id_online_sensor === onlineSensorId);

    // Retorna solo el objeto "tokens" si se encuentra, o null si no
    return sensor ? sensor.tokens : null;
  },
  

  /**
   * Guardar token asociado a un sensor para un jugador
   */
  saveToken: async (playerId, sensorId, email, accessToken) => {
    return await ipcRenderer.invoke('sensor:saveToken', { playerId, sensorId, email, accessToken });
  },

  /**
   * Eliminar el token de un jugador para un sensor específico
   */
  deleteToken: async (playerId, sensorId) => {
      return await ipcRenderer.invoke('sensor:deleteToken', { playerId, sensorId });
  },

};

export default sensorService;
