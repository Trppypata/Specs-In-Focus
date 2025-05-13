const express = require('express');
const router = express.Router();
const chatbotController = require('../controllers/chatbot');

// Process a chatbot message
router.post('/message', chatbotController.processMessage);

module.exports = router; 