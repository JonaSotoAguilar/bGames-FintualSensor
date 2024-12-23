<template>
  <div class="navbar">
    <div class="navbar-logo">
      <img src="@renderer/assets/logo.png" alt="Logo" class="logo" />
    </div>

    <div class="navbar-user">
      <span v-if="isLoggedIn" class="user-name">{{ userName }}</span>
    </div>

    <div class="navbar-buttons">
      <template v-if="isLoggedIn">
        <button @click="$emit('navigate', 'perfil')">Perfil</button>
        <button @click="$emit('navigate', 'sensores')">Sensores</button>
        <button @click="$emit('logout')">Logout</button>
      </template>
      <button v-else @click="$emit('navigate', 'login')">Login</button>
    </div>
  </div>
</template>

<script setup>
defineProps({
  isLoggedIn: {
    type: Boolean,
    required: true,
  },
  userName: {
    type: String,
    default: '', // Nombre del usuario logueado
  },
});
</script>

<style scoped>
.navbar {
  display: flex;
  justify-content: space-between; /* Distribuye los elementos: logo, usuario y botones */
  align-items: center;
  height: 80px; /* Altura fija del navbar */
  background-color: #e67e22;
  padding: 0 20px;
  box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.2);
}

/* Contenedor del logo */
.navbar-logo {
  display: flex;
  height: 100%; /* Ocupa toda la altura del navbar */
  align-items: flex-end; /* Alinea el contenido al fondo */
}

.logo {
  height: 100%; /* El logo usa todo el alto del contenedor */
  max-height: 50px; /* Tamaño máximo del logo */
  margin-right: 10px;
  object-fit: contain; /* Ajusta la imagen sin desbordar */
}

/* Contenedor del nombre del usuario */
.navbar-user {
  flex: 1; /* Ocupa espacio disponible */
  display: flex;
  align-items: center; /* Centra verticalmente el nombre */
}

.user-name {
  color: #ffffff;
  font-size: 18px;
  font-weight: bold;
}

/* Contenedor de los botones */
.navbar-buttons {
  display: flex;
  gap: 10px; /* Espacio entre botones */
}

.navbar-buttons button {
  padding: 8px 12px;
  background-color: #ffffff;
  border: 2px solid #d35400;
  color: #e67e22;
  font-weight: bold;
  border-radius: 5px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.navbar-buttons button:hover {
  background-color: #ecf0f1;
  color: #d35400;
}

</style>
