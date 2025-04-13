import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillItemPage extends StatefulWidget {
  final String initialSellPrice;
  final int itemIndex;

  BillItemPage({required this.initialSellPrice, required this.itemIndex});

  @override
  _BillItemPageState createState() => _BillItemPageState();
}

class _BillItemPageState extends State<BillItemPage> {
  late TextEditingController sellPriceController;
  late TextEditingController quantityController;
  late TextEditingController finalPriceController;
  late TextEditingController discountController;
  late TextEditingController discountAmountController;
  late TextEditingController billNoteController;
  late TextEditingController kotNoteController;

  String selectedUnit = "BAG";

  @override
  void initState() {
    super.initState();
    sellPriceController = TextEditingController();
    quantityController = TextEditingController(text: "1");
    finalPriceController = TextEditingController();
    discountController = TextEditingController();
    discountAmountController = TextEditingController();
    billNoteController = TextEditingController();
    kotNoteController = TextEditingController();
    _loadSellPrice();
  }

  Future<void> _loadSellPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPrice = prefs.getString('sell_price_${widget.itemIndex}');
    setState(() {
      sellPriceController.text = storedPrice ?? widget.initialSellPrice;
      _calculateFinalPrice();
    });
  }

  Future<void> _saveSellPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sell_price_${widget.itemIndex}', sellPriceController.text);
  }

  void _calculateFinalPrice() {
    int qty = int.tryParse(quantityController.text) ?? 1;
    double sellPrice = double.tryParse(sellPriceController.text) ?? 0;
    double discount = double.tryParse(discountController.text) ?? 0;

    double finalPrice = qty * sellPrice;
    double discountAmount = (finalPrice * discount) / 100;

    discountAmountController.text = discountAmount.toStringAsFixed(2);
    finalPriceController.text = (finalPrice - discountAmount).toStringAsFixed(2);
  }

  void _saveAndExit() async {
    await _saveSellPrice();
    Navigator.pop(context, sellPriceController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Bill Item", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _saveAndExit,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sellPriceController,
                      decoration: InputDecoration(labelText: "Sell Price", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateFinalPrice(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedUnit,
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Price Unit"),
                      items: ["BAG", "KG", "PCS"].map((String unit) {
                        return DropdownMenuItem(value: unit, child: Text(unit));
                      }).toList(),
                      onChanged: (value) => setState(() => selectedUnit = value!),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: "Quantity *", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateFinalPrice(),
              ),
              SizedBox(height: 10),
              TextField(
                controller: finalPriceController,
                decoration: InputDecoration(labelText: "Final Price", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: discountController,
                      decoration: InputDecoration(labelText: "Discount %", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateFinalPrice(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: discountAmountController,
                      decoration: InputDecoration(labelText: "Discount Amount", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: billNoteController,
                decoration: InputDecoration(
                  labelText: "Bill Note",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.mic, color: Colors.grey),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: kotNoteController,
                decoration: InputDecoration(labelText: "Kot Note", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: _saveAndExit,
                  child: Text("SAVE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
