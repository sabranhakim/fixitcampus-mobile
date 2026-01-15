import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ticket.dart';
import 'storage_service.dart';

class TicketService {
  final String _baseUrl = 'http://10.0.2.2:8082/tickets';
  final StorageService _storageService = StorageService();

  // ================= GET TICKETS =================
  Future<List<Ticket>> getTickets() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> ticketJson = json.decode(response.body);
      return ticketJson.map((json) => Ticket.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tickets');
    }
  }

  // ================= CREATE TICKET =================
  Future<void> createTicket(String title, String description) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create ticket');
    }
  }
}
