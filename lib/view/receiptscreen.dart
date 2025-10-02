import 'package:ayurvedic_centre/core/constants/app_size.dart';
import 'package:flutter/material.dart';

class ReceiptScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final String branch;
  final String payment;
  final String dateTime;
  final List<Map<String, dynamic>> treatments;
  final double total;
  final double discount;
  final double advance;
  final double balance;

  const ReceiptScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.branch,
    required this.payment,
    required this.dateTime,
    required this.treatments,
    required this.total,
    required this.discount,
    required this.advance,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: Center(
                  child: Image.asset(
                    "assets/logo.png", 
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/logo.png", height: 60),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text("CLINIC NAME",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Ayurvedic Centre",
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),

                  AppSize.kHeight10,
                  const Text("Patient Details",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                   AppSize.kHeight10,
                  _buildDetailRow("Name", name),
                  _buildDetailRow("Phone", phone),
                  _buildDetailRow("Address", address),
                  _buildDetailRow("Branch", branch),
                  _buildDetailRow("Payment", payment),
                  _buildDetailRow("Date & Time", dateTime),
                  const Divider(thickness: 1),

                  AppSize.kHeight10,
                  const Text("Treatments",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                   AppSize.kHeight10,

                  Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(2),
                    },
                    children: [
                      const TableRow(
                        
                        children: [
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Treatment",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Male",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Female",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Price",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      ...treatments.map((t) {
                        return TableRow(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(t["name"])),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text("${t["male"]}")),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text("${t["female"]}")),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text("₹${t["price"] ?? 0}")),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                   AppSize.kHeight20,

                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildAmountRow("Total Amount", total),
                        _buildAmountRow("Discount", discount),
                        _buildAmountRow("Advance", advance),
                        _buildAmountRow("Balance", balance),
                      ],
                    ),
                  ),

                  AppSize.kHeight30,
                  const Divider(),
                  const Center(
                    child: Text(
                      "Thank you for choosing us",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  static Widget _buildAmountRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text("₹${value.toStringAsFixed(2)}"),
        ],
      ),
    );
  }
}
