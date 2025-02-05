import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'auth/createaccount.dart';// Import the CreateAccountPage
import 'auth/dashboard.dart';
import 'home/inventory.dart';
import 'home/settings.dart';
import 'home/history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define the initial route
      home: const LoginPage(),
      // Define named routes for navigation
      routes: {
        '/create-account': (context) => const CreateAccountPage(),
        '/dashboard': (context) => DashboardPage(),
        '/inventory': (context) => InventoryPage(),  // Ensure SectionPage exists in section.dart
        '/settings': (context) => SettingsPage(),  // Ensure SettingsPage exists in settings.dart
        '/history': (context) => HistoryPage(),    // Ensure HistoryPage exists in history.dart
      },
    );
  }
}
