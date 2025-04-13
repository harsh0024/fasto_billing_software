import 'package:fasto_billing_software/auth/signin.dart';
import 'package:fasto_billing_software/home/settings.dart';
import 'package:fasto_billing_software/home/transactions.dart';
import 'package:fasto_billing_software/menudrawer/estimatelist.dart';
import 'package:fasto_billing_software/menudrawer/expenselist.dart';
import 'package:fasto_billing_software/menudrawer/purchaselist.dart';
import 'package:fasto_billing_software/menudrawer/purchasereturn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/inventory.dart';
import '../menudrawer/moneyinlist.dart';
import '../menudrawer/moneyoutlist.dart';
import '../menudrawer/profile.dart';
import '../menudrawer/salelist.dart';
import '../menudrawer/salereturn.dart';

import 'selectitem.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? user;
  String displayName = "User";
  String emailOrPhone = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString("contactPerson");
    String? savedEmail = prefs.getString("email");

    if (firebaseUser != null) {
      setState(() {
        user = firebaseUser;
        displayName = savedName ?? user!.displayName ?? "User";
        emailOrPhone = savedEmail ?? user!.email ?? user!.phoneNumber ?? "No Email/Phone";
      });
    } else {
      setState(() {
        displayName = savedName ?? "User";
        emailOrPhone = savedEmail ?? "No Email/Phone";
      });
    }
  }


  @override
        Widget build(BuildContext context) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFB239D3),
          title: Text(
            "Dashboard",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
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

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFB239D3)),
                accountName: Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  emailOrPhone,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                currentAccountPicture: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfilePage()),
                    );

                    if (result == true) {
                      _loadUserData(); // Reload the updated data
                    }

                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard, color: Colors.black),
                title: Text("Dashboard"),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
              ),

              // Expandable Sale List
               ExpansionTile(
                leading: Icon(Icons.receipt_long, color: Colors.black),
                title: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SaleListPage()), // Your salelist.dart widget
                    );
                  },
                  child: Text("Sale List"),
                ),
                children: [
                  ListTile(
                    leading: Icon(Icons.subdirectory_arrow_right, color: Colors.grey),
                    title: Text("Sale Return"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SaleReturnPage()), // Your salereturn.dart widget
                      );
                    },
                  ),
                ],
              ),

              //  Expandable Purchase List
              ExpansionTile(
                leading: Icon(Icons.receipt_long, color: Colors.black),
                title: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PurchaseListPage()), // Your salelist.dart widget
                    );
                  },
                  child: Text("Purchase List"),
                ),
                children: [
                  ListTile(
                    leading: Icon(Icons.subdirectory_arrow_right, color: Colors.grey),
                    title: Text("Purchase Return"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PurchaseReturnPage()), // Your salereturn.dart widget
                      );
                    },
                  ),
                ],
              ),

              ListTile(
                leading: Icon(Icons.receipt, color: Colors.black),
                title: Text("Estimate List"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EstimatelistPage()),
                  );
                },
              ),


              // Money In List
              ListTile(
                leading: Icon(Icons.receipt, color: Colors.black),
                title: Text("Expense List"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExpenselistPage()),
                  );
                },
              ),

              // Money Out List
              ListTile(
                leading: Icon(Icons.currency_rupee, color: Colors.black),
                title: Text("Money Out List"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoneyOutListPage()),
                  );
                },
              ),

// Item List
              ListTile(
                leading: Icon(Icons.shopping_cart, color: Colors.black),
                title: Text("Item List"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InventoryPage()),
                  );
                },
              ),

// Settings
              ListTile(
                leading: Icon(Icons.settings, color: Colors.black),
                title: Text("Settings"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),


              //  Logout Button
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.black),
                title: const Text("Logout"),
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()), // Or use named route: '/login'
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Logout failed: ${e.toString()}")),
                    );
                  }
                },
              ),

            ],
          ),
        ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          // 👇 Your new container here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          'Cash Sale',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '13',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '|',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '05/04/25',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sale: ₹65',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'MoneyIn: ₹65',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPaymentButton('UPI/BANK', isSelected: false),
                      _buildPaymentButton('CASH', isSelected: true),
                      _buildPaymentButton('CHEQUE', isSelected: false),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Spacer(),
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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4A2A54),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 0,
        onTap: (index) async {
          if (index == 0) {
            Navigator.pushNamed(context, '/dashboard');
          } else if (index == 1) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionsPage()),
            );
          } else if (index == 2) {
            Navigator.pushNamed(context, '/inventory');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/settings');
          }
        },
        items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Transactions"),
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, IconData icon) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 5),
              Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black)),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black),
        ],
      ),
    );
  }
}
//Build payment button for CASH , CHEQUE, UPI
Widget _buildPaymentButton(String text, {required bool isSelected}) {
  return Expanded(
    child: Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.deepPurple : Colors.grey,
        ),
        color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.white,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 12,
          color: isSelected ? Colors.deepPurple : Colors.black45,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}

