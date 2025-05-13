const { Sequelize } = require('sequelize');

// Direct connection to postgres (no dotenv)
const sequelize = new Sequelize('postgres', 'postgres', 'admin123', {
  host: 'localhost',
  port: 5432,
  dialect: 'postgres',
  logging: false
});

// Test the connection
const testConnection = async () => {
  try {
    await sequelize.authenticate();
    console.log('Database connection has been established successfully.');
    return true;
  } catch (error) {
    console.error('Unable to connect to the database:', error);
    return false;
  }
};

module.exports = { 
  sequelize,
  testConnection
}; 