<template>
  <div class="app-container">
    <!-- Navbar superior -->
    <Navbar
      @navigate="navigate"
      :isLoggedIn="isLoggedIn"
      :userName="userName"
      @logout="handleLogout"
    />
    <!-- Contenido principal -->
    <div class="main-content">
      <Perfil v-if="currentView === 'perfil'" />
      <Sensores v-else-if="currentView === 'sensores'" />
      <Login
        v-else-if="currentView === 'login'"
        @loginSuccess="handleLoginSuccess"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import Navbar from './components/Navbar.vue';
import Perfil from './components/Perfil.vue';
import Sensores from './components/Sensores.vue'; // Importar la vista de Sensores
import Login from './components/Login.vue';
import { getPlayer, deletePlayer } from './services/playerStorage';

const currentView = ref('login');
const isLoggedIn = ref(false);
const userName = ref('');

const navigate = (view) => {
  currentView.value = view;
};

const handleLoginSuccess = (playerData) => {
  userName.value = playerData.name;
  isLoggedIn.value = true;
  currentView.value = 'perfil';
};

const handleLogout = async () => {
  await deletePlayer();
  isLoggedIn.value = false;
  userName.value = '';
  currentView.value = 'login';
};

onMounted(async () => {
  const player = await getPlayer();
  if (player) {
    userName.value = player.name;
    isLoggedIn.value = true;
    currentView.value = 'perfil';
  }
});
</script>

<style scoped>
.app-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  width: 100vw;
  margin: 0;
}

.main-content {
  flex: 1;
  width: 100%;
  background-color: #ecf0f1;
  padding: 20px;
  box-sizing: border-box;
}
</style>
