import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DottedLine extends StatelessWidget {
  final double height;
  final Color color;

  const DottedLine({Key? key, this.height = 1, this.color = Colors.black}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();

        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

class ReceiptPage extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> selectedItems;

  const ReceiptPage({Key? key, required this.selectedItems, required this.totalAmount}) : super(key: key);

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  String _businessName = 'MAFIA';
  String _address = '123 Main Street, Mumbai';
  String _phone = '+91 98765 43210';

  @override
  void initState() {
    super.initState();
    _loadBusinessName();
  }

  Future<void> _loadBusinessName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _businessName = prefs.getString("businessName") ?? 'MAFIA';
    });
  }

  Widget _buildItemRow(String item, String qty, String rate, String total, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              item,
              style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              qty,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              rate,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              total,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateGrandTotal() {
    double sum = 0;
    for (var item in widget.selectedItems) {
      double quantity = double.tryParse(item['quantity'].toString()) ?? 0;
      double rate = double.tryParse(item['rate'].toString()) ?? 0;
      sum += quantity * rate;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Receipt',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // TODO: Implement edit functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: () {
              // TODO: Implement print functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              // TODO: Implement delete functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Business Info
                Text(
                  _businessName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(_address),
                Text('Phone: $_phone'),
                const SizedBox(height: 10),
                const DottedLine(),

                // Bill Details
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Bill No: #1234'),
                    Text('Created On: 10 Apr 2025'),
                  ],
                ),
                const SizedBox(height: 6),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Bill To: John Doe'),
                ),
                const SizedBox(height: 8),

                const DottedLine(),

                // Items Table
                const SizedBox(height: 8),
                _buildItemRow('Item', 'Qty', 'Rate', 'Total', isHeader: true),
                const Divider(),

                // Display selected items dynamically
                ...widget.selectedItems.map((item) {
                  double quantity = double.tryParse(item['quantity'].toString()) ?? 0;
                  double rate = double.tryParse(item['rate'].toString()) ?? 0;
                  double total = quantity * rate;
                  return _buildItemRow(
                    item['name'] ?? 'Unknown',
                    quantity.toString(),
                    '₹${rate.toStringAsFixed(2)}',
                    '₹${total.toStringAsFixed(2)}',
                  );
                }).toList(),

                const SizedBox(height: 9),
                const DottedLine(),
                const SizedBox(height: 9),

                // Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Items: ${widget.selectedItems.length}"),
                    Text(
                      "Total Qty: ${widget.selectedItems.fold(0, (prev, item) {
                        return prev + (double.tryParse(item['quantity'].toString()) ?? 0).toInt();
                      })}",
                    ),
                  ],
                ),

                const SizedBox(height: 7),
                const DottedLine(),

                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      // Sub Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,  // Center the row
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,  // Center the label
                              child: const Text(
                                'Sub Total:',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Align the amount to the right
                          Text(
                            '₹${_calculateGrandTotal().toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),

                      const SizedBox(height: 3),
                      const Divider(color: Colors.black),  // Divider line after Sub Total

                      const SizedBox(height: 4),  // Space between Sub Total and Total

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,  // Center the row
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,  // Center the label
                              child: const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,  // Bold "Total"
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Align the amount to the right
                          Text(
                            '₹${_calculateGrandTotal().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,  // Bold amount
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5), // Adjust the space before the line if needed
                      const Divider(color: Colors.black, ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),
                const Text("Mode of Payment: Cash",textAlign: TextAlign.left,),

                // THANK YOU MESSAGE
                const SizedBox(height: 8),
                 const Center(
                  child: Text(
                    "Thank you, visit again!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 3), // Adjust the space before the line if needed
                const Divider(color: Colors.black, ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: Colors.white38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Handle Print
                },
                child: const Text('PRINT', style: TextStyle(fontSize: 18,color:Colors.white)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.purple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Handle New Sale
                },
                child: const Text('New Sale', style: TextStyle(fontSize: 18, color: Colors.purple)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
