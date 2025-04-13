import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditItemPage extends StatefulWidget {
  final Map<String, dynamic> item;

  EditItemPage({required this.item});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _mrpController;
  late TextEditingController _purchasePriceController;

  String? _selectedCategory;
  File? _selectedImage;
  String? _imagePath;

  final List<String> _categories = ["Food", "Beverage", "Snack", "Add category", "Uncategorized"];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item['name']);
    _priceController = TextEditingController(text: widget.item['price'].toString());
    _mrpController = TextEditingController(text: widget.item['mrp']?.toString() ?? ''); // Avoid null
    _purchasePriceController = TextEditingController(text: widget.item['purchasePrice']?.toString() ?? ''); // Avoid null

    _selectedCategory = widget.item['category'];
    if (!_categories.contains(_selectedCategory)) {
      _selectedCategory = "Uncategorized"; // Default to avoid dropdown error
    }

    _imagePath = widget.item['image'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveEditedItem() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter all required details")),
      );
      return;
    }

    final updatedItem = {
      "name": _nameController.text,
      "price": _priceController.text,
      "category": _selectedCategory ?? "Uncategorized",
      "mrp": _mrpController.text.isEmpty ? "0" : _mrpController.text, // Avoid null values
      "purchasePrice": _purchasePriceController.text.isEmpty ? "0" : _purchasePriceController.text, // Avoid null
      "image": _imagePath,
    };

    final prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList("inventory_items") ?? [];
    List<Map<String, dynamic>> itemList = items.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    int index = itemList.indexWhere((element) => element['name'] == widget.item['name']);
    if (index != -1) {
      itemList[index] = updatedItem; // Update existing item
    }

    // Save updated list back to SharedPreferences
    await prefs.setStringList("inventory_items", itemList.map((e) => jsonEncode(e)).toList());

    // Ensure the previous screen is updated
    Navigator.pop(context, updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.item['name']}", style: TextStyle(fontSize: 18, color: Colors.white)),
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
                  image: (_selectedImage != null || _imagePath != null)
                      ? DecorationImage(
                    image: _selectedImage != null ? FileImage(_selectedImage!) : FileImage(File(_imagePath!)),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: (_selectedImage == null && _imagePath == null)
                    ? Icon(Icons.upload, size: 30, color: Colors.grey)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Product Name *", border: OutlineInputBorder())),
            SizedBox(height: 12),
            TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Sell Price *", border: OutlineInputBorder())),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: "Select Item Category", border: OutlineInputBorder()),
              items: _categories.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 12),
            TextField(controller: _mrpController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "MRP", border: OutlineInputBorder())),
            SizedBox(height: 12),
            TextField(controller: _purchasePriceController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Purchase Price", border: OutlineInputBorder())),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEditedItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB239D3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text("SAVE CHANGES", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
