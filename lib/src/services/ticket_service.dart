import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/ticket.dart';

class TicketService {
  // Use 10.0.2.2 for Android emulator to connect to host machine's localhost
  // If running on a physical device, replace with your host machine's actual IP address
  static const String baseUrl = 'http://10.101.157.163:8082';

  // GET ALL TICKETS
  Future<List<Ticket>> getTickets(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tickets'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedBody = jsonDecode(response.body);
        if (decodedBody is List) {
          return decodedBody.map((dynamic item) => Ticket.fromJson(item)).toList();
        } else {
          // If the decoded body is not a list (e.g., null or an empty object), return an empty list
          return [];
        }
      } else {
        throw Exception('Failed to load tickets: ${response.statusCode} ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // GET TICKET BY ID
  static Future<Ticket> getTicket(String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tickets/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return Ticket.fromJson(body);
      } else {
        throw Exception('Failed to load ticket: ${response.statusCode} ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // CREATE TICKET
  Future<Ticket> createTicket(
      String title, String description, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tickets'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return Ticket.fromJson(body);
      } else {
        throw Exception('Failed to create ticket: ${response.statusCode} ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // UPDATE TICKET STATUS
  Future<void> updateTicketStatus(
      String id, String status, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tickets/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update ticket status: ${response.statusCode} ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}