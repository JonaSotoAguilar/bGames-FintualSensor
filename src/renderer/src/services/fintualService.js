const { ipcRenderer } = require('electron');
const dayjs = require('dayjs');

const fintualService = {
  /**
   * Obtener un token de acceso de Fintual.
   * @param {string} email - Email del usuario.
   * @param {string} password - Contraseña del usuario.
   * @returns {Promise<string>} - Token de acceso.
   */
  getAccessToken: async (email, password) => {
    return await ipcRenderer.invoke('fintual:getAccessToken', { email, password });
  },

  /**
   * Obtener los goals del usuario.
   * @param {string} email - Email del usuario.
   * @param {string} token - Token de acceso.
   * @returns {Promise<Array>} - Lista de goals.
   */
  getGoals: async (email, token) => {
    return await ipcRenderer.invoke('fintual:getGoals', { email, token });
  },

  /**
   * Calcular el porcentaje de ahorro con base en los objetivos.
   * @param {string} email - Email del usuario.
   * @param {string} token - Token de acceso.
   * @returns {Promise<number>} - Porcentaje de ahorro.
   */
  getSavingsPercentage: async (email, token) => {
    try {
      const goals = await fintualService.getGoals(email, token);

      let totalGoalSavings = 0;
      let totalDeposited = 0;

      // Calcular la meta de ahorro y  total depositado de entre todos los goals (objetivos).
      goals.forEach((goal) => {
        const attributes = goal.attributes;

        if (!attributes) return;

        const monthlyDeposit = attributes.monthly_deposit || 0;
        if (monthlyDeposit === 0) return;

        const createdAt = dayjs(attributes.created_at);
        const currentDate = dayjs();

        const monthsElapsed = currentDate.diff(createdAt, 'month');
        const goalSavings = monthsElapsed * monthlyDeposit;
        const deposited = attributes.not_net_deposited - (attributes.withdrawn || 0);

        totalGoalSavings += goalSavings;
        totalDeposited += deposited;
      });

      if (totalGoalSavings === 0) return 0;

      const percentage = totalDeposited / totalGoalSavings;

      return percentage > 1 ? 1 : percentage;
    } catch (error) {
      console.error(`Error al calcular el porcentaje de ahorro: ${error.message}`);
      throw error;
    }
  },
};

export default fintualService;
