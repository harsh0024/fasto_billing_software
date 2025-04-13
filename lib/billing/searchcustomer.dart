import 'package:fasto_billing_software/billing/receipt.dart';
import 'package:flutter/material.dart';

class SearchCustomerPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final int totalAmount;

  const SearchCustomerPage({
    Key? key,
    required this.totalAmount,
    required this.selectedItems,
  }) : super(key: key);

  @override
  _SearchCustomerPageState createState() => _SearchCustomerPageState();
}

class _SearchCustomerPageState extends State<SearchCustomerPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController billingAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customer",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade800, Colors.purple.shade400], // Gradient background
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Phone Number", phoneController, keyboardType: TextInputType.phone),
            _buildTextField("Customer/ Supplier Name", nameController),
            _buildTextField("Billing Address", billingAddressController),
            const SizedBox(height: 15),
            _buildOptionalButton("ADDRESS (OPTIONAL)", Icons.location_on, () {}),
            const SizedBox(height: 10),
            _buildOptionalButton("GST AND OTHER (OPTIONAL)", Icons.receipt_long, () {}),
            const Spacer(),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // Background color
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            children: [
              // DETAILS Button
              Expanded(
                flex: 2, // Reduce width
                child: _buildNavButton("DETAILS", Colors.black54, Colors.white, () {}),
              ),
              const SizedBox(width: 3),
              // KOT Button
              Expanded(
                flex: 2, // Reduce width
                child: _buildNavButton("KOT", Colors.black54, Colors.white, () {}),
              ),
              const SizedBox(width: 10), // Space between KOT and SAVE button

              // SAVE Button with Total Amount
              Expanded(
                flex: 4, // Wider button
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
                      // Navigate to ReceiptPage and pass selectedItems and totalAmount
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptPage(
                            totalAmount: widget.totalAmount.toDouble(),
                            selectedItems: widget.selectedItems, // Pass selectedItems to ReceiptPage
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "SAVE [ Rs. ${widget.totalAmount} ]",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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

  // Custom Input Box
  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 2)],
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // Optional Button
  Widget _buildOptionalButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.deepPurple, size: 18),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Navigation Bar Button
  Widget _buildNavButton(String text, Color textColor, Color bgColor, VoidCallback onTap) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(5),
        color: bgColor,
      ),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10, // Adjusted text size
            color: textColor,
          ),
        ),
      ),
    );
  }
}
