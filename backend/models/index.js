const sequelize = require('../config/db');
const User = require('./User');

// Initialize models
const initModels = async () => {
  try {
    // Sync all models with database
    await sequelize.sync({ alter: true });
    console.log('Database & tables synced');
  } catch (error) {
    console.error('Error syncing database:', error);
  }
};

module.exports = {
  sequelize,
  User,
  initModels
}; 