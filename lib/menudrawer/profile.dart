import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedIndustry = "IT"; // Default industry

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _businessNameController.text = prefs.getString("businessName") ?? "";
      _contactPersonController.text = prefs.getString("contactPerson") ?? "";
      _emailController.text = prefs.getString("email") ?? "";
      _selectedIndustry = prefs.getString("industry") ?? "IT";
      String? imagePath = prefs.getString("profileImage");
      if (imagePath != null) {
        _image = File(imagePath);
      }
    });
  }

  // Save data when the Save button is clicked
  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("businessName", _businessNameController.text);
    await prefs.setString("contactPerson", _contactPersonController.text);
    await prefs.setString("email", _emailController.text);
    await prefs.setString("industry", _selectedIndustry);
    if (_image != null) {
      await prefs.setString("profileImage", _image!.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully!")),
    );

    Navigator.pop(context, true); // Return true to Dashboard
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Image
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade800, Colors.blue.shade400],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Bill Book", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            // Form Fields
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedIndustry,
                    items: ['IT', 'Finance', 'Retail', 'Healthcare' , 'Telecommunications' , 'Utilities', 'Financial Services', 'SaaS',  'E-Commerce'].map((industry) {
                      return DropdownMenuItem(value: industry, child: Text(industry));
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Select Industry",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedIndustry = value!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  _buildTextField("Business Name", _businessNameController),
                  _buildTextField("Contact Person Name", _contactPersonController),
                  _buildTextField("Contact Person Email", _emailController),

                  // **Modular Buttons**
                  SizedBox(height: 10),
                  ProfileButton(text: "BUSINESS DETAILS", onPressed: () {}),
                  ProfileButton(text: "BANK DETAILS", onPressed: () {}),
                  ProfileButton(text: "UPI", onPressed: () {}),
                  ProfileButton(text: "CUSTOM FIELDS", onPressed: () {}),

                  // Save Button
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: _saveProfile,
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hint,
        ),
      ),
    );
  }
}

// **Reusable Button Widget**
class ProfileButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  ProfileButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          side: BorderSide(color: Colors.blue),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: Colors.blue)),
      ),
    );
  }
}

