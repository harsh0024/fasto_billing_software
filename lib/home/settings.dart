import 'package:fasto_billing_software/menudrawer/profile.dart';
import 'package:fasto_billing_software/setting/aboutus.dart';
import 'package:fasto_billing_software/setting/appsetup.dart';
import 'package:fasto_billing_software/setting/billingsettings.dart';
import 'package:fasto_billing_software/setting/printsettings.dart';
import 'package:fasto_billing_software/setting/privacypolicy.dart';
import 'package:fasto_billing_software/setting/termsandcondition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/signin.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsOn = true; // State variable for push notifications

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background color
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.white),
        ),
        backgroundColor: Colors.purple, // Matches the image
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text("Account Settings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                _buildSettingsTile(context, Icons.person, "Edit Profile", ProfilePage()),
                _buildSettingsTile(context, Icons.payment, "Billing Settings", BillingSettingsPage()),
                _buildSettingsTile(context, Icons.print, "Print Settings", PrintSettingsPage()),
                _buildSettingsTile(context, Icons.settings_applications, "Start App Setup", AppSetupPage(), iconTrailing: Icons.add),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: _buildSwitchTile("Push Notifications", _notificationsOn, (value) {
                    setState(() {
                      _notificationsOn = value;
                    });
                  }),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text("More", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                _buildSettingsTile(context, Icons.info, "About Us", AboutUsPage()),
                _buildSettingsTile(context, Icons.privacy_tip, "Privacy Policy", PrivacyPolicyPage()),
                _buildSettingsTile(context, Icons.article, "Terms and Conditions", TermsAndConditionsPage()),

                ListTile(
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.logout, color: Colors.red),
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Logout failed: \${e.toString()}")),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, Widget? page, {IconData? iconTrailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple[300]),
      title: Text(title),
      trailing: iconTrailing != null
          ? Icon(iconTrailing, color: Colors.grey)
          : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Transform.scale(
          scale: 0.8, // Makes the switch smaller
          child: Switch(
            value: value,
            activeColor: Colors.purple[400],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
