const { sequelize } = require('../config/db');
const { User, Glasses } = require('../models');

async function resetDatabase() {
  try {
    console.log('Starting database reset...');
    
    // Force sync all models (this will drop all tables and recreate them)
    await sequelize.sync({ force: true });
    console.log('All tables dropped and recreated');
    
    // Create sample glasses data
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
    
    await Glasses.bulkCreate(sampleGlasses);
    console.log(`Created ${sampleGlasses.length} sample glasses records`);
    
    // Create a default admin user
    const adminUser = await User.create({
      username: 'admin',
      email: 'admin@specsinfocus.com',
      password: 'admin123',
      fullName: 'Admin User',
      role: 'admin'
    });
    
    console.log('Created admin user:', adminUser.username);
    
    console.log('Database reset complete!');
    
    // Close connection
    await sequelize.close();
    process.exit(0);
  } catch (error) {
    console.error('Error resetting database:', error);
    process.exit(1);
  }
}

// Execute the reset function
resetDatabase(); 