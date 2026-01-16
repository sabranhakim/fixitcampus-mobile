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

  static const Color primaryColor = Color(0xFF795548);
  static const Color backgroundColor = Color(0xFFFFF8F2);
  static const Color fieldColor = Color(0xFFF3ECE7);

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

  Widget _profileItem(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, color: primaryColor, size: 22),
          if (icon != null) const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _user == null
                  ? const Center(child: Text('Tidak ada data profil'))
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
                              Center(
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: fieldColor,
                                  child: const Icon(
                                    Icons.person,
                                    size: 48,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  _user!.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              _profileItem(
                                'Email',
                                _user!.email,
                                icon: Icons.email,
                              ),
                              _profileItem(
                                'Role',
                                _user!.role,
                                icon: Icons.security,
                              ),

                              if (_user!.createdAt != null)
                                _profileItem(
                                  'Bergabung Sejak',
                                  _user!.createdAt!
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                                  icon: Icons.calendar_today,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
    );
  }
}
