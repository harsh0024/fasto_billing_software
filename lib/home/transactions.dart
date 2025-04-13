import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
          title: Text(
            'Transactions',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.refresh, color: Colors.white)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.white)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                //color: Colors.grey[50], // Light grey background
                border: Border.all(color: Colors.black45), // Outline border
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Transaction List',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'FILTER',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              items: [DropdownMenuItem(value: 'Filter', child: Text('Today', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))],
              onChanged: (val) {},
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _transactionCard('7559349889', '7559349889', 'REGULAR'),
                  _transactionCard('Cash Sale', 'Phone Unavailable', 'REGULAR'),
                  _transactionCard('Cash Sale', 'Phone Unavailable', 'REGULAR'),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                child: Text(
                  'ADD CUSTOMER +',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionCard(String name, String phone, String billingType) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black87, width: 1),
      ),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Phone: $phone\nBilling Type: $billingType'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone, color: Colors.green),
            SizedBox(width: 10),
            Icon(Icons.star_border, color: Colors.amber),
          ],
        ),
      ),
    );
  }
}
