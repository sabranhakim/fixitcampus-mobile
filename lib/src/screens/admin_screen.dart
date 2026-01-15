import 'package:flutter/material.dart';
import '../models/report.dart';
import '../services/storage_service.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Dummy data - In a real app, you would fetch this from your API
  final List<Report> _reports = [
    Report(
        id: '1',
        title: 'Lampu koridor mati',
        description: 'Lampu di koridor GKB 3 lantai 2 mati total.',
        createdBy: 'User A',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'Baru'),
    Report(
        id: '2',
        title: 'AC tidak dingin',
        description: 'AC di ruang kelas 202 tidak dingin.',
        createdBy: 'User B',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Dikerjakan'),
    Report(
        id: '3',
        title: 'Proyektor rusak',
        description: 'Proyektor di auditorium tidak mau menyala.',
        createdBy: 'User C',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        status: 'Selesai'),
    Report(
        id: '4',
        title: 'Keran air bocor',
        description: 'Keran di toilet pria lantai 1 bocor.',
        createdBy: 'User D',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        status: 'Selesai'),
  ];

  Future<void> _logout() async {
    await StorageService().deleteToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Logic to calculate stats from the reports list
    final totalReports = _reports.length;
    final pendingReports =
        _reports.where((r) => r.status == 'Baru' || r.status == 'Dikerjakan').length;
    final completedReports =
        _reports.where((r) => r.status == 'Selesai').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Dashboard Stats Cards
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildStatCard('Total Laporan', totalReports.toString(), Colors.blue),
                _buildStatCard('Tertunda', pendingReports.toString(), Colors.orange),
                _buildStatCard('Selesai', completedReports.toString(), Colors.green),
              ],
            ),
          ),
          const Divider(thickness: 2),
          // List of Reports
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Semua Laporan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final report = _reports[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(report.title),
                    subtitle: Text('Status: ${report.status} - Dibuat pada ${report.createdAt.toLocal().toString().split(' ')[0]}'),
                    trailing: _buildStatusChip(report.status),
                    onTap: () {
                      // TODO: Navigate to report detail screen
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Card(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Baru':
        color = Colors.blue;
        break;
      case 'Dikerjakan':
        color = Colors.orange;
        break;
      case 'Selesai':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status),
      backgroundColor: color.withAlpha(51),
      labelStyle: TextStyle(color: color),
    );
  }
}