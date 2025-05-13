const express = require('express');
const router = express.Router();
const glassesController = require('../controllers/glasses');

// Get all glasses
router.get('/', glassesController.getAllGlasses);

// Get glasses by face shape - specific route must come before generic ID route
router.get('/face-shape/:faceShape', glassesController.getGlassesByFaceShape);

// Get glasses by ID - generic ID route comes after specific routes
router.get('/:id', glassesController.getGlassesById);

// Create new glasses
router.post('/', glassesController.createGlasses);

// Update glasses
router.put('/:id', glassesController.updateGlasses);

// Delete glasses
router.delete('/:id', glassesController.deleteGlasses);

module.exports = router; 