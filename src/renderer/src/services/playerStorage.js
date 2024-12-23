const { ipcRenderer } = window.electron

// Guardar jugador
export const savePlayer = async (player) => {
  try {
    const result = await ipcRenderer.invoke('save-player', player)
    return result
  } catch (error) {
    console.error('Error al guardar el jugador:', error)
    throw error
  }
}

// Obtener jugador
export const getPlayer = async () => {
  try {
    const player = await ipcRenderer.invoke('get-player')
    return player // Devuelve null si no hay datos
  } catch (error) {
    console.error('Error al obtener el jugador:', error)
    throw error
  }
}

// Eliminar jugador
export const deletePlayer = async () => {
  try {
    const result = await ipcRenderer.invoke('delete-player')
    return result
  } catch (error) {
    console.error('Error al eliminar el jugador:', error)
    throw error
  }
}
