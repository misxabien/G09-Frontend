import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../services/chat_service.dart';

class ChatBotWidget extends StatefulWidget {
  final String token;

  const ChatBotWidget({super.key, required this.token});

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> {
  bool isOpen = false;
  List<ChatMessage> messages = [];
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  String? sessionId;
  Map<String, dynamic>? currentOrder;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    messages.add(ChatMessage(
      text: "👋 Hi! I'm your canteen assistant. I can help you order food!\n\nTry saying:\n• \"I want a cheeseburger\"\n• \"Show me the menu\"\n• \"How much is taho?\"",
      isBot: true,
      timestamp: DateTime.now(),
    ));
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final userMessage = messageController.text.trim();
    messageController.clear();

    setState(() {
      messages.add(ChatMessage(
        text: userMessage,
        isBot: false,
        timestamp: DateTime.now(),
      ));
      isLoading = true;
    });

    _scrollToBottom();

    // Send to backend
    final response = await ChatService.sendMessage(
      message: userMessage,
      token: widget.token,
      sessionId: sessionId,
    );

    setState(() {
      isLoading = false;

      if (response['status'] == 'success') {
        // Update session ID
        sessionId = response['sessionId'];

        // Update current order if exists
        if (response['currentOrder'] != null) {
          currentOrder = response['currentOrder'];
          
          // SYNC WITH CART PROVIDER
          // Note: This replaces the local cart with the chatbot's cart to ensure consistency
          final cartProvider = Provider.of<CartProvider>(context, listen: false);
          cartProvider.clear();
          
          final items = currentOrder!['items'] as List;
          for (var item in items) {
            // Backend returns 'menu' as the ID
            cartProvider.addItem(
              item['menu'] ?? item['_id'], // Handle both cases just to be safe
              item['name'],
              (item['price'] as num).toDouble(),
              '', // Placeholder image URL (backend doesn't return it yet)
              item['quantity'] ?? 1,
            );
          }
        } else if (response['state'] == 'initial' || response['message'].toLowerCase().contains('order placed')) {
          currentOrder = null; // Reset if order completed or cancelled
          // Clear local cart when order is completed via chatbot
          final cartProvider = Provider.of<CartProvider>(context, listen: false);
          cartProvider.clear();
        }

        // Add bot response
        messages.add(ChatMessage(
          text: response['message'],
          isBot: true,
          timestamp: DateTime.now(),
          orderInfo: response['order'],
        ));
      } else {
        messages.add(ChatMessage(
          text: response['message'] ?? 'Sorry, something went wrong',
          isBot: true,
          timestamp: DateTime.now(),
        ));
      }
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Chat Window
        if (isOpen)
          Positioned(
            right: 20,
            bottom: 90,
            child: Container(
              width: 350,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0A57A3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.support_agent,
                              color: Color(0xFF0A57A3)),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Canteen Assistant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Online',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => isOpen = false),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Current Order Summary (if exists)
                  if (currentOrder != null)
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shopping_cart,
                                  size: 16, color: Color(0xFF0A57A3)),
                              const SizedBox(width: 8),
                              const Text(
                                'Current Order',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A57A3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...((currentOrder!['items'] as List?) ?? [])
                              .map((item) => Text(
                                    '• ${item['quantity']}x ${item['name']} - ₱${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 12),
                                  ))
                              .toList(),
                          const Divider(),
                          Text(
                            'Total: ₱${currentOrder!['total'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A57A3),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Say "checkout" to confirm order',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Messages
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
                  ),

                  // Loading indicator
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Typing...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Input
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: const Color(0xFF0A57A3),
                          child: IconButton(
                            onPressed: _sendMessage,
                            icon: const Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Floating Button
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: () => setState(() => isOpen = !isOpen),
            backgroundColor: const Color(0xFF0A57A3),
            child: Icon(isOpen ? Icons.close : Icons.chat_bubble,
                color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isBot)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF0A57A3),
              child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isBot
                    ? Colors.grey[200]
                    : const Color(0xFF0A57A3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isBot ? Colors.black : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  if (message.orderInfo != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${message.orderInfo!['orderNumber']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Total: ₱${message.orderInfo!['totalAmount'].toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!message.isBot) const SizedBox(width: 8),
          if (!message.isBot)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF0A57A3),
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isBot;
  final DateTime timestamp;
  final Map<String, dynamic>? orderInfo;

  ChatMessage({
    required this.text,
    required this.isBot,
    required this.timestamp,
    this.orderInfo,
  });
}
