const { ipcRenderer } = require('electron')

const standardService = {
  /**
   * Registrar puntos adquiridos por un jugador usando un sensor y un endpoint.
   * @param {number} playerId - ID del jugador.
   * @param {number} sensorEndpointId - ID del endpoint del sensor.
   * @param {Array<number>} dataChanges - Cambios de datos a registrar (e.g., puntajes).
   * @param {Array<Object>} watchParameters - Parámetros observados para el cálculo.
   * @returns {Promise<Object>} Respuesta de la API.
   */
  registerAcquiredPoints: async (playerId, sensorEndpointId, dataChanges, watchParameters) => {
    const payload = {
      id_player: playerId,
      id_sensor_endpoint: sensorEndpointId,
      data_changes: dataChanges,
      watch_parameters: watchParameters
    }
    try {
      const response = await ipcRenderer.invoke('standard:registerAcquiredPoints', payload)
      return response
    } catch (error) {
      console.error('Error al registrar puntos:', error.message)
      throw error
    }
  }
}

export default standardService
