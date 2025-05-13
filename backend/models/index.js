const { sequelize, testConnection } = require('../config/db');
const User = require('./User');
const Glasses = require('./Glasses');

// Define associations
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
    
    console.log('Attempting to sync models with database...');
    
    // Set force to false to preserve existing data
    // Only use force: true during initial setup or when you want to reset all data
    try {
      // Use alter: true instead of force: true to preserve data when possible
      await sequelize.sync({ alter: true });
      console.log('✅ Database & tables synced successfully');
      
      // Optional: check if we have any users to confirm tables exist
      const userCount = await User.count();
      console.log(`Current user count in database: ${userCount}`);
      
      return true;
    } catch (syncError) {
      console.error('❌ Error during sync:', syncError);
      
      // Try alternative approach if sync fails
      try {
        console.log('Attempting alternative sync approach...');
        await User.sync({ alter: true });
        await Glasses.sync({ alter: true });
        console.log('✅ Tables synced individually');
        return true;
      } catch (altError) {
        console.error('❌ Alternative sync also failed:', altError);
        return false;
      }
    }
  } catch (error) {
    console.error('❌ Error syncing database:', error);
    return false;
  }
};

module.exports = {
  sequelize,
  User,
  Glasses,
  initModels
}; 