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

  // FETCH MY ORDERS (Students/Faculty)
  static Future<List<dynamic>> fetchMyOrders({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/orders/my-orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching my orders: $e');
      return [];
    }
  }

  // UPDATE ORDER STATUS (Staff only)
  static Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
    required String token,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/orders/$orderId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Failed to update order status',
        };
      }
    } catch (e) {
      print('Error updating order status: $e');
      return {
        'status': 'error',
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  // CREATE ORDER (Manual ordering from cart)
  static Future<Map<String, dynamic>> createOrder({
    required String token,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'items': items,
          'totalAmount': totalAmount,
          'paymentMethod': 'cash', // Payment at pickup
        }),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'status': 'success',
          'order': body['data'] ?? body,
        };
      } else {
        return {
          'status': 'error',
          'message': body['message'] ?? 'Failed to create order',
        };
      }
    } catch (e) {
      print('Error creating order: $e');
      return {
        'status': 'error',
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  // ADD MENU ITEM (Staff only)
  static Future<Map<String, dynamic>> addMenuItem({
    required String name,
    required String description,
    required double price,
    required String category,
    required String imageUrl,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/menu'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'price': price,
          'category': category,
          'imageUrl': imageUrl,
        }),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Item added successfully', 'data': body['data']};
      } else {
        return {'success': false, 'message': body['message'] ?? 'Failed to add item'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // UPDATE MENU ITEM (Staff only)
  static Future<Map<String, dynamic>> updateMenuItem({
    required String menuId,
    required String name,
    required String description,
    required double price,
    required String category,
    required String imageUrl,
    required String token,
  }) async {
    try {
      print('🔄 UPDATE REQUEST - Menu ID: $menuId');
      print('📦 Data: name=$name, price=$price, category=$category');
      
      final response = await http.put(
        Uri.parse('$baseUrl/api/menu/$menuId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'price': price,
          'category': category,
          'imageUrl': imageUrl,
        }),
      );

      print('✅ UPDATE RESPONSE - Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Item updated successfully', 'data': body['data']};
      } else {
        return {'success': false, 'message': body['message'] ?? 'Failed to update item'};
      }
    } catch (e) {
      print('❌ UPDATE ERROR: $e');
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // DELETE MENU ITEM (Staff only)
  static Future<Map<String, dynamic>> deleteMenuItem({
    required String menuId,
    required String token,
  }) async {
    try {
      print('🗑️ DELETE REQUEST - Menu ID: $menuId');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/api/menu/$menuId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('✅ DELETE RESPONSE - Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Item deleted successfully'};
      } else {
        return {'success': false, 'message': body['message'] ?? 'Failed to delete item'};
      }
    } catch (e) {
      print('❌ DELETE ERROR: $e');
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
