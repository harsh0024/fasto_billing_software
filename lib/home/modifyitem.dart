import 'package:flutter/material.dart';

import 'edititem.dart';

class ModifyItemPage extends StatefulWidget {
  Map<String, dynamic> item;

  ModifyItemPage({required this.item});

  @override
  _ModifyItemPageState createState() => _ModifyItemPageState();
}

class _ModifyItemPageState extends State<ModifyItemPage> {
  late TextEditingController stockController;
  late TextEditingController purchasePriceController;

  @override
  void initState() {
    super.initState();
    stockController = TextEditingController(text: widget.item['stock'].toString());
    purchasePriceController = TextEditingController(text: widget.item['purchasePrice']?.toString() ?? "");
  }

  @override
  void dispose() {
    stockController.dispose();
    super.dispose();
  }

  void saveChanges() {
    Navigator.pop(context, {
      "name": widget.item['name'],
      "image": widget.item['image'],
      "stock": int.tryParse(stockController.text) ?? 0,
      "price": widget.item['price'],
      "purchasePrice": widget.item['purchasePrice'] ?? 0, // Ensure value persists
    });
  }

  void deleteItem() async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Confirm Deletion
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      Navigator.pop(context, true); // Return true to indicate deletion
    }
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
            onPressed: () async {
              final updatedItem = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditItemPage(item: widget.item),
                ),
              );

              if (updatedItem != null) {
                setState(() {
                  widget.item = updatedItem; // Update item details
                });
              }
            },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selected Item:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Item Name : ${widget.item['name']}", style: TextStyle(fontSize: 16)),
            Text("Sell Price : Rs.${widget.item['price']}", style: TextStyle(fontSize: 16)),
            Text("Purchase Price : Rs.${widget.item['purchasePrice']}", style: TextStyle(fontSize: 16)),
            // Text("Current Stock : ${widget.item['stock']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            _buildTextField(stockController, "Current Stock", isNumber: true),
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
        labelText: label,
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
