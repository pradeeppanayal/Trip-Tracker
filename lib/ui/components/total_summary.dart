import 'package:flutter/material.dart';

class TotalSummary extends StatelessWidget {
  final int totalTrips;
  final double totalExpense;
  final double totalAmount;
  final double totalBalance;

  const TotalSummary({
    super.key,
    required this.totalTrips,
    required this.totalExpense,
    required this.totalAmount,
    required this.totalBalance,
  });

  // Format number in Indian comma system (₹1,15,600)
  String _formatIndianNumber(double value) {
    int rounded = value.round();
    String numStr = rounded.toString();
    if (numStr.length <= 3) return "₹$numStr";

    String lastThree = numStr.substring(numStr.length - 3);
    String remaining = numStr.substring(0, numStr.length - 3);

    final buffer = StringBuffer();
    int counter = 0;
    for (int i = remaining.length - 1; i >= 0; i--) {
      buffer.write(remaining[i]);
      counter++;
      if (counter == 2 && i != 0) {
        buffer.write(',');
        counter = 0;
      }
    }

    String formattedInt =
        buffer.toString().split('').reversed.join() + ',' + lastThree;
    return "₹$formattedInt";
  }

  Widget _buildTile(String label, String value, Color valueColor) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _buildTile("Trips", "$totalTrips", Colors.blue),
      _buildTile("Total", _formatIndianNumber(totalAmount), Colors.blue),
      _buildTile("Expense", _formatIndianNumber(totalExpense), Colors.red),
      _buildTile("Balance", _formatIndianNumber(totalBalance), Colors.green),
    ];

    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        children: tiles,
      ),
    );
  }
}
