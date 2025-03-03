import 'package:flutter/material.dart';

class SelectItemPage extends StatefulWidget {
  @override
  _SelectItemPageState createState() => _SelectItemPageState();
}

class _SelectItemPageState extends State<SelectItemPage> {
  List<String> categories = ["Best Seller Items (5)", "Chai (0)", "New Category (0)"];
  int selectedCategoryIndex = 0;

  List<Map<String, dynamic>> items = [
    {"name": "Samosa", "image": "lib/images/samosa.png", "count": 5},
    {"name": "Kachori", "image": "lib/images/kachori.png", "count": 0},
    {"name": "Pakode", "image": "lib/images/pakode.jpg", "count": 0},
    {"name": "Sambarvadi", "image": "lib/images/sambarvadi.jpg", "count": 0},
    {"name": "Chai", "image": "lib/images/chai.png", "count": 0},
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
        title: Text("Select Items", style: TextStyle(fontSize: 20,color: Colors.white)),
        backgroundColor: const Color(0xFFB239D3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search,color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner,color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.calculate,color: Colors.white),
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
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        childAspectRatio: 0.8, // Adjust for proper spacing
                        crossAxisSpacing: 10, // Space between columns
                        mainAxisSpacing: 12, // Space between rows
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black45),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(1, 2))
                            ],
                          ),
                          padding: EdgeInsets.all(10), // Added padding inside the container
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Centers everything
                            children: [
                              Flexible(
                                child: Image.asset(items[index]['image'], height: 100), // Increased image size
                              ), // Item Image

                              Text(
                                items[index]['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),

                              // SizedBox(height: 8),

                              // Counter Buttons (Add & Remove) - FIXED OVERFLOW
                              FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures spacing
                                  children: [
                                    // Remove (-) button in a box
                                    Container(
                                      width: 30, // Box width
                                      height: 30, // Box height
                                      decoration: BoxDecoration(
                                        color: Colors.white, // Background color
                                        borderRadius: BorderRadius.circular(6), // Rounded corners
                                        border: Border.all(color: Colors.red, width: 1.2), // Red border
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.remove, size: 20, color: Colors.red),
                                        onPressed: () => updateItemCount(index, -1),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                      ),
                                    ),

                                    SizedBox(width: 10), // Space between elements

                                    // Item count text
                                    Text(
                                      items[index]['count'].toString(),
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),

                                    SizedBox(width: 10), // Space between elements

                                    // Add (+) button in a box
                                    Container(
                                      width: 30, // Box width
                                      height: 30, // Box height
                                      decoration: BoxDecoration(
                                        color: Colors.white, // Background color
                                        borderRadius: BorderRadius.circular(6), // Rounded corners
                                        border: Border.all(color: Colors.green, width: 1.2), // Green border
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.add, size: 20, color: Colors.green),
                                        onPressed: () => updateItemCount(index, 1),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                      ),
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