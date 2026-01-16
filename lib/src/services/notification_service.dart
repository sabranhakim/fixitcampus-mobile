import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/notification.dart';

class NotificationService {
  // Use 10.0.2.2 for Android emulator to connect to host machine's localhost
  // If running on a physical device, replace with your host machine's actual IP address
  static const String baseUrl = 'http://192.168.18.178:8083';

  Future<List<Notification>> getNotifications(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Notification.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
