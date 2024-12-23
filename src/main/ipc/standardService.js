import { ipcMain } from 'electron';
import axios from 'axios';

const API_URL = 'http://localhost:3009';

export const setupStandardServiceHandlers = () => {
  ipcMain.handle('standard:registerAcquiredPoints', async (event, payload) => {
    try {
      const url = `${ API_URL}/standard_attributes_apis`;
      const response = await axios.post(url, payload);
      return response.data; 
    } catch (error) {
      if (error.response) {
        throw new Error(`Error ${error.response.status}: ${error.response.data.message || 'Error en la API'}`);
      } else if (error.request) {
        throw new Error('No se recibió respuesta del servidor.');
      } else {
        throw new Error(`Error inesperado: ${error.message}`);
      }
    }
  });
};
