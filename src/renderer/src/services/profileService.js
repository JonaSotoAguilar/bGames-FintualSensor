const { ipcRenderer } = require('electron');

const profileService = {
  /**
   * Obtener todos los atributos
   */
  getAllAttributes: async () => {
    return await ipcRenderer.invoke('profile:getAllAttributes');
  },

  /**
   * Obtener todos los atributos de un jugador
   */
  getPlayerAllAttributes: async (playerId) => {
    return await ipcRenderer.invoke('profile:getPlayerAllAttributes', playerId);
  },

  /**
   * Obtener subatributos de un atributo
   */
  getSubAttributesByAttribute: async (attributeId) => {
    return await ipcRenderer.invoke('profile:getSubAttributesByAttribute', attributeId);
  },

  /**
   * Obtener registros de puntos adquiridos
   */
  getAdquiredSubattributesList: async (playerId) => {
    return await ipcRenderer.invoke('profile:getAdquiredSubattributesList', playerId);
  },

  /**
   * Obtener puntaje total adquirido por un subatributo
   */
  getSubattributeTotalScore: async (playerId, attributeId) => {
    return await ipcRenderer.invoke('profile:getSubattributeTotalScore', { playerId, attributeId });
  }
};

export default profileService;
