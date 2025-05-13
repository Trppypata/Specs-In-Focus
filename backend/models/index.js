const { sequelize, testConnection } = require('../config/db');
const User = require('./User');
const Glasses = require('./Glasses');

// Define associations - fix the problem by using the correct model reference
// Remove or correct the problematic association
// User.hasMany(sequelize.models.Glasses, { as: 'favoriteGlasses' });
// Replace with:
User.hasMany(Glasses, { as: 'favoriteGlasses' });

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
    
    // Sync all models with database - use force: true once to rebuild the tables
    try {
      await sequelize.sync({ force: true });
      console.log('Database & tables synced');
      return true;
    } catch (syncError) {
      console.error('Error during sync:', syncError);
      // Try alternative approach if sync fails
      try {
        console.log('Attempting alternative sync approach...');
        await User.sync({ force: true });
        await Glasses.sync({ force: true });
        console.log('Tables synced individually');
        return true;
      } catch (altError) {
        console.error('Alternative sync also failed:', altError);
        return false;
      }
    }
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