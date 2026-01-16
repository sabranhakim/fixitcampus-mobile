import 'package:flutter/material.dart';
import 'package:fixitcampus_mobile/src/services/user_service.dart';
import 'package:fixitcampus_mobile/src/models/user.dart';

class ProfileScreen extends StatefulWidget {
  final String token;

  const ProfileScreen({super.key, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = await UserService.getUserProfile(widget.token);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xFF795548),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _user == null
                  ? const Center(child: Text('Tidak ada data profil'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama: ${_user!.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Email: ${_user!.email}', style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('Role: ${_user!.role}', style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          if (_user!.createdAt != null)
                            Text('Bergabung Sejak: ${_user!.createdAt!.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
    );
  }
}