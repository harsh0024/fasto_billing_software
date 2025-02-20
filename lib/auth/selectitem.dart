import 'package:flutter/material.dart';

class SelectItemPage extends StatefulWidget {
  @override
  _SelectItemPageState createState() => _SelectItemPageState();
}

class _SelectItemPageState extends State<SelectItemPage> {
  List<String> categories = ["Best Seller Items (5)", "Chai (0)", "New Category (0)"];
  int selectedCategoryIndex = 0;

  List<Map<String, dynamic>> items = [
    {"name": "Samosa", "image": "lib/images/google.png", "count": 2},
    {"name": "Kachori", "image": "lib/images/google.png", "count": 0},
    {"name": "Pakode", "image": "lib/images/google.png", "count": 0},
    {"name": "Sambarvadi", "image": "lib/images/google.png", "count": 0},
    {"name": "Chai", "image": "lib/images/google.png", "count": 0},
  ];

  int totalAmount = 20;

  void updateItemCount(int index, int change) {
    setState(() {
      items[index]['count'] = (items[index]['count'] + change).clamp(0, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Items", style: TextStyle(fontSize: 15)),
        backgroundColor: Colors.purple.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.calculate),
            onPressed: () {},
          ),
        ],
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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedCategoryIndex == index ? Colors.purple.shade100 : Colors.white,
                        // borderRadius: BorderRadius.circular(8),
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
                  ),
                );
              },
            ),
          ),

          // **Right Side - Item Grid**
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "BEST SELLER ITEMS",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Items Grid
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(5),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 items per row
                        childAspectRatio: 0.9, // Adjust for proper spacing
                        crossAxisSpacing: 8,//horizontal spacing
                        mainAxisSpacing: 12, //vertical spacing
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black45),
                          ),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between elements
                            children: [
                              Flexible(
                                child: Image.asset(items[index]['image'], height: 34), // Reduced image size
                              ), // Item Image
                              SizedBox(height: 5),
                              Text(
                                items[index]['name'],
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                               // Pushes the buttons to the bottom
                              SizedBox(height: 5), // Added a small gap
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5), // Adjust spacing if needed
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // Centering the buttons
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove, size: 12, color: Colors.red),
                                      onPressed: () => updateItemCount(index, -1),
                                      padding: EdgeInsets.zero, // Removes extra padding
                                      constraints: BoxConstraints(), // Avoids overflow
                                    ),
                                    Text(
                                      items[index]['count'].toString(),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add, size: 12, color: Colors.green),
                                      onPressed: () => updateItemCount(index, 1),
                                      padding: EdgeInsets.zero, // Removes extra padding
                                      constraints: BoxConstraints(), // Avoids overflow
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
                      // Handle save action
                    },
                    child: Text(
                      "NEXT (Rs.$totalAmount)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10, // Decreased text size
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
            _menuItem(Icons.edit, "ADD NEW ITEM"),
            _menuItem(Icons.shopping_cart, "PARCEL"),
            _menuItem(Icons.pan_tool, "HOLD"),
          ],
        ),
      );
    },
  );
}

// Widget for menu items
Widget _menuItem(IconData icon, String title) {
  return ListTile(
    leading: Icon(icon, color: Colors.black),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12, // Reduced font size
      ),
    ),
    onTap: () {
      // Handle menu item tap
    },
  );
}