const { Sequelize } = require('sequelize');

// Create a more flexible connection with better parameters and error handling
const sequelize = new Sequelize('postgres', 'postgres', 'admin123', {
  host: 'localhost',
  port: 5432,
  dialect: 'postgres',
  logging: console.log, // Enable logging to debug connection issues
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  },
  retry: {
    max: 5, // maximum retry 5 times
    timeout: 60000 // retry for 60 seconds
  }
});

// Test the connection with more detailed error reporting
const testConnection = async () => {
  try {
    await sequelize.authenticate();
    console.log('✅ Database connection has been established successfully.');
    return true;
  } catch (error) {
    console.error('❌ Unable to connect to the database:', error.message);
    
    if (error.original) {
      console.error('Original error:', error.original.message);
      
      if (error.original.code) {
        // Provide more helpful advice based on error code
        switch (error.original.code) {
          case 'ECONNREFUSED':
            console.error('Make sure PostgreSQL is running on your machine.');
            break;
          case '28P01':
            console.error('Authentication failed. Check your username and password.');
            break;
          case '3D000':
            console.error('Database does not exist. Will attempt to create it.');
            break;
          default:
            console.error(`Error code: ${error.original.code}`);
        }
      }
    }
    
    return false;
  }
};

module.exports = { 
  sequelize,
  testConnection
}; 