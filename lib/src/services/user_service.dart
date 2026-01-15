import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  // LOGIN
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  // REGISTER (ADMIN / USER)
  static Future<Map<String, dynamic>?> register({
    required String name,
    required String email,
    required String password,
    required bool isAdmin,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'role': isAdmin ? 'admin' : 'user',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }
}
