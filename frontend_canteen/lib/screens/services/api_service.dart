import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace this with your backend URL
  static const String baseUrl = 'http://localhost:5000';

  /// LOGIN FUNCTION (for all roles: student, faculty, canteen)
  static Future<Map<String, dynamic>> login(
    String email, String password, String role) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      // Parse the backend response
      final res = jsonDecode(response.body);

      // Optional: attach role to response
      if (res['success'] == true && res['data']?['token'] != null) {
        res['role'] = role;  
      }

      return res;
    } else {
      final res = jsonDecode(response.body);
      return {
        'success': false,
        'message': res['message'] ?? 'Login failed',
      };
    }
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}


  /// FETCH MENU ITEMS
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
      return jsonDecode(response.body);
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

  //create account
  static Future<Map<String, dynamic>> createAccount(
    String firstName,
    String lastName,
    String email,
    String password,
    String role,
  ) async {
    // TODO: replace with your actual API call
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true}; // Mock response
  }
}
