const { Sequelize } = require('sequelize');
const dotenv = require('dotenv');

dotenv.config();

// Create a connection to the database
const sequelize = new Sequelize(
  process.env.DB_NAME || 'specs_in_focus_db',
  process.env.DB_USER || 'postgres',
  process.env.DB_PASSWORD || 'your_password',
  {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    dialect: 'postgres',
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    },
    logging: false
  }
);

module.exports = sequelize; 