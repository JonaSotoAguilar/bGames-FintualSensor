import { contextBridge, ipcRenderer } from 'electron';
import { electronAPI } from '@electron-toolkit/preload';

// Custom APIs for renderer
const api = {
  // SQLite API
  sqliteAPI: {
    savePlayer: (player) => ipcRenderer.invoke('save-player', player),
    getPlayer: () => ipcRenderer.invoke('get-player'),
    deletePlayer: () => ipcRenderer.invoke('delete-player')
  },
  // Standard Service API
  standardAPI: {
    registerAcquiredPoints: (payload) => ipcRenderer.invoke('standard:registerAcquiredPoints', payload)
  },
  // Player Service API
  playerAPI: {
    login: (name, password) => ipcRenderer.invoke('player:login', { name, password }),
    getPlayerById: (id) => ipcRenderer.invoke('player:getById', id),
    savePlayer: (playerData) => ipcRenderer.invoke('player:save', playerData),
    updatePlayer: (id, playerData) => ipcRenderer.invoke('player:update', { id, playerData })
  },
  // Fintual Service API
  fintualAPI: {
    getAccessToken: (email, password) => ipcRenderer.invoke('fintual:getAccessToken', { email, password }),
    getGoals: (email, token) => ipcRenderer.invoke('fintual:getGoals', { email, token }),
    getSavingsPercentage: (email, token) => ipcRenderer.invoke('fintual:getSavingsPercentage', { email, token })
  },
   // Profile Service API
  profileAPI: {
    getAllAttributes: () => ipcRenderer.invoke('profile:getAllAttributes'),
    getPlayerAllAttributes: (playerId) => ipcRenderer.invoke('profile:getPlayerAllAttributes', playerId),
    getSubAttributesByAttribute: (attributeId) => ipcRenderer.invoke('profile:getSubAttributesByAttribute', attributeId),
    getAdquiredSubattributesList: (playerId) => ipcRenderer.invoke('profile:getAdquiredSubattributesList', playerId),
    getSubattributeTotalScore: (playerId, attributeId) =>
      ipcRenderer.invoke('profile:getSubattributeTotalScore', { playerId, attributeId })
  },
  // Sensor Service API
  sensorAPI: {
    getAllSensors: () => ipcRenderer.invoke('sensor:getAllSensors'),
    getSensorById: (sensorId) => ipcRenderer.invoke('sensor:getSensorById', sensorId),
    getEndpointsBySensor: (onlineSensorId) => ipcRenderer.invoke('sensor:getEndpointsBySensor', onlineSensorId),
    createSensorEndpointAssociation: (playerId, endpointIds, specificParametersArray) =>
      ipcRenderer.invoke('sensor:createSensorEndpointAssociation', { playerId, endpointIds, specificParametersArray }),
    saveToken: (playerId, sensorId, email, accessToken) =>
      ipcRenderer.invoke('sensor:saveToken', { playerId, sensorId, email, accessToken })
  }
};

// Exponer APIs de Electron y personalizadas al Renderer
if (process.contextIsolated) {
  try {
    contextBridge.exposeInMainWorld('electron', electronAPI); // Exponer electronAPI
    contextBridge.exposeInMainWorld('api', {
      sqliteAPI: api.sqliteAPI,
      standardAPI: api.standardAPI,
      playerAPI: api.playerAPI,
      fintualAPI: api.fintualAPI,
      profileAPI: api.profileAPI,
      sensorAPI: api.sensorAPI
    });
  } catch (error) {
    console.error('Error al exponer APIs:', error);
  }
} else {
  // Para entornos sin context isolation
  window.electron = electronAPI;
  window.api = {
    sqliteAPI: api.sqliteAPI,
    standardAPI: api.standardAPI,
    playerAPI: api.playerAPI,
    fintualAPI: api.fintualAPI,
    profileAPI: api.profileAPI,
    sensorAPI: api.sensorAPI
  };
}
