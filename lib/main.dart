import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'auth/createaccount.dart'; // Import the CreateAccountPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define the initial route
      home: LoginPage(),
      // Define named routes for navigation
      routes: {
        '/create-account': (context) => const CreateAccountPage(),
      },
    );
  }
}
