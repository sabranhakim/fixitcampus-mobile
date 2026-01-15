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

  Future<void> _refreshData() async { // Corrected: Added Future<void> and made it a proper method
    setState(() {
      _reports = _ticketService.getTickets(widget.token);
      _summary = _reportingService.getSummary(widget.token);
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
    ).then((_) => setState(() {
          _loadReports();
          _loadSummary();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Header
            const Text(
              'Selamat Datang, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E342E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ringkasan Laporan dan Manajemen Tiket',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Dashboard Stats Cards
            FutureBuilder<ReportSummary>(
              future: _summary,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No summary data'));
                }

                final summary = snapshot.data!;
                return GridView.count(
                  crossAxisCount: 2, // Changed to 2 for better visual balance
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Important for nested scroll views
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildStatCard('Total Laporan',
                        summary.totalTickets.toString(), Colors.indigo),
                    _buildStatCard('Tertunda', summary.openTickets.toString(),
                        Colors.amber.shade700),
                    _buildStatCard('Selesai', summary.closedTickets.toString(),
                        Colors.green.shade600),
                    _buildStatCard(
                        'Belum Ditugaskan', 'N/A', Colors.red.shade400), // Placeholder
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // List of Reports Header
            const Text(
              'Daftar Laporan Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E342E),
              ),
            ),
            const SizedBox(height: 16),

            // List of Reports
            FutureBuilder<List<Ticket>>(
              future: _reports,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No reports'));
                }

                final reports = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Important for nested scroll views
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(report.status),
                          child: Icon(
                            _getStatusIcon(report.status),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          report.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Status: ${report.status}',
                              style: TextStyle(color: _getStatusColor(report.status)),
                            ),
                            Text(
                              'Dibuat pada ${report.createdAt.toString().split(' ')[0]}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () => _navigateToDetail(report),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Card(
      color: color,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
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