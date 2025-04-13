import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/signin.dart';
import 'firebase_options.dart'; // Auto-generated file by Firebase CLI

import 'auth/login.dart';
import 'auth/createaccount.dart';
import 'auth/dashboard.dart';
import 'home/inventory.dart';
import 'home/settings.dart';
import 'home/transactions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

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
      home: AuthCheck(), // Check authentication status on startup
      // Set initial page
      routes: {
        '/create-account': (context) => const CreateAccountPage(),
        '/dashboard': (context) => DashboardPage(),
        '/inventory': (context) => InventoryPage(),
        '/settings': (context) =>  SettingsPage(),
        '/history': (context) =>  TransactionsPage(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; // Check if user is logged in

    if (user != null) {
      return DashboardPage(); // If user is logged in, go to Dashboard
    } else {
      return SignInPage(); // If no user, show login page
    }
  }
}
