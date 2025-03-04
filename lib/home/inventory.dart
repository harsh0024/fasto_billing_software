import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'modifyitem.dart';
import 'newitem.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Map<String, dynamic>> items = [
    {"name": "Samosa", "image": "lib/images/samosa.png","stock": 5, "price": 20},
    {"name": "Kachori", "image": "lib/images/kachori.png", "stock": 0, "price": 20},
    {"name": "Pakode", "image": "lib/images/pakode.jpg", "stock": 50, "price": 30},
    {"name": "Sambarvadi", "image": "lib/images/sambarvadi.jpg", "stock": 10, "price": 40},
    {"name": "Chai", "image": "lib/images/chai.png", "stock": 10, "price": 10},
  ];

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedItems = prefs.getStringList("inventory_items");

    if (savedItems == null || savedItems.isEmpty) {
      // If no items are stored, save predefined items
      await _saveInventory(); //save predefined items if empty
    } else {
      setState(() {
        items = savedItems.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
      });
    }
  }

  Future<void> _saveInventory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedItems = items.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList("inventory_items", savedItems);
  }


  void addItem(Map<String, dynamic> newItem) {
    setState(() {
      items.add(newItem);
    });
    _saveInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Item List",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF6A1B9A),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: () async {
                final newItem = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewItemPage()),
                );

                if (newItem != null) {
                  addItem(newItem);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "NEW ITEM",
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Inventory",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Implement filter functionality
                },
                icon: Icon(Icons.filter_list, color: Colors.black, size: 20),
                label: Text("FILTER", style: TextStyle(color: Colors.black, fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

          Expanded(
            child: items.isEmpty
                ? Center(child: Text("No items in inventory", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: items[index]['image'].startsWith('lib/images/')
                              ? Image.asset(
                            items[index]['image'], // ✅ Load asset image
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          )
                              : Image.file(
                            File(items[index]['image']), // ✅ Load user-selected image
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 70, color: Colors.grey); // Handle errors
                            },
                          ),
                        ),
                      ),

                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index]['name'],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Stock: ${items[index]['stock']}",
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rs. ${items[index]['price']}",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          SizedBox(
                            width: 100,
                            height: 35,
                            child: ElevatedButton(
                              onPressed: () async {
                                final modifiedItem = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModifyItemPage(item: items[index]),
                                  ),
                                );

                                if (modifiedItem != null) {
                                  setState(() {
                                    items[index] = modifiedItem; // Update modified item
                                  });
                                  _saveInventory(); // Save updated inventory
                                }
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6A1B9A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Adjust",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
