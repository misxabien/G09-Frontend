import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Backend URL
  static const String baseUrl = 'https://g09-backend.onrender.com';

  // LOGIN FUNCTION
  static Future<Map<String, dynamic>> login(
      String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'userType': role, // updated to match backend
        }),
      );

      final res = jsonDecode(response.body);

      if (res['status'] == 'success' && res['token'] != null) {
        res['role'] = role; // add role for Flutter usage
      }

      return res;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // FETCH MENU ITEMS
  static Future<List<dynamic>> fetchMenu({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/menu'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // CREATE ACCOUNT
  static Future<Map<String, dynamic>> createAccount(
    String firstName,
    String lastName,
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'userType': role,
        }),
      );

      final res = jsonDecode(response.body);

      if (res['status'] == 'success') {
        return {'success': true, 'message': 'Account created successfully!'};
      } else {
        return {'success': false, 'message': res['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // FETCH ALL ORDERS (Staff only)
  static Future<List<dynamic>> fetchAllOrders({required String token}) async {
    try {
      print('Fetching orders with token: ${token.substring(0, 20)}...');
      final response = await http.get(
        Uri.parse('$baseUrl/api/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Orders API Status Code: ${response.statusCode}');
      print('Orders API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        print('Decoded body keys: ${body.keys}');
        final orders = body['data'] ?? [];  // Changed from 'orders' to 'data'
        print('Number of orders: ${orders.length}');
        return orders;
      } else {
        print('Failed to fetch orders: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }
}
