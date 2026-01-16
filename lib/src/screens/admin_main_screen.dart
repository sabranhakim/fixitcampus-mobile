import 'package:flutter/material.dart';
import 'package:fixitcampus_mobile/src/screens/admin_screen.dart';
import 'package:fixitcampus_mobile/src/screens/notification_screen.dart'; // Admin might need access to notifications
import 'package:fixitcampus_mobile/src/services/storage_service.dart';
import 'package:fixitcampus_mobile/src/screens/login_screen.dart'; // For logout navigation
import 'package:fixitcampus_mobile/src/screens/user_management_screen.dart'; // Import UserManagementScreen
import 'package:fixitcampus_mobile/src/screens/admin_settings_screen.dart'; // Import AdminSettingsScreen

class AdminMainScreen extends StatefulWidget {
  final String token;
  const AdminMainScreen({super.key, required this.token});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      AdminScreen(token: widget.token),
      NotificationScreen(token: widget.token), // Admin view for notifications
      UserManagementScreen(token: widget.token), // Use UserManagementScreen
      const AdminSettingsScreen(), // Use the new AdminSettingsScreen
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await _storageService.deleteToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF795548),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pengguna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF795548),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
