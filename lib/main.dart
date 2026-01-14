import 'package:fixitcampus_mobile/src/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/admin_screen.dart';
import 'src/services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _initialScreen = const LoginScreen();
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _storageService.getToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final userRole = decodedToken['data']['role'];
      if (userRole == 'admin') {
        setState(() {
          _initialScreen = const AdminScreen();
        });
      } else {
        setState(() {
          _initialScreen = const HomeScreen();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixIt Campus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _initialScreen,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}