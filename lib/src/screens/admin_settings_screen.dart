import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Admin'),
        backgroundColor: const Color(0xFF795548),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.security, color: Color(0xFF795548)),
              title: const Text('Manajemen Hak Akses'),
              subtitle: const Text('Kelola peran dan izin pengguna'),
              onTap: () {
                // TODO: Implement navigation to access management screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Manajemen Hak Akses dipilih')),
                );
              },
            ),
          ),
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.settings_applications, color: Color(0xFF795548)),
              title: const Text('Konfigurasi Aplikasi'),
              subtitle: const Text('Atur pengaturan umum aplikasi'),
              onTap: () {
                // TODO: Implement navigation to app configuration screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Konfigurasi Aplikasi dipilih')),
                );
              },
            ),
          ),
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.email, color: Color(0xFF795548)),
              title: const Text('Pengaturan Notifikasi Email'),
              subtitle: const Text('Kelola templat dan pengiriman email'),
              onTap: () {
                // TODO: Implement navigation to email notification settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pengaturan Notifikasi Email dipilih')),
                );
              },
            ),
          ),
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.info, color: Color(0xFF795548)),
              title: const Text('Tentang'),
              subtitle: const Text('Informasi versi aplikasi'),
              onTap: () {
                // TODO: Implement navigation to about screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tentang dipilih')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
