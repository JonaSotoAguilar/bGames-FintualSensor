<template>
  <div class="login-container">
    <h2>Iniciar Sesión</h2>
    <form @submit.prevent="onLogin">
      <!-- Campo para el nombre -->
      <div class="form-group">
        <label for="name">Nombre</label>
        <input
          id="name"
          type="text"
          v-model="name"
          placeholder="Ingresa tu nombre"
          required
        />
      </div>
      <!-- Campo para la contraseña -->
      <div class="form-group">
        <label for="password">Contraseña</label>
        <input
          id="password"
          type="password"
          v-model="password"
          placeholder="Ingresa tu contraseña"
          required
        />
      </div>
      <!-- Botón para iniciar sesión -->
      <button type="submit" :disabled="loading">
        {{ loading ? 'Cargando...' : 'Iniciar Sesión' }}
      </button>
    </form>
    <!-- Mensaje de error -->
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import playerService from '../services/playerService';
import { savePlayer } from '../services/playerStorage';

const name = ref('');
const password = ref('');
const loading = ref(false);
const errorMessage = ref('');

// Emitir evento al login exitoso
const emit = defineEmits(['loginSuccess']);

const onLogin = async () => {
  loading.value = true;
  errorMessage.value = '';
  try {
    // 1. Autenticación: Obtener ID del usuario
    const playerId = await playerService.login(name.value, password.value);
    console.log('ID del jugador:', playerId);

    // 2. Obtener datos completos del usuario con el ID
    const playerData = await playerService.getPlayerById(playerId);
    console.log('Datos completos del jugador:', playerData);

    // 3. Guardar datos en playerStorage
    await savePlayer(playerData);
    console.log('Jugador guardado en playerStorage');

    // Emitir evento al padre con los datos completos
    emit('loginSuccess', playerData);

    alert('Inicio de sesión exitoso');
  } catch (error) {
    if (error.response) {
      // Error del servidor con respuesta HTTP (status, data)
      errorMessage.value = `Error ${error.response.status}: ${error.response.data.message || 'Fallo en la API'}`;
    } else if (error.request) {
      // Sin respuesta del servidor
      errorMessage.value = 'No se recibió respuesta del servidor. Verifica la conexión.';
    } else {
      // Otro error (configuración, errores inesperados)
      errorMessage.value = `Error inesperado: ${error.message}`;
    }
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.login-container {
  width: 100%;
  max-width: 400px;
  margin: 50px auto;
  padding: 20px;
  background-color: #ffffff;
  border: 1px solid #ddd;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  text-align: center;
}

h2 {
  margin-bottom: 20px;
  color: #e67e22;
}

.form-group {
  margin-bottom: 15px;
  text-align: left;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  color: #333;
}

input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-sizing: border-box;
}

button {
  width: 100%;
  padding: 10px;
  background-color: #e67e22;
  color: #fff;
  border: none;
  border-radius: 5px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.3s;
}

button[disabled] {
  background-color: #f3b97f;
  cursor: not-allowed;
}

button:hover {
  background-color: #d35400;
}

.error {
  color: red;
  margin-top: 10px;
}
</style>
