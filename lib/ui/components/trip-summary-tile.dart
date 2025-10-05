import 'package:flutter/material.dart';

class TripSummaryTiles extends StatelessWidget {
  final int totalTrips;
  final double totalAmount;
  final double totalBalance;
  final double totalExpense;

  const TripSummaryTiles({
    super.key,
    required this.totalTrips,
    required this.totalAmount,
    required this.totalBalance,
    required this.totalExpense,
  });

  // Format number in Indian style with commas (e.g., 1,15,600)
  String _formatIndianNumber(double value) {
    String numStr = value.toStringAsFixed(0);
    if (numStr.length <= 3) return "₹$numStr";

    String lastThree = numStr.substring(numStr.length - 3);
    String remaining = numStr.substring(0, numStr.length - 3);

    // Add commas after every two digits in remaining part
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

    String formatted =
        buffer.toString().split('').reversed.join() + ',' + lastThree;
    return "₹$formatted";
  }

  Widget _buildTile(String label, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
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
      height: 95,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: tiles.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) => tiles[index],
        ),
      ),
    );
  }
}
