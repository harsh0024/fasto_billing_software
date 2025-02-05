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
        title: Text("Select Items", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar - Categories
          Container(
            width: 120,
            color: Colors.grey[200],
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
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.purple),
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

          // Right Side - Item Grid
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Items Grid
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 items per row
                        childAspectRatio: 0.6, // Adjust for proper spacing
                        crossAxisSpacing: 4,//horizontal spacing
                        mainAxisSpacing: 25, //vertical spacing
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.purple.shade100),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(items[index]['image'], height: 30), // Item Image
                              SizedBox(height: 15),
                              Text(
                                items[index]['name'],
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 3),
                              Align(
                                alignment: Alignment.bottomCenter, // Ensures the row stays at the bottom
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 0), // Adjust spacing if needed
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center, // Ensures proper spacing
                                    children: [
                                      // Decrease Button
                                      IconButton(
                                        icon: Icon(Icons.remove, size: 8, color: Colors.red), // Increased size for visibility
                                        onPressed: () => updateItemCount(index, -1),
                                      ),
                                      Text(
                                        items[index]['count'].toString(),
                                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                      // Increase Button
                                      IconButton(
                                        icon: Icon(Icons.add, size: 8, color: Colors.green), // Increased size for visibility
                                        onPressed: () => updateItemCount(index, 1),
                                      ),
                                    ],
                                  ),
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
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple.shade900,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {},
              child: Text("DETAILS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {},
              child: Text("KOT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
              child: Text("SAVE (Rs $totalAmount)"),
            ),
          ],
        ),
      ),
    );
  }
}
