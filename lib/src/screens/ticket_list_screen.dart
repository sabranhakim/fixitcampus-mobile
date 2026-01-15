import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../services/ticket_service.dart';
import 'create_ticket_screen.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final TicketService _ticketService = TicketService();
  late Future<List<Ticket>> _tickets;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  void _loadTickets() {
    _tickets = _ticketService.getTickets();
  }

  void _navigateToCreateTicketScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTicketScreen()),
    ).then((_) => setState(() => _loadTickets()));
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.orange;
      case 'closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      appBar: AppBar(
        title: const Text('Daftar Tiket'),
        backgroundColor: const Color(0xFF795548),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Ticket>>(
        future: _tickets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada tiket'));
          }

          final tickets = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.report_problem, color: Color(0xFF795548)),
                  title: Text(ticket.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(ticket.description),
                  trailing: Chip(
                    label: Text(ticket.status),
                    backgroundColor: _statusColor(ticket.status).withOpacity(0.2),
                    labelStyle: TextStyle(color: _statusColor(ticket.status)),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF795548),
        onPressed: _navigateToCreateTicketScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
