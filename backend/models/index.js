const { sequelize, testConnection } = require('../config/db');
const User = require('./User');
const Glasses = require('./Glasses');

// Define associations
User.hasMany(sequelize.models.Glasses, { as: 'favoriteGlasses' });

// Initialize models
const initModels = async () => {
  try {
    // First test the connection
    const connectionSuccessful = await testConnection();
    
    if (!connectionSuccessful) {
      console.error('Database connection failed. Please check your credentials.');
      return false;
    }
    
    // Create database if it doesn't exist
    try {
      await sequelize.query('CREATE DATABASE IF NOT EXISTS specs_in_focus_db');
      console.log('Database specs_in_focus_db created or already exists');
    } catch (err) {
      console.log('Note: Could not create database, might already exist');
    }
    
    // Sync all models with database
    await sequelize.sync({ alter: true });
    console.log('Database & tables synced');
    return true;
  } catch (error) {
    console.error('Error syncing database:', error);
    return false;
  }
};

module.exports = {
  sequelize,
  User,
  Glasses,
  initModels
}; 