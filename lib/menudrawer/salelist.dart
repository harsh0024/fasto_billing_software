import 'package:flutter/material.dart';

class SaleListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Sale List',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16,)
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.white)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.download),
                SizedBox(width: 5),
                Text(
                  '27/02/25 03:30:58 PM',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: 'Today',
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [DropdownMenuItem(value: 'Today', child: Text('Today'))],
              onChanged: (val) {},
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: '06/03/25',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: [DropdownMenuItem(value: '06/03/25', child: Text('06/03/25'))],
                    onChanged: (val) {},
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: '06/03/25',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: [DropdownMenuItem(value: '06/03/25', child: Text('06/03/25'))],
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: 'Rs. ',
                      prefixStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    readOnly: true,
                    initialValue: '0',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Count',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    readOnly: true,
                    initialValue: '0',
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 19),
                ),
                child: Text(
                  'NEW SALE',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}