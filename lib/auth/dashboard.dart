import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selectitem.dart';



class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  //  Added a GlobalKey to control the Scaffold and open the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, //  Assigned key to Scaffold for controlling drawer
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB239D3), // Dark purple
        title: Text(
          "Dashboard",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); //  Opens drawer when menu button is clicked
          },
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),

      //  Added a Menu Drawer with Profile & Expandable Sections
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //  Updated Header with Profile Info
             const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFB239D3)), // Purple background
              accountName: Text(
                "WELCOME",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                "7559343569",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.grey),
              ),
            ),

            //  Dashboard
            ListTile(
              leading: Icon(Icons.dashboard, color: Colors.black),
              title: Text("Dashboard"),
              onTap: () {},
            ),

            //  Expandable Sale List
            ExpansionTile(
              leading: Icon(Icons.receipt_long, color: Colors.black),
              title: Text("Sale List"),
              children: [
                ListTile(
                  leading: Icon(Icons.subdirectory_arrow_right, color: Colors.grey),
                  title: Text("Sale Return"),
                  onTap: () {},
                ),
              ],
            ),

            //  Expandable Purchase List
            ExpansionTile(
              leading: Icon(Icons.shopping_cart, color: Colors.black),
              title: Text("Purchase List"),
              children: [
                ListTile(
                  leading: Icon(Icons.subdirectory_arrow_right, color: Colors.grey),
                  title: Text("Purchase Return"),
                  onTap: () {},
                ),
              ],
            ),
            const ListTile(
              leading: Icon(Icons.receipt_long, color: Colors.black),
              title: Text("Estimate List"),
            ),

            const ListTile(
              leading: Icon(Icons.receipt_long, color: Colors.black),
              title: Text("Expense List"),
            ),

            ListTile(
              leading: Icon(Icons.currency_rupee_sharp, color: Colors.black),
              title: Text("Money in List"),
            ),

            ListTile(
              leading: Icon(Icons.currency_rupee, color: Colors.black),
              title: Text("Money Out List"),
            ),

            ListTile(
              leading: Icon(Icons.shopping_cart, color: Colors.black),
              title: Text("Item List"),
            ),


            //  Settings
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text("Settings"),
              onTap: () {},
            ),

            //  Logout Button
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Added a scrollable card section for Reports, Sales, and Expenses
          Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCard("Reports", "Check Reports", Icons.assignment),
                  _buildCard("Sale(TDY)", "Rs 380", Icons.money),
                  _buildCard("Expenses", "Rs 150", Icons.trending_down),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          //  Added Recent Transactions Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Recent Transactions",
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),

          const Spacer(),

          //  Added a BILL / INVOICE Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectItemPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB239D3),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              ),

              child: const Text(
                "BILL / INVOICE",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),

      //  Added a Bottom Navigation Bar
      // Inside DashboardPage class...
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4A2A54), // Dark purple highlight
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 0, // Set to track active tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/dashboard'); // Dashboard
          } else if (index == 1) {
            Navigator.pushNamed(context, '/inventory'); // Inventory Page (section.dart)
          } else if (index == 2) {
            Navigator.pushNamed(context, '/history'); // History Page (history.dart)
          } else if (index == 3) {
            Navigator.pushNamed(context, '/settings'); // Settings Page (settings.dart)
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),

    );
  }

  // ✅ Created a reusable Card widget for Reports, Sales, and Expenses
  Widget _buildCard(String title, String subtitle, IconData icon) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.black, width: 1), // Black border
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios, // Arrow icon on the right
            size: 12,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

