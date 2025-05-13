const express = require('express');
const router = express.Router();
const { 
  getAllUsers,
  getUserById,
  updateUser,
  deleteUser 
} = require('../controllers/userController');
const { protect, admin } = require('../middleware/auth');

// Routes
router.get('/', protect, admin, getAllUsers);
router.get('/:id', protect, getUserById);
router.put('/:id', protect, updateUser);
router.delete('/:id', protect, admin, deleteUser);

module.exports = router; 