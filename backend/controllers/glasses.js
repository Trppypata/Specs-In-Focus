const { Glasses } = require('../models');
const { Sequelize } = require('sequelize');

// Get all glasses
exports.getAllGlasses = async (req, res) => {
  try {
    const glasses = await Glasses.findAll();
    res.status(200).json(glasses);
  } catch (error) {
    console.error('Error fetching glasses:', error);
    res.status(500).json({ message: 'Failed to fetch glasses', error: error.message });
  }
};

// Get glasses by ID
exports.getGlassesById = async (req, res) => {
  try {
    const glasses = await Glasses.findByPk(req.params.id);
    if (!glasses) {
      return res.status(404).json({ message: 'Glasses not found' });
    }
    res.status(200).json(glasses);
  } catch (error) {
    console.error('Error fetching glasses by ID:', error);
    res.status(500).json({ message: 'Failed to fetch glasses', error: error.message });
  }
};

// Get glasses by face shape
exports.getGlassesByFaceShape = async (req, res) => {
  try {
    const { faceShape } = req.params;
    const glasses = await Glasses.findAll({
      where: {
        faceShapeRecommendations: {
          [Sequelize.Op.contains]: [faceShape]
        }
      }
    });
    res.status(200).json(glasses);
  } catch (error) {
    console.error('Error fetching glasses by face shape:', error);
    res.status(500).json({ message: 'Failed to fetch glasses', error: error.message });
  }
};

// Create glasses
exports.createGlasses = async (req, res) => {
  try {
    const glasses = await Glasses.create(req.body);
    res.status(201).json(glasses);
  } catch (error) {
    console.error('Error creating glasses:', error);
    res.status(500).json({ message: 'Failed to create glasses', error: error.message });
  }
};

// Update glasses
exports.updateGlasses = async (req, res) => {
  try {
    const [updated] = await Glasses.update(req.body, {
      where: { id: req.params.id }
    });
    
    if (updated) {
      const updatedGlasses = await Glasses.findByPk(req.params.id);
      return res.status(200).json(updatedGlasses);
    }
    
    res.status(404).json({ message: 'Glasses not found' });
  } catch (error) {
    console.error('Error updating glasses:', error);
    res.status(500).json({ message: 'Failed to update glasses', error: error.message });
  }
};

// Delete glasses
exports.deleteGlasses = async (req, res) => {
  try {
    const deleted = await Glasses.destroy({
      where: { id: req.params.id }
    });
    
    if (deleted) {
      return res.status(204).send();
    }
    
    res.status(404).json({ message: 'Glasses not found' });
  } catch (error) {
    console.error('Error deleting glasses:', error);
    res.status(500).json({ message: 'Failed to delete glasses', error: error.message });
  }
}; 