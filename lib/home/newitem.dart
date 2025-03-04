import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NewItemPage extends StatefulWidget {
  @override
  _NewItemPageState createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();

  String? _selectedCategory;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveNewItem() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter all required details")),
      );
      return;
    }

    final newItem = {
      "name": _nameController.text,
      "price": _priceController.text,
      "category": _selectedCategory ?? "Uncategorized",
      "mrp": _mrpController.text,
      "purchasePrice": _purchasePriceController.text,
      "image": _selectedImage!.path, // Store image path
    };

    final prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList("inventory_items") ?? [];
    items.add(jsonEncode(newItem)); // Store as JSON string
    await prefs.setStringList("inventory_items", items);

    Navigator.pop(context, newItem); // Pass item back to Inventory Page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("New Item", style: TextStyle(fontSize: 18, color: Colors.white)),
        backgroundColor: Color(0xFFB239D3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Item Images", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 80,
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  image: _selectedImage != null
                      ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover,)
                      : null,
                ),
                child: _selectedImage == null
                    ? Icon(Icons.upload, size: 30, color: Colors.grey)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Product / Service Name *",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: "Sell Price *",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Sell Price",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Fixed", "Variable"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Item Category",
                border: OutlineInputBorder(),
              ),
              items: ["Food", "Beverage", "Snack"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _mrpController,
                    decoration: InputDecoration(
                      labelText: "MRP:",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _purchasePriceController,
                    decoration: InputDecoration(
                      labelText: "Purchase Price",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Optional Sections (Styled as Buttons)
            _optionalSection("GST AND TAX (OPTIONAL)"),
            _optionalSection("PRODUCT DETAILS (OPTIONAL)"),
            _optionalSection("INVENTORY DETAILS (OPTIONAL)"),
            _optionalSection("PRODUCT DISPLAY (OPTIONAL)"),
            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveNewItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB239D3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text("SAVE", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _optionalSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            // Implement navigation or expand/collapse functionality
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.purple),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(title, style: TextStyle(color: Colors.purple, fontSize: 14)),
        ),
      ),
    );
  }
}
