import 'package:flutter/material.dart';

class AppSetupPage extends StatelessWidget {
  const AppSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Setup"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text("This is the App Setup Page"),
      ),
    );
  }
}
