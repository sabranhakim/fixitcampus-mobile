import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:fixitcampus_mobile/src/models/user.dart'; // Import the User model
import 'package:jwt_decoder/jwt_decoder.dart'; // Import jwt_decoder

class UserService {
  static const String baseUrl = 'http://10.101.157.163:8081';

  // LOGIN
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode >= 400) {
        return {
          'error': body['error'] ?? 'Login failed',
        };
      }

      return body;
    } on SocketException {
      return {
        'error': 'No internet connection',
      };
    } catch (e) {
      return {
        'error': 'An unexpected error occurred: $e',
      };
    }
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

  // GET ALL USERS
  static Future<List<User>> getAllUsers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'), // Assuming /users endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => User.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode} ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // GET CURRENT USER PROFILE
  static Future<User> getUserProfile(String token) async {
    try {
      // Decode the token to get the user ID
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final int userId = decodedToken['data']['user_id']; // Access 'data' then 'user_id'

      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'), // Use the user ID from the token
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return User.fromJson(body);
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode} ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
