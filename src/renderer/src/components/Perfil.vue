<template>
  <div class="perfil-container">
    <h1 class="titulo-principal">Perfil</h1>
    <h2 class="subtitulo">Estadísticas Generales</h2>
    <div class="dimensiones">
      <div
        v-for="(dimension, index) in dimensiones"
        :key="dimension.id"
        class="dimension"
        :style="{ borderTopColor: colores[index % colores.length] }"
      >
        <div class="dimension-header">
          <p>{{ dimension.nombre }}</p>
          <p class="puntaje">Puntaje: {{ dimension.puntaje }} PTS</p>
        </div>
        <div class="atributos">
          <ul>
            <li v-for="subatributo in dimension.subatributos" :key="subatributo.id">
              {{ subatributo.nombre }}
            </li>
          </ul>
        </div>
        <div class="composicion-atributos">
          <p><strong>Composición de atributos:</strong></p>
          <ul v-if="dimension.historico && dimension.historico.length">
            <li
              v-for="atributo in dimension.historico"
              :key="atributo.id"
              class="atributo-item"
            >
              <span class="circulo-verde"></span>
              <span class="atributo-nombre">{{ atributo.nombre }}</span>
              <span class="dos-puntos">: </span>&nbsp;
              <span class="atributo-puntaje">{{ atributo.puntaje }} PTS</span>
            </li>
          </ul>
          <p v-else class="sin-atributos">
            No se registran atributos con puntaje adquirido.
          </p>
        </div>
      </div>
    </div>

    <h2 class="subtitulo">Registro de Atributos Adquiridos</h2>
    
    <!-- Contenedor que maneja el scroll y el alto disponible -->
    <div class="tabla-wrapper">
      <table class="tabla-registro">
        <thead>
          <tr>
            <th>Sensor</th>
            <th>Punto de Datos</th>
            <th>Descripción</th>
            <th>Dimensión</th>
            <th>Atributo</th>
            <th>Puntaje</th>
            <th>Fecha de Obtención</th>
          </tr>
        </thead>
        <tbody>
          <!-- Si no hay registros, mostramos un mensaje de "No hay datos" -->
          <tr v-if="!registrosAdquiridos.length">
            <td colspan="7" class="sin-datos">
              No hay datos
            </td>
          </tr>
          <tr v-else v-for="registro in registrosAdquiridos" :key="registro.id">
            <td>{{ registro.sensor }}</td>
            <td>{{ registro.punto_datos }}</td>
            <td>{{ registro.descripcion }}</td>
            <td>{{ registro.dimension }}</td>
            <td>{{ registro.atributo }}</td>
            <td class="puntaje-columna">{{ registro.puntaje }}</td>
            <td>
              <span class="fecha-obtencion">{{ registro.fecha_obtencion }}</span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import profileService from '../services/profileService';
import { getPlayer } from '../services/playerStorage';
import useMonthObtained from '../composables/useMonthObtained';

const dimensiones = ref([]);
const registrosAdquiridos = ref([]);
const colores = ['#3498db', '#27ae60', '#e67e22', '#9b59b6', '#1abc9c'];

const { setMonthObtained } = useMonthObtained();

// Cargar las dimensiones/atributos
const cargarDimensiones = async () => {
  try {
    const player = await getPlayer();
    if (!player) throw new Error('No se encontró un jugador logueado.');

    const playerId = player.id_players;
    const todosAtributos = await profileService.getAllAttributes();
    const atributosJugador = await profileService.getPlayerAllAttributes(playerId);

    const atributosConPuntajes = await Promise.all(
      todosAtributos.map(async (atributo) => {
        const jugadorAtributo = atributosJugador.find(
          (a) => a.id_attributes === atributo.id_attributes
        );
        const subatributos = await profileService.getSubAttributesByAttribute(
          atributo.id_attributes
        );
        const historico = await profileService.getSubattributeTotalScore(
          playerId,
          atributo.id_attributes
        );

        return {
          id: atributo.id_attributes,
          nombre: atributo.name,
          puntaje: jugadorAtributo ? jugadorAtributo.data : 0,
          subatributos,
          historico: historico
            .filter((item) => item.total > 0)
            .map((item) => ({
              id: item.id_subattributes,
              nombre: item.name_subattributes,
              puntaje: item.total,
            })),
        };
      })
    );

    dimensiones.value = atributosConPuntajes;
  } catch (error) {
    console.error('Error al cargar las dimensiones:', error);
  }
};

// Cargar registros adquiridos
const cargarRegistrosAdquiridos = async () => {
  try {
    const player = await getPlayer();
    if (!player) throw new Error('No se encontró un jugador logueado.');

    const playerId = player.id_players;
    const registros = await profileService.getAdquiredSubattributesList(playerId);

    registrosAdquiridos.value = registros.map((registro) => ({
      sensor: registro.name_online_sensor,
      punto_datos: registro.name_sensor_endpoint,
      descripcion: registro.description,
      dimension: registro.name_dimension,
      atributo: registro.name_subattributes,
      puntaje: registro.data,
      fecha_obtencion: new Date(registro.created_time).toLocaleString(),
    }));

    const mesActual = new Date().getMonth();
    const anioActual = new Date().getFullYear();
    const existeRegistroMes = registros.some((registro) => {
      const fechaRegistro = new Date(registro.created_time);
      return (
        registro.name_subattributes === 'Alfabetizacion_Financiera' &&
        fechaRegistro.getMonth() === mesActual &&
        fechaRegistro.getFullYear() === anioActual
      );
    });

    setMonthObtained(existeRegistroMes);
  } catch (error) {
    console.error(
      'Error al cargar el registro de atributos adquiridos:',
      error
    );
  }
};

onMounted(() => {
  cargarDimensiones();
  cargarRegistrosAdquiridos();
});
</script>

<style scoped>
.perfil-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  padding: 20px;
  background-color: #ecf0f1;
  box-sizing: border-box;
}

.titulo-principal {
  font-size: 36px;
  text-align: center;
  color: #2c3e50;
  margin-bottom: 30px;
}

.subtitulo {
  font-size: 24px;
  color: #2c3e50;
  margin-bottom: 20px;
}

.dimensiones {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  gap: 20px;
}

.dimension {
  flex: 1 1 calc(18% - 10px);
  max-width: calc(20% - 10px);
  border-top: 5px solid;
  background-color: #ffffff;
  border-radius: 10px;
  box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
  padding: 15px;
  transition: transform 0.2s ease;
}

.dimension:hover {
  transform: translateY(-5px);
}

.dimension-header {
  font-weight: bold;
  margin-bottom: 10px;
  color: #34495e;
}

.puntaje {
  color: #e67e22;
}

.atributos ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.atributos li {
  font-size: 14px;
  color: #2c3e50;
  margin-bottom: 5px;
}

.composicion-atributos {
  margin-top: 10px;
}

.composicion-atributos p {
  color: #2c3e50;
  font-size: 12px;
}

.atributo-item {
  display: flex;
  align-items: center;
  margin-bottom: 5px;
  font-size: 12px;
}

.circulo-verde {
  width: 6px;
  height: 6px;
  background-color: #27ae60;
  border-radius: 50%;
  margin-right: 8px;
}

.atributo-nombre {
  color: #2c3e50;
  font-weight: bold;
}

.dos-puntos {
  color: #2c3e50;
}

.atributo-puntaje {
  color: #e67e22;
}

.sin-atributos {
  color: #2c3e50;
  text-align: center;
}

.tabla-wrapper {
  flex: 1; 
  overflow-y: auto;
  margin-top: 20px;
  border-radius: 10px;
  box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
  background-color: #ffffff;
}

.tabla-registro {
  width: 100%;
  border-collapse: collapse;
}

.tabla-registro th {
  background-color: #3498db;
  color: #ffffff;
  font-weight: bold;
  border: 1px solid #ddd;
  padding: 8px;
}

.tabla-registro td {
  border: 1px solid #ddd;
  text-align: left;
  padding: 8px;
  color: #2c3e50;
}

.tabla-registro tr:nth-child(even) {
  background-color: #f9f9f9;
}

.tabla-registro tr:hover {
  background-color: #f1f1f1;
}

.puntaje-columna {
  color: #e67e22;
  font-weight: bold;
}

.fecha-obtencion {
  display: inline-block;
  padding: 4px 8px;
  background-color: #27ae60;
  color: #ffffff;
  border-radius: 12px;
  font-size: 14px;
  text-align: center;
}

.sin-datos {
  text-align: center;
  vertical-align: middle;
  color: #999;
  font-weight: bold;
  height: 80px;
}
</style>
