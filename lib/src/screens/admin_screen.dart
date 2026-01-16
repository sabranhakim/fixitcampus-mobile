import 'package:flutter/material.dart';
import 'package:fixitcampus_mobile/src/models/report_summary.dart';
import 'package:fixitcampus_mobile/src/models/ticket.dart';
import 'package:fixitcampus_mobile/src/services/reporting_service.dart';
import 'package:fixitcampus_mobile/src/services/ticket_service.dart';
import 'ticket_detail_screen.dart';

class AdminScreen extends StatefulWidget {
  final String token;
  const AdminScreen({super.key, required this.token});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TicketService _ticketService = TicketService();
  final ReportingService _reportingService = ReportingService();

  late Future<List<Ticket>> _reports;
  late Future<ReportSummary> _summary;

  static const Color primaryColor = Color(0xFF795548);
  static const Color backgroundColor = Color(0xFFFFF8F2);
  static const Color fieldColor = Color(0xFFF3ECE7);

  @override
  void initState() {
    super.initState();
    _loadReports();
    _loadSummary();
  }

  void _loadReports() {
    _reports = _ticketService.getTickets(widget.token);
  }

  void _loadSummary() {
    _summary = _reportingService.getSummary(widget.token);
  }

  Future<void> _refreshData() async {
    setState(() {
      _loadReports();
      _loadSummary();
    });
  }

  void _navigateToDetail(Ticket ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TicketDetailScreen(
          ticketId: ticket.id.toString(),
          token: widget.token,
        ),
      ),
    ).then((_) => _refreshData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        // TITLE DIHAPUS
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              const Text(
                'Selamat Datang, Admin',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ringkasan laporan & manajemen tiket',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // SUMMARY
              FutureBuilder<ReportSummary>(
                future: _summary,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Text('Gagal memuat ringkasan');
                  }

                  final s = snapshot.data!;
                  return Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          'Total',
                          s.totalTickets.toString(),
                          Icons.list_alt,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          'Tertunda',
                          s.openTickets.toString(),
                          Icons.hourglass_empty,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          'Selesai',
                          s.closedTickets.toString(),
                          Icons.check_circle,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),

              // LIST HEADER
              const Text(
                'Daftar Laporan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // REPORT LIST
              FutureBuilder<List<Ticket>>(
                future: _reports,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Text('Gagal memuat laporan');
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Text('Belum ada laporan');
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final ticket = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 6,
                        shadowColor: primaryColor.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor:
                                _statusColor(ticket.status).withOpacity(0.15),
                            child: Icon(
                              _statusIcon(ticket.status),
                              color: _statusColor(ticket.status),
                            ),
                          ),
                          title: Text(
                            ticket.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Status: ${ticket.status}',
                                style: TextStyle(
                                  color: _statusColor(ticket.status),
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Dibuat: ${ticket.createdAt.toString().split(' ')[0]}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () => _navigateToDetail(ticket),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== COMPONENTS =====

  Widget _statCard(String title, String value, IconData icon) {
    return Card(
      elevation: 8,
      shadowColor: primaryColor.withOpacity(0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'open':
        return Icons.warning_amber;
      case 'in_progress':
        return Icons.hourglass_empty;
      case 'closed':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }
}
