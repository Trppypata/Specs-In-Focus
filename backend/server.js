const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const http = require('http');
const { Client } = require('pg');  // Add direct pg client import

// Load environment variables
dotenv.config();

// Create Express app
const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Root route
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to Specs In Focus API' });
});

// Set port and create server
const PORT = process.env.PORT || 5000;
const ALTERNATIVE_PORTS = [5001, 5002, 5003, 5004];
const server = http.createServer(app);

// Direct connection test using the pg client
const testDirectConnection = async () => {
  const client = new Client({
    user: 'postgres',
    host: 'localhost',
    database: 'specs_in_focus_db',
    password: 'admin123',  // Try lowercase
    port: 5432,
  });

  try {
    await client.connect();
    console.log('Direct connection successful!');
    await client.end();
    return true;
  } catch (err) {
    console.error('Direct connection failed:', err.message);
    
    try {
      // Try alternative credentials
      const client2 = new Client({
        user: 'postgres',
        host: 'localhost',
        database: 'postgres',  // Connect to default postgres database
        password: 'Admin123',  // Try with capital A
        port: 5432,
      });
      
      await client2.connect();
      console.log('Alternative connection successful!');
      await client2.end();
      console.log('Use these credentials in your db.js file');
      return true;
    } catch (err2) {
      console.error('Alternative connection also failed:', err2.message);
      return false;
    }
  }
};

// Initialize database and start server
const startServer = async () => {
  try {
    // Try direct connection first
    console.log('Attempting direct database connection...');
    await testDirectConnection();
    
    // Dynamic imports with error handling
    let models, authRoutes, userRoutes, glassesRoutes, chatbotRoutes;
    
    try {
      models = require('./models');
    } catch (err) {
      console.error('Error loading models:', err);
      console.error('Server startup aborted due to model loading failure');
      return;
    }
    
    // Initialize models
    const dbInitSuccess = await models.initModels();
    if (!dbInitSuccess) {
      console.log('Server startup aborted due to database initialization failure');
      return;
    }
    
    // Load routes with error handling
    try {
      authRoutes = require('./routes/auth');
      userRoutes = require('./routes/users');
      glassesRoutes = require('./routes/glasses');
      chatbotRoutes = require('./routes/chatbot');
      
      // Setup routes
      app.use('/api/auth', authRoutes);
      app.use('/api/users', userRoutes);
      app.use('/api/glasses', glassesRoutes);
      app.use('/api/chatbot', chatbotRoutes);
      
      // Add sample data route for initial setup
      app.get('/api/seed', async (req, res) => {
        try {
          // Create sample glasses data if none exists
          const count = await models.Glasses.count();
          
          if (count === 0) {
            const sampleGlasses = [
              {
                name: 'Eleanor',
                description: 'Round frames perfect for vintage lovers.',
                price: 129.99,
                imageUrls: ['assets/images/eleanor1.png', 'assets/images/eleanor2.png'],
                faceShapeRecommendations: ['oval', 'square'],
                frameStyle: 'Round',
                frameColor: 'Tortoise'
              },
              {
                name: 'Walker',
                description: 'Bold rectangular frames for a strong look.',
                price: 149.99,
                imageUrls: ['assets/images/walker1.png', 'assets/images/walker2.png'],
                faceShapeRecommendations: ['round', 'oval'],
                frameStyle: 'Rectangle',
                frameColor: 'Black'
              },
              {
                name: 'Daria',
                description: 'Lightweight black frame for all occasions.',
                price: 119.99,
                imageUrls: ['assets/images/daria1.png', 'assets/images/daria2.png'],
                faceShapeRecommendations: ['heart', 'diamond'],
                frameStyle: 'Cat Eye',
                frameColor: 'Black'
              },
              {
                name: 'Andy',
                description: 'Modern blue frame with polarized lenses.',
                price: 159.99,
                imageUrls: ['assets/images/andy1.png', 'assets/images/andy2.png'],
                faceShapeRecommendations: ['round', 'heart'],
                frameStyle: 'Rectangle',
                frameColor: 'Blue'
              },
              {
                name: 'Astrid',
                description: 'Classic black frames for any occasion.',
                price: 139.99,
                imageUrls: ['assets/images/astrid1.png', 'assets/images/astrid2.png'],
                faceShapeRecommendations: ['round', 'diamond'],
                frameStyle: 'Square',
                frameColor: 'Black'
              }
            ];
            
            await models.Glasses.bulkCreate(sampleGlasses);
            return res.status(200).json({ message: 'Sample data created successfully', count: sampleGlasses.length });
          }
          
          return res.status(200).json({ message: 'Data already exists', count });
        } catch (error) {
          console.error('Error seeding data:', error);
          return res.status(500).json({ message: 'Failed to seed data', error: error.message });
        }
      });
      
    } catch (err) {
      console.error('Error loading routes:', err);
      console.log('Starting server with limited functionality');
    }
    
    // Start server with port fallback handling
    const startWithPort = (port) => {
      server.listen(port);
      console.log(`Server attempting to run on port ${port}`);
    };
    
    server.on('error', (error) => {
      if (error.code === 'EADDRINUSE') {
        const currentPort = server.address()?.port || PORT;
        const portIndex = ALTERNATIVE_PORTS.indexOf(currentPort);
        
        if (portIndex < ALTERNATIVE_PORTS.length - 1) {
          // Try next port in the list
          const nextPort = ALTERNATIVE_PORTS[portIndex + 1];
          console.log(`Port ${currentPort} is already in use, trying ${nextPort}...`);
          server.close();
          startWithPort(nextPort);
        } else {
          console.error('All alternative ports are in use. Please free up a port or configure a different port in .env');
        }
      } else {
        console.error('Server error:', error);
      }
    });
    
    server.on('listening', () => {
      const port = server.address().port;
      console.log(`Server running on port ${port}`);
      console.log(`API endpoints available at http://localhost:${port}/api`);
      console.log(`Seed sample data at http://localhost:${port}/api/seed`);
    });
    
    // Start with initial port
    startWithPort(PORT);
  } catch (error) {
    console.error('Failed to start server:', error);
  }
};

// Handle uncaught exceptions
process.on('uncaughtException', (err) => {
  console.error('Uncaught Exception:', err);
  console.log('Server will continue running, but please investigate the error.');
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  console.log('Server will continue running, but please investigate the error.');
});

startServer(); 