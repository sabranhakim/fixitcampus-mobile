import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToTickets; // Add callback

  const HomeScreen({super.key, required this.onNavigateToTickets}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFFFF8F2),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              decoration: BoxDecoration(
                color: const Color(0xFF795548),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.home_work,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Selamat Datang di FixIT Campus',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sistem Pelaporan Kerusakan Fasilitas Kampus',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Button to navigate to tickets list
            ElevatedButton.icon(
              onPressed: onNavigateToTickets, // Use the callback
              icon: const Icon(Icons.list_alt, color: Colors.white),
              label: const Text(
                'Lihat Daftar Tiket',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF795548),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 24),


            // Information Cards Section
            _buildInfoCard(
              icon: Icons.lightbulb_outline,
              title: 'Tentang Aplikasi',
              description:
                  'Aplikasi ini dirancang untuk memudahkan mahasiswa dan staf dalam melaporkan kerusakan fasilitas kampus dengan cepat dan efisien.',
              color: Colors.lightBlue.shade100,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.security,
              title: 'Keamanan Data',
              description:
                  'Kami menjamin keamanan dan kerahasiaan data laporan Anda. Setiap laporan akan ditindaklanjuti dengan profesional.',
              color: Colors.green.shade100,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.support_agent,
              title: 'Bantuan & Dukungan',
              description:
                  'Jika Anda memiliki pertanyaan atau membutuhkan bantuan, jangan ragu untuk menghubungi tim dukungan kami.',
              color: Colors.orange.shade100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.grey.shade800),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
