import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const String baseUrl = 'https://g09-backend.onrender.com';

  // Send message to chatbot
  static Future<Map<String, dynamic>> sendMessage({
    required String message,
    required String token,
    String? sessionId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chatbot/process-order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'message': message,
          'sessionId': sessionId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Failed to send message',
        };
      }
    } catch (e) {
      print('Error sending message: $e');
      return {
        'status': 'error',
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }

  // Get order status
  static Future<Map<String, dynamic>> getOrderStatus({
    required String orderNumber,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/chatbot/order-status/$orderNumber'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Order not found',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}
