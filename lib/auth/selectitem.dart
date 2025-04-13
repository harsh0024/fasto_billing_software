import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:fasto_billing_software/billing/searchcustomer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/newitem.dart';
import 'billitem.dart';
import 'modifyquantity.dart';

class SelectItemPage extends StatefulWidget {
  @override
  _SelectItemPageState createState() => _SelectItemPageState();

}

class _SelectItemPageState extends State<SelectItemPage> {
  List<String> categories = ["Best Seller Items (5)", "Chai (0)", "New Category (0)"];
  int selectedCategoryIndex = 0;
  String newImagePath = '';  // Define a variable to store the new image path
  double newSellPrice = 0.0;  // Define a variable to store the new selling price


  List<Map<String, dynamic>> items = [
    {"name": "Samosa", "image": "lib/images/samosa.png", "count": 0, "stock": 50, "price": 20}, //  Changed "rate" to "price"
    {"name": "Kachori", "image": "lib/images/kachori.png", "count": 0, "stock": 50, "price": 20},
    {"name": "Pakode", "image": "lib/images/pakode.jpg", "count": 0, "stock": 50, "price": 30},
    {"name": "Sambarvadi", "image": "lib/images/sambarvadi.jpg", "count": 0, "stock": 50, "price": 25},
    {"name": "Chai", "image": "lib/images/chai.png", "count": 0, "stock": 50, "price": 10},
  ];
  int totalAmount = 0;// ✅ Make it double for decimals


  List<Map<String, dynamic>> selectedItems = [];

  void addItemToReceipt(int index) {
    setState(() {
      if (items[index]['count'] > 0) {
        selectedItems.add({
          'name': items[index]['name'],
          'price': items[index]['price'],
          'count': items[index]['count'],
        });
      }
    });
  }


  void updateItemCount(int index, int change) {
    setState(() {
      items[index]['count'] = (items[index]['count'] + change).clamp(0, 99);
      _calculateTotalAmount();  // ✅ Update total when item count changes
    });
  }

// ✅ Corrected function to calculate total price
  void _calculateTotalAmount() {
    int newTotal = 0;
    for (var item in items) {
      int count = item['count'] ?? 0;
      int price = int.tryParse(item['price'].toString()) ?? 0;
      newTotal += count * price;
    }

    setState(() {
      totalAmount = newTotal;  // ✅ Update totalAmount
    });
  }

// ✅ Corrected function to load saved selling prices
  Future<void> _loadSavedSellPrices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      for (var i = 0; i < items.length; i++) {
        String itemName = items[i]['name'];
        String? savedPrice = prefs.getString('sell_price_$itemName');

        items[i]['price'] = savedPrice != null
            ? double.tryParse(savedPrice) ?? items[i]['price']
            : items[i]['price'];
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _loadSavedSellPrices(); // Load all prices when the screen starts
    _loadInventory(); // Load inventory items
  }

  Future<void> _loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedItems = prefs.getStringList("inventory_items") ?? [];

    if (savedItems.isNotEmpty) {
      setState(() {
        items = savedItems.map((item) => jsonDecode(item)).toList().cast<Map<String, dynamic>>();
      });
    }

    // ✅ Fetch stored sell prices for all items
    for (int i = 0; i < items.length; i++) {
      String itemName = items[i]['name'];
      String? savedPrice = prefs.getString('sell_price_$itemName');

      if (savedPrice != null) {
        setState(() {
          items[i]['price'] = int.tryParse(savedPrice) ?? items[i]['price'];
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Items", style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xFFB239D3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Row(
        children: [
          // Left Sidebar - Categories
          Container(
            width: 120,
            color: Colors.purple.shade50,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => selectedCategoryIndex = index),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: selectedCategoryIndex == index ? Colors.purple.shade100 : Colors.white,
                      border: Border.all(color: Colors.purple.shade100),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Right Side - Item Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.55,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        items[index]['count'] = ((items[index]['count'] ?? 0) + 1).clamp(0, 300);
                        _calculateTotalAmount();  // ✅ Update total price after tapping
                      });

                      // Add selected item to receipt list
                      addItemToReceipt(index);
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black45),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(1, 2))],
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Ensure Column takes only necessary space

                        children: [
                          //image
                          Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: items[index]['image'].startsWith('lib/')
                                    ? AssetImage(items[index]['image']) as ImageProvider
                                    : FileImage(File(items[index]['image'])),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Text(items[index]['name'],
                                textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 5),
                          Text('Stock: ${items[index]['stock']}',
                              style: TextStyle(fontSize: 12, color: Colors.green[800])),
                          //SizedBox(height: 5), //to give specific height to the box for content
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Count Box
                              GestureDetector(
                                onTap: () async {
                                  String? modifiedQuantity = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ModifyQuantityPage(
                                        initialQuantity: (items[index]['count'] ?? 0).toString(),
                                      ),
                                    ),
                                  );

                                  if (modifiedQuantity != null) {
                                    setState(() {
                                      int newCount = int.parse(modifiedQuantity);
                                      items[index]['count'] = newCount.clamp(0, 300);
                                      _calculateTotalAmount(); // 🛠️ Add this line to recalculate total immediately// Ensure between 0 and 300
                                    });
                                  }
                                },
                                child: Container(
                                  width: 30,
                                  height: 18,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.purple, width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    (items[index]['count'] ?? 0).toString(), // Default to 0 if null
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),

                              // Rate Box  (Right Corner - Small Size)
                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BillItemPage(
                                        initialSellPrice: items[index]['price'].toString(),
                                        itemIndex: index,
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    setState(() {
                                      items[index]['price'] = int.parse(result.toString()); // ✅ Correct conversion
                                    });

                                    //  Save updated sell price in SharedPreferences
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('sell_price_${items[index]['name']}', result.toString());
                                  }
                                },
                                child: DottedBorder(
                                  color: Colors.purple, // Border color
                                  borderType: BorderType.RRect, // Rounded Rect border
                                  radius: Radius.circular(6), // Rounded corners
                                  dashPattern: [3, 1], // Dash pattern: 4px dash, 3px gap
                                  strokeWidth: 1,
                                  child: Container(
                                    width: 25,
                                    height: 14,
                                    alignment: Alignment.center,
                                    child: Text(
                                      items[index]['price'].toString(), // Display saved value
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Floating Button - Add New Item
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        shape: CircleBorder(), // Ensures the FAB is circular
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showMenuDrawer(context); // Show the menu drawer
        },
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // Background color
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            children: [
              // DETAILS Button (Slightly smaller)
              Expanded(
                flex: 2, // Reduce width
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black87),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white, // Button Background
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "DETAILS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10, // Decreased text size
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3),

              // KOT Button (Slightly smaller)
              Expanded(
                flex: 2, // Reduce width
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black87),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white, // Button Background
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "KOT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10, // Decreased text size
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10), // Added more space between KOT and NEXT button

              // NEXT Button (Wider)
              Expanded(
                flex: 4, // Increase width
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.purple),
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purple], // Smooth gradient
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchCustomerPage(
                          totalAmount: totalAmount.toInt(),
                          selectedItems: selectedItems,
                        ),
                        ), // Navigate to SearchCustomerPage
                      );
                    },
                    child: Text(
                      "NEXT [ Rs. $totalAmount ]", // ✅ Updated dynamically
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12, // Adjusted text size
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to show the small menu drawer
void _showMenuDrawer(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem(
              icon: Icons.edit,
              title: "ADD NEW ITEM",
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewItemPage()), // Navigate to newitem.dart
                );
              },
            ),
            _menuItem(
              icon: Icons.shopping_cart,
              title: "PARCEL",
              onTap: () {
                // TODO: Add functionality for PARCEL
              },
            ),
            _menuItem(
              icon: Icons.pan_tool,
              title: "HOLD",
              onTap: () {
                // TODO: Add functionality for HOLD
              },
            ),
          ],
        ),
      );
    },
  );
}

// Reusable menu item widget
Widget _menuItem({required IconData icon, required String title, required VoidCallback onTap}) {
  return ListTile(
    leading: Icon(icon, color: Colors.black),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14, // Slightly larger for better readability
      ),
    ),
    onTap: onTap, // Handles menu item taps
  );
}
