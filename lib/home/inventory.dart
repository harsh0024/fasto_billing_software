import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<String> categories = ["Best Seller Items", "Chai", "New Category"];
  int selectedCategoryIndex = 0;

  List<Map<String, dynamic>> items = [
    {"name": "Samosa", "image": "lib/images/google.png", "count": 2},
    {"name": "Kachori", "image": "lib/images/google.png", "count": 0},
    {"name": "Pakode", "image": "lib/images/google.png", "count": 1},
    {"name": "Sambharvadi", "image": "lib/images/google.png", "count": 0},
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
        title: Text("Inventory"),
        backgroundColor: Color(0xFFD57FE8),
      ),
      body: Row(
        children: [
          Container(
            width: 120,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index], textAlign: TextAlign.center),
                  selected: selectedCategoryIndex == index,
                  selectedTileColor: Colors.purple.shade100,
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.6, // Adjusted for better layout
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 0.4,
                          blurRadius: 9,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            items[index]['image'],
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          items[index]['name'],
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.red, size: 18),
                                onPressed: () => updateItemCount(index, -1),
                              ),
                              Text(
                                "${items[index]['count']}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.green, size: 18),
                                onPressed: () => updateItemCount(index, 1),
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
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF4A2A54),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {},
              child: Text("DETAILS", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {},
              child: Text("KOT", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("SAVE (Rs $totalAmount)"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
            ),
          ],
        ),
      ),
    );
  }
}
