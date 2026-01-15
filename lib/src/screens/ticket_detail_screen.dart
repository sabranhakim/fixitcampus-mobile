import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fixitcampus_mobile/src/models/ticket.dart';
import 'package:fixitcampus_mobile/src/services/ticket_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;
  final String token;

  const TicketDetailScreen(
      {Key? key, required this.ticketId, required this.token})
      : super(key: key);

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final TicketService _ticketService = TicketService();
  Ticket? _ticket;
  String? _error;
  bool _isLoading = true;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _userRole = _getRoleFromToken();
    _fetchTicket();
  }

  String? _getRoleFromToken() {
    try {
      final decodedToken = JwtDecoder.decode(widget.token);
      return decodedToken['data']['role'];
    } catch (e) {
      log('Error decoding token: $e');
      return null;
    }
  }

  Future<void> _fetchTicket() async {
    setState(() {
      _isLoading = true;
    });
    log('Fetching ticket with id: ${widget.ticketId}');
    log('Token: ${widget.token}');
    try {
      final result =
          await TicketService.getTicket(widget.ticketId, widget.token);
      setState(() {
        _ticket = result;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      log('Error fetching ticket: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(String status) async {
    try {
      await _ticketService.updateTicketStatus(
          widget.ticketId, status, widget.token);
      await _fetchTicket();
    } catch (e) {
      log('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  void _showStatusUpdateDialog() {
    String selectedStatus = _ticket?.status ?? 'open';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: DropdownButton<String>(
            value: selectedStatus,
            items: ['open', 'in_progress', 'closed']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                selectedStatus = value;
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _updateStatus(selectedStatus);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
        actions: [
          if (_userRole == 'admin')
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _showStatusUpdateDialog,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTicket,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title: ${_ticket!.title}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('Description: ${_ticket!.description}'),
                        SizedBox(height: 10),
                        Text('Status: ${_ticket!.status}'),
                        SizedBox(height: 10),
                        Text('Created At: ${_ticket!.createdAt}'),
                      ],
                    ),
                  ),
      ),
    );
  }
}