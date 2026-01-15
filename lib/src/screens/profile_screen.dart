import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String token;

  const ProfileScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xFF795548),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Halaman Profil Pengguna'),
      ),
    );
  }
}