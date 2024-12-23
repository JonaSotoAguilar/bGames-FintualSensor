import { ipcMain } from 'electron';
import axios from 'axios';

const API_URL = 'http://localhost:3010';

export const setupPlayerServiceHandlers = () => {
    // Manejador de inicio de sesión
    ipcMain.handle('player:login', async (event, { name, password }) => {
    try {
        const url = `${API_URL}/player/${name}/${password}`
        const response = await axios.get(url)
        return response.data
    } catch (error) {
        if (error.response) {
        throw new Error(`Error ${error.response.status}: ${error.response.data.message || 'Error en la API'}`)
        } else if (error.request) {
        throw new Error('No se recibió respuesta del servidor.')
        } else {
        throw new Error(`Error inesperado: ${error.message}`)
        }
    }
    })

    // Manejador para obtener información del jugador
    ipcMain.handle('player:getById', async (event, id) => {
    try {
        const url = `${API_URL}/players/${id}`
        const response = await axios.get(url)
        if (response.data && Array.isArray(response.data) && response.data.length > 0) {
        return response.data[0]
        } else {
        throw new Error('Jugador no encontrado.')
        }
    } catch (error) {
        if (error.response) {
        throw new Error(`Error ${error.response.status}: ${error.response.data.message || 'Error en la API'}`)
        } else if (error.request) {
        throw new Error('No se recibió respuesta del servidor.')
        } else {
        throw new Error(`Error inesperado: ${error.message}`)
        }
    }
    })

    // Manejador para guardar un nuevo jugador
    ipcMain.handle('player:save', async (event, playerData) => {
    try {
        const url = `${API_URL}/player`
        const response = await axios.post(url, playerData)
        return response.data
    } catch (error) {
        if (error.response) {
        throw new Error(`Error ${error.response.status}: ${error.response.data.message || 'Error en la API'}`)
        } else if (error.request) {
        throw new Error('No se recibió respuesta del servidor.')
        } else {
        throw new Error(`Error inesperado: ${error.message}`)
        }
    }
    })

    // Manejador para actualizar un jugador
    ipcMain.handle('player:update', async (event, { id, playerData }) => {
    try {
        const url = `${API_URL}/players/${id}`
        const response = await axios.put(url, playerData)
        return response.data
    } catch (error) {
        if (error.response) {
        throw new Error(`Error ${error.response.status}: ${error.response.data.message || 'Error en la API'}`)
        } else if (error.request) {
        throw new Error('No se recibió respuesta del servidor.')
        } else {
        throw new Error(`Error inesperado: ${error.message}`)
        }
    }
    })
};
