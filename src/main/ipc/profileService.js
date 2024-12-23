import { ipcMain } from 'electron';
import axios from 'axios';

const API_BASE_URL = 'http://localhost:3001';

export const setupProfileServiceHandlers = () => {
  /**
   * Obtener todos los atributos
   */
  ipcMain.handle('profile:getAllAttributes', async () => {
    try {
      const url = `${API_BASE_URL}/attributes_all`;
      const response = await axios.get(url);
      return response.data;
    } catch (error) {
      handleAxiosError(error);
    }
  });

  /**
   * Obtener todos los atributos de un jugador
   */
  ipcMain.handle('profile:getPlayerAllAttributes', async (event, playerId) => {
    try {
      const url = `${API_BASE_URL}/player_all_attributes/${playerId}`;
      const response = await axios.get(url);
      return response.data;
    } catch (error) {
      handleAxiosError(error);
    }
  });

  /**
   * Obtener subatributos de un atributo
   */
  ipcMain.handle('profile:getSubAttributesByAttribute', async (event, attributeId) => {
    try {
      const url = `${API_BASE_URL}/subattributes_of_attribute/${attributeId}`;
      const response = await axios.get(url);
      return response.data;
    } catch (error) {
      handleAxiosError(error);
    }
  });

  /**
   * Obtener registros de puntos adquiridos
   */
  ipcMain.handle('profile:getAdquiredSubattributesList', async (event, playerId) => {
    try {
      const url = `${API_BASE_URL}/id_player/${playerId}/adquired_subattributes_list`;
      const response = await axios.get(url);
      return response.data;
    } catch (error) {
      handleAxiosError(error);
    }
  });

  /**
   * Obtener puntaje total adquirido por un subatributo
   */
  ipcMain.handle('profile:getSubattributeTotalScore', async (event, { playerId, attributeId }) => {
    try {
      const url = `${API_BASE_URL}/id_player/${playerId}/attributes/${attributeId}/subattributes_levels`;
      const response = await axios.get(url);
      return response.data;
    } catch (error) {
      handleAxiosError(error);
    }
  });
};

/**
 * Manejo de errores comunes de Axios
 */
const handleAxiosError = (error) => {
  if (error.response) {
    const { status, data } = error.response;

    if (status === 404) {
      throw new Error('Recurso no encontrado. Verifica la URL o los parámetros.');
    } else {
      throw new Error(`Error ${status}: ${data?.message || 'Error desconocido.'}`);
    }
  } else {
    throw new Error('Error de red o servidor. Intenta más tarde.');
  }
};
