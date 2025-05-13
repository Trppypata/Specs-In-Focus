import 'package:flutter/material.dart';
import 'package:specs_in_focus/models/glasses_model.dart';
import 'package:specs_in_focus/virtual_try_on_screen.dart';

class Message {
  final String text;
  final bool isUserMessage;
  final List<String>? options;

  Message({
    required this.text,
    required this.isUserMessage,
    this.options,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initial welcome message
    _addBotMessage(
      "Hi! I am Specs. How can I help you today?",
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add(Message(text: text, isUserMessage: true));
    });
    _scrollToBottom();

    // Process the user input
    _processUserMessage(text);
  }

  void _addBotMessage(String text, {List<String>? options}) {
    setState(() {
      _messages.add(Message(
        text: text,
        isUserMessage: false,
        options: options,
      ));
    });
    _scrollToBottom();
  }

  void _processUserMessage(String message) {
    final lowercaseMessage = message.toLowerCase();

    // Check for face shape related questions
    if (lowercaseMessage.contains('face') &&
        (lowercaseMessage.contains('shape') ||
            lowercaseMessage.contains('type'))) {
      _addBotMessage(
        "What frames look best on my face shape?",
        options: ["Oval", "Round", "Square", "Heart", "Diamond"],
      );
    }
    // Check for frame style questions
    else if (lowercaseMessage.contains('frame') ||
        lowercaseMessage.contains('glasses') ||
        lowercaseMessage.contains('style')) {
      _addBotMessage(
        "If you have an oval face, you're lucky because most frame shapes suit you! However, here are the frames that we offer that suit an oval face best:",
        options: ["Eleanor", "Supernova", "Supernatural", "Cecilia"],
      );
    }
    // Handle face shape selection
    else if (lowercaseMessage.contains('oval')) {
      _addBotMessage(
        "If you have an oval face, you're lucky because most frame shapes suit you! However, here are the frames that we offer that suit an oval face best:",
        options: ["Eleanor", "Greta", "River", "Oliver"],
      );
    } else if (lowercaseMessage.contains('round')) {
      _addBotMessage(
        "For round faces, angular frames help add definition. Consider these options:",
        options: ["Walker", "Andy", "Noah", "Astrid"],
      );
    } else if (lowercaseMessage.contains('square')) {
      _addBotMessage(
        "For square faces, round or oval frames can soften angles. Here are some great options:",
        options: ["Eleanor", "Greta", "River", "Oliver"],
      );
    } else if (lowercaseMessage.contains('heart')) {
      _addBotMessage(
        "For heart-shaped faces, frames that balance the width of your forehead work best:",
        options: ["Daria", "Enid", "Noah", "Oliver"],
      );
    } else if (lowercaseMessage.contains('diamond')) {
      _addBotMessage(
        "For diamond-shaped faces, frames that emphasize your eyes and soften your cheekbones work well:",
        options: ["Daria", "Eleanor", "Noah", "River"],
      );
    }
    // Default response
    else {
      _addBotMessage(
        "I'm here to help you find the perfect frames! What's your face shape?",
        options: ["Oval", "Round", "Square", "Heart", "Diamond"],
      );
    }
  }

  void _handleOptionSelected(String option) {
    // First check if it's a glasses name
    Glasses? selectedGlasses;
    for (final glasses in GlassesRepository.getAllGlasses()) {
      if (glasses.name == option) {
        selectedGlasses = glasses;
        break;
      }
    }

    // If it's a glasses option, show try-on button
    if (selectedGlasses != null) {
      setState(() {
        _messages.add(Message(text: option, isUserMessage: true));
        _messages.add(Message(
          text: "Would you like to try on the ${selectedGlasses?.name} frames?",
          isUserMessage: false,
          options: ["Yes, try on", "Show me more options"],
        ));
      });
      _scrollToBottom();
    } else if (option == "Yes, try on") {
      // Find the last selected glasses
      Glasses? lastSelectedGlasses;
      for (int i = _messages.length - 1; i >= 0; i--) {
        if (!_messages[i].isUserMessage) continue;

        for (final glasses in GlassesRepository.getAllGlasses()) {
          if (glasses.name == _messages[i].text) {
            lastSelectedGlasses = glasses;
            break;
          }
        }
        if (lastSelectedGlasses != null) break;
      }

      if (lastSelectedGlasses != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VirtualTryOnScreen(
              selectedGlasses: lastSelectedGlasses,
            ),
          ),
        );
      }
    } else {
      _handleSubmitted(option);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'specs',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'in',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'focus',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (_, int index) {
                Message message = _messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    final isUserMessage = message.isUserMessage;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage) _buildBotAvatar(),
          Flexible(
            child: Column(
              crossAxisAlignment: isUserMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isUserMessage ? Colors.grey[300] : Colors.red,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUserMessage ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                if (message.options != null && message.options!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: message.options!.map((option) {
                        return GestureDetector(
                          onTap: () => _handleOptionSelected(option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Text(option),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
          if (isUserMessage) const SizedBox(width: 8),
          if (isUserMessage)
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/style1.jpg'),
              radius: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(
          Icons.smart_toy,
          color: Colors.white,
        ),
        radius: 20,
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration(
                hintText: 'Write a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}
