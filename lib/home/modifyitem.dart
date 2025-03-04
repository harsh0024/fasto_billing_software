import 'package:flutter/material.dart';

class ModifyItemPage extends StatefulWidget {
  final Map<String, dynamic> item;

  ModifyItemPage({required this.item});

  @override
  _ModifyItemPageState createState() => _ModifyItemPageState();
}

class _ModifyItemPageState extends State<ModifyItemPage> {
  late TextEditingController nameController;
  late TextEditingController stockController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item['name']);
    stockController = TextEditingController(text: widget.item['stock'].toString());
    priceController = TextEditingController(text: widget.item['price'].toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    stockController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void saveChanges() {
    Navigator.pop(context, {
      "name": nameController.text,
      "image": widget.item['image'],
      "stock": int.tryParse(stockController.text) ?? 0,
      "price": int.tryParse(priceController.text) ?? 0,
    });
  }

  void deleteItem() {
    // Handle delete functionality
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Modify Item",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF6A1B9A),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: saveChanges,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: deleteItem,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField(nameController, "Item Name"),
                  SizedBox(height: 20),
                  _buildTextField(stockController, "Stock Quantity", isNumber: true),
                  SizedBox(height: 20),
                  _buildTextField(priceController, "Price (Rs.)", isNumber: true),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A1B9A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label, // Label inside the field
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF6A1B9A), width: 2),
        ),
      ),
      style: TextStyle(fontSize: 16),
    );
  }
}
