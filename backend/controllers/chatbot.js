const { Glasses } = require('../models');
const { Sequelize } = require('sequelize');

// Process a chatbot message and return appropriate response
exports.processMessage = async (req, res) => {
  try {
    const { message, userContext } = req.body;
    
    if (!message) {
      return res.status(400).json({
        success: false,
        message: 'Message is required'
      });
    }
    
    const lowerMessage = message.toLowerCase();
    let response = {};
    
    // Check for face shape related queries
    if (lowerMessage.includes('face shape') || 
        lowerMessage.includes('which frames') || 
        lowerMessage.includes('recommend') ||
        lowerMessage.includes('best for me')) {
      
      response = await handleFaceShapeQuery(lowerMessage, userContext);
    }
    // Check for specific frame style queries
    else if (lowerMessage.includes('frame style') || 
             lowerMessage.includes('frame color') || 
             lowerMessage.includes('round frames') ||
             lowerMessage.includes('square frames') ||
             lowerMessage.includes('aviator') ||
             lowerMessage.includes('rectangular')) {
      
      response = await handleFrameStyleQuery(lowerMessage);
    }
    // Check for specific brand or model queries
    else if (lowerMessage.includes('brand') || 
             lowerMessage.includes('model') || 
             lowerMessage.includes('price')) {
      
      response = await handleBrandModelQuery(lowerMessage);
    }
    // Handle greeting or general queries
    else {
      response = handleGeneralQuery(lowerMessage);
    }
    
    return res.status(200).json({
      success: true,
      data: response
    });
    
  } catch (error) {
    console.error('Error processing chatbot message:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to process message',
      error: error.message
    });
  }
};

// Get face shape recommendations
async function handleFaceShapeQuery(message, userContext) {
  let faceShape = extractFaceShape(message);
  
  // If user previously mentioned their face shape, use that
  if (!faceShape && userContext && userContext.faceShape) {
    faceShape = userContext.faceShape;
  }
  
  if (faceShape) {
    try {
      // Get glasses that match this face shape
      const glasses = await Glasses.findAll({
        where: {
          faceShapeRecommendations: {
            [Sequelize.Op.contains]: [faceShape]
          }
        },
        limit: 4
      });
      
      if (glasses.length > 0) {
        const glassesNames = glasses.map(g => g.name).join(', ');
        
        return {
          message: `For ${faceShape} face shapes, I recommend these frames: ${glassesNames}. Would you like to see any of these?`,
          options: glasses.map(g => g.name),
          faceShape: faceShape,
          glasses: glasses.map(g => ({
            id: g.id,
            name: g.name,
            imageUrl: g.imageUrls[0] || null
          }))
        };
      } else {
        return {
          message: `I don't have specific recommendations for ${faceShape} face shapes at the moment. Can you tell me what style of frames you prefer?`,
          options: ['Round', 'Square', 'Rectangular', 'Aviator', 'Cat Eye'],
          faceShape: faceShape
        };
      }
    } catch (error) {
      console.error('Error fetching face shape recommendations:', error);
      return {
        message: "I'm having trouble finding recommendations right now. Can you tell me what style of frames you're interested in?",
        options: ['Round', 'Square', 'Rectangular', 'Aviator', 'Cat Eye']
      };
    }
  } else {
    // If no face shape detected, ask the user
    return {
      message: "To give you the best recommendations, I need to know your face shape. What's your face shape?",
      options: ['Oval', 'Round', 'Square', 'Heart', 'Diamond']
    };
  }
}

// Get frame style recommendations
async function handleFrameStyleQuery(message) {
  let frameStyle = null;
  
  // Extract frame style from message
  if (message.includes('round')) frameStyle = 'Round';
  else if (message.includes('square')) frameStyle = 'Square';
  else if (message.includes('rectangular')) frameStyle = 'Rectangle';
  else if (message.includes('aviator')) frameStyle = 'Aviator';
  else if (message.includes('cat eye')) frameStyle = 'Cat Eye';
  
  if (frameStyle) {
    try {
      // Get glasses that match this style
      const glasses = await Glasses.findAll({
        where: {
          frameStyle: frameStyle
        },
        limit: 4
      });
      
      if (glasses.length > 0) {
        const glassesNames = glasses.map(g => g.name).join(', ');
        
        return {
          message: `Here are some ${frameStyle} frames you might like: ${glassesNames}. Would you like to view any of these?`,
          options: glasses.map(g => g.name),
          frameStyle: frameStyle,
          glasses: glasses.map(g => ({
            id: g.id,
            name: g.name,
            imageUrl: g.imageUrls[0] || null
          }))
        };
      } else {
        return {
          message: `I don't have any ${frameStyle} frames in stock at the moment. Would you like to see other frame styles?`,
          options: ['Yes, show me other styles', 'No, thanks']
        };
      }
    } catch (error) {
      console.error('Error fetching frame style recommendations:', error);
      return {
        message: "I'm having trouble finding that frame style right now. Can you tell me what face shape you have instead?",
        options: ['Oval', 'Round', 'Square', 'Heart', 'Diamond']
      };
    }
  } else {
    // If no specific style mentioned, ask what style they want
    return {
      message: "What frame style are you interested in?",
      options: ['Round', 'Square', 'Rectangular', 'Aviator', 'Cat Eye']
    };
  }
}

// Handle brand/model/price queries
async function handleBrandModelQuery(message) {
  // For now, provide a general response
  return {
    message: "We have a wide range of designer and affordable frames. Our prices range from $99 to $299. Which price range are you interested in?",
    options: ['Budget ($99-$149)', 'Mid-range ($150-$199)', 'Premium ($200+)']
  };
}

// Handle general queries
function handleGeneralQuery(message) {
  // Check for greetings
  if (message.includes('hi') || 
      message.includes('hello') || 
      message.includes('hey') ||
      message.includes('greetings')) {
    return {
      message: "Hi there! I'm your Specs In Focus virtual assistant. How can I help you find the perfect frames today?",
      options: [
        "What frames suit my face shape?", 
        "Show me popular styles", 
        "Help me find frames by price"
      ]
    };
  }
  
  // Check for thank you
  if (message.includes('thank') || message.includes('thanks')) {
    return {
      message: "You're welcome! Is there anything else I can help you with?",
      options: ["Yes", "No, that's all"]
    };
  }
  
  // Default response
  return {
    message: "I'm here to help you find the perfect glasses. Would you like recommendations based on your face shape, or are you looking for a specific style?",
    options: [
      "Recommendations by face shape", 
      "Browse by style", 
      "Find glasses by price"
    ]
  };
}

// Helper function to extract face shape from message
function extractFaceShape(message) {
  const faceShapes = ['oval', 'round', 'square', 'heart', 'diamond'];
  
  for (const shape of faceShapes) {
    if (message.includes(shape)) {
      return shape;
    }
  }
  
  return null;
} 