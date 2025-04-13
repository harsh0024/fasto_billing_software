import 'package:flutter/material.dart';

class BillingSettingsPage extends StatelessWidget {
  const BillingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing Settings"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text("This is the Billing Settings Page"),
      ),
    );
  }
}
