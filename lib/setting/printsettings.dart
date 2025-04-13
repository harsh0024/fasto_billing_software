import 'package:flutter/material.dart';

class PrintSettingsPage extends StatelessWidget {
  const PrintSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Print Settings"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text("This is the Print Settings Page"),
      ),
    );
  }
}
