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
    {'name': 'Samosa', 'price': 20, 'stock': 50, 'image': 'lib/images/samosa.png'},
    {'name': 'Kachori', 'price': 20, 'stock': 50, 'image': 'lib/images/kachori.png'},
    {'name': 'Pakode', 'price': 30, 'stock': 50, 'image': 'lib/images/pakode.jpg'},
    {'name': 'Sambarvadi', 'price': 25, 'stock': 50, 'image': 'lib/images/sambarvadi.jpg'},
    {'name': 'Chai', 'price': 10, 'stock': 50, 'image': 'lib/images/chai.png'},
  ];

  @override
  void initState() {
    super.initState();
    _loadInventory(); // Load inventory when page opens
  }

  Future<void> _loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedItems = prefs.getStringList("inventory_items") ?? [];

    if (savedItems.isNotEmpty) {
      setState(() {
        items = savedItems.map((item) => jsonDecode(item)).toList().cast<Map<String, dynamic>>();
      });
    }

    // ✅ Load sell prices separately for all items
    for (var i = 0; i < items.length; i++) {
      String itemName = items[i]['name']; // Use item name as key
      String? savedPrice = prefs.getString('sell_price_$itemName');

      if (savedPrice != null) {
        setState(() {
          items[i]['price'] = int.tryParse(savedPrice) ?? items[i]['price'];
        });
      }
    }
  }

  Future<void> _saveInventory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedItems = items.map((item) => jsonEncode(item)).toList();

    await prefs.setStringList("inventory_items", savedItems);

    // ✅ Save sell prices separately
    for (var item in items) {
      await prefs.setString('sell_price_${item['name']}', item['price'].toString());
    }
  }




  void addItem(Map<String, dynamic> newItem) async {
    setState(() {
      items.add(newItem);
    });

    await _saveInventory(); // Save inventory data

    // ✅ Ensure consistent key name (price, not rate)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sell_price_${newItem['name']}', newItem['price'].toString());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Item List", style: TextStyle(fontSize: 18, color: Colors.white)),
        backgroundColor: Color(0xFFB239D3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: InventorySearch(items),
              );
            },
          ),
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
              child: Text("NEW ITEM", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text("Inventory", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Implement filter functionality
                },
                icon: Icon(Icons.filter_list, color: Colors.black, size: 18),
                label: Text("FILTER", style: TextStyle(color: Colors.black, fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ),

          SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? Center(child: Text("No items in inventory"))
                : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: items[index]['image'].startsWith('lib/images/')
                              ? Image.asset(
                            items[index]['image'],
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          )
                              : Image.file(
                            File(items[index]['image']),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),

                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index]['name'],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Current Stock: ${items[index]['stock']}",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rs ${items[index]['price']}",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 90,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModifyItemPage(item: items[index]),
                                  ),
                                );

                                if (result == true) { // If item was deleted
                                  setState(() {
                                    items.removeAt(index); // Remove item from list
                                  });
                                  _saveInventory(); // Update storage
                                } else if (result != null) { // If item was modified
                                  setState(() {
                                    items[index] = result;
                                  });
                                  _saveInventory();
                                  // ✅ Save the updated sell price in SharedPreferences
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('sell_price_${items[index]['name']}', result['price'].toString());
                                }
                              },


                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFB239D3),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                "Adjust",
                                style: TextStyle(color: Colors.white, fontSize: 12),
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

class InventorySearch extends SearchDelegate {
  final List<Map<String, dynamic>> items;

  InventorySearch(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search input
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final searchResults = items
        .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset(
            searchResults[index]['image'],
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(searchResults[index]['name']),
          subtitle: Text("Rs ${searchResults[index]['price']} - Stock: ${searchResults[index]['stock']}"),
          onTap: () {
            close(context, searchResults[index]); // Select and close search
          },
        );
      },
    );
  }
}

