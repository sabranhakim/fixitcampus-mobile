import 'package:flutter/material.dart';
import 'package:fixitcampus_mobile/src/screens/home_screen.dart';
import 'package:fixitcampus_mobile/src/screens/ticket_list_screen.dart';
// import 'package:fixitcampus_mobile/src/screens/create_ticket_screen.dart'; // Removed CreateTicketScreen from direct tab
import 'package:fixitcampus_mobile/src/screens/profile_screen.dart';
import 'package:fixitcampus_mobile/src/services/storage_service.dart';
import 'package:fixitcampus_mobile/src/screens/login_screen.dart';

class UserMainScreen extends StatefulWidget {
  final String token;

  const UserMainScreen({super.key, required this.token});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(onNavigateToTickets: _goToTicketsTab),
      TicketListScreen(token: widget.token),
      ProfileScreen(token: widget.token), // ProfileScreen is now at index 2
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToTicketsTab() {
    setState(() {
      _selectedIndex = 1; // Index of the 'Tiket' tab
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
        title: const Text('FixIT Campus'),
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
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Tiket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
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
