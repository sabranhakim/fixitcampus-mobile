import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fixitcampus_mobile/src/models/ticket.dart';
import 'package:fixitcampus_mobile/src/services/ticket_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;
  final String token;

  const TicketDetailScreen({
    super.key,
    required this.ticketId,
    required this.token,
  });

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final TicketService _ticketService = TicketService();
  Ticket? _ticket;
  String? _error;
  bool _isLoading = true;
  String? _userRole;

  static const Color primaryColor = Color(0xFF795548);
  static const Color backgroundColor = Color(0xFFFFF8F2);
  static const Color fieldColor = Color(0xFFF3ECE7);

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
    setState(() => _isLoading = true);
    try {
      final result =
          await TicketService.getTicket(widget.ticketId, widget.token);
      setState(() {
        _ticket = result;
        _error = null;
        _isLoading = false;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update status: $e')),
      );
    }
  }

  void _showStatusUpdateDialog() {
    String selectedStatus = _ticket?.status ?? 'open';

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Update Status',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          content: DropdownButtonFormField<String>(
            value: selectedStatus,
            decoration: InputDecoration(
              filled: true,
              fillColor: fieldColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'open', child: Text('Open')),
              DropdownMenuItem(
                  value: 'in_progress', child: Text('In Progress')),
              DropdownMenuItem(value: 'closed', child: Text('Closed')),
            ],
            onChanged: (value) {
              if (value != null) selectedStatus = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                _updateStatus(selectedStatus);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Detail Tiket'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_userRole == 'admin')
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _showStatusUpdateDialog,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTicket,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      elevation: 10,
                      shadowColor: primaryColor.withOpacity(0.25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Icon(
                                Icons.confirmation_number,
                                size: 48,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _ticket!.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _infoRow(
                                'Deskripsi', _ticket!.description ?? '-'),
                            _infoRow('Status', _ticket!.status),
                            _infoRow(
                                'Dibuat', _ticket!.createdAt.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
