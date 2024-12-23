const { ipcRenderer } = require('electron')

const playerService = {
  /**
   * Autenticar un jugador por nombre y contraseña.
   * @param {string} name - Nombre del jugador.
   * @param {string} password - Contraseña del jugador.
   * @returns {Promise<Object>} Datos del jugador autenticado.
   */
  login: async (name, password) => {
    try {
      return await ipcRenderer.invoke('player:login', { name, password })
    } catch (error) {
      console.error('Error en la autenticación:', error.message)
      throw error
    }
  },

  /**
   * Obtener la información de un jugador por su ID.
   * @param {number} id - ID del jugador.
   * @returns {Promise<Object>} Datos del jugador.
   */
  getPlayerById: async (id) => {
    try {
      return await ipcRenderer.invoke('player:getById', id)
    } catch (error) {
      console.error('Error al obtener jugador:', error.message)
      throw error
    }
  },

  /**
   * Guardar un nuevo jugador en la base de datos.
   * @param {Object} playerData - Datos del jugador a guardar.
   * @returns {Promise<Object>} Respuesta del servidor.
   */
  savePlayer: async (playerData) => {
    try {
      return await ipcRenderer.invoke('player:save', playerData)
    } catch (error) {
      console.error('Error al guardar jugador:', error.message)
      throw error
    }
  },

  /**
   * Actualizar los datos de un jugador existente.
   * @param {number} id - ID del jugador a actualizar.
   * @param {Object} playerData - Nuevos datos del jugador.
   * @returns {Promise<Object>} Respuesta del servidor.
   */
  updatePlayer: async (id, playerData) => {
    try {
      return await ipcRenderer.invoke('player:update', { id, playerData })
    } catch (error) {
      console.error('Error al actualizar jugador:', error.message)
      throw error
    }
  }
}

export default playerService
