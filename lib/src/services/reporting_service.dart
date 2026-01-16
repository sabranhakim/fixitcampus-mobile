import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/report_summary.dart';

class ReportingService {
  // Use 10.0.2.2 for Android emulator to connect to host machine's localhost
  // If running on a physical device, replace with your host machine's actual IP address
  static const String baseUrl = 'http://192.168.18.178:8084';

  Future<ReportSummary> getSummary(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reports/summary'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return ReportSummary.fromJson(body);
      } else {
        throw Exception('Failed to load report summary');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
