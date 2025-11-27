import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace this with your backend URL
  static const String baseUrl = 'http://localhost:5000';

  /// LOGIN FUNCTION
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// FETCH MENU ITEMS
  static Future<List<dynamic>> fetchMenu() async {
    final url = Uri.parse('$baseUrl/menu');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
