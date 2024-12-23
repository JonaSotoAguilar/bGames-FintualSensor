import { ipcMain } from 'electron';
import axios from 'axios';

const BASE_URL = 'https://fintual.cl/api';

// Crea una instancia de Axios con configuración base
const axiosInstance = axios.create({
  baseURL: BASE_URL,
  headers: {
    'Content-Type': 'application/json', 
    Accept: 'application/json',
  },
  timeout: 10000, 
});

// Interceptores para depuración detallada
axiosInstance.interceptors.request.use(
  (config) => {
    console.log('Solicitud Axios:', config);
    return config;
  },
  (error) => {
    console.error('Error en solicitud Axios:', error);
    return Promise.reject(error);
  }
);

axiosInstance.interceptors.response.use(
  (response) => {
    console.log('Respuesta Axios:', response.data);
    return response;
  },
  (error) => {
    console.error('Error en respuesta Axios:', error.response || error.message);
    return Promise.reject(error);
  }
);

// Configuración de manejadores
export const setupFintualServiceHandlers = () => {
  ipcMain.handle('fintual:getAccessToken', async (event, { email, password }) => {
    try {
      const response = await axiosInstance.post('/access_tokens', {
        user: { email, password },
      });

      const token = response.data?.data?.attributes?.token;

      if (!token) {
        throw new Error('No se pudo obtener el token. La respuesta no contiene un token válido.');
      }

      console.log('Token obtenido:', token);
      return token;
    } catch (error) {
      handleAxiosError(error);
    }
  });

  ipcMain.handle('fintual:getGoals', async (event, { email, token }) => {
    try {
      const response = await axiosInstance.get('/goals', {
        params: {
          user_email: email,
          user_token: token,
        },
      });

      if (!response.data?.data || !Array.isArray(response.data.data)) {
        throw new Error('No se encontraron goals en la respuesta.');
      }

      console.log('Goals obtenidos:', response.data.data);
      return response.data.data;
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
    console.error('Respuesta de error:', {
      status: error.response.status,
      data: error.response.data,
    });
    throw new Error(`Error ${error.response.status}: ${error.response.data?.message || 'Error desconocido.'}`);
  } else if (error.request) {
    console.error('Error de solicitud (sin respuesta):', error.request);
    throw new Error('No se recibió respuesta del servidor. Verifica tu conexión.');
  } else {
    console.error('Error general:', error.message);
    throw new Error('Error en la solicitud. Intenta más tarde.');
  }
};
