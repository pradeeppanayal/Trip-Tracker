import 'package:flutter/material.dart';
import '../../models/trip.dart';

class VehicleSummaryCard extends StatelessWidget {
  final String vehicleNumber;
  final List<Trip> trips;

  const VehicleSummaryCard({
    super.key,
    required this.vehicleNumber,
    required this.trips,
  });

  @override
  Widget build(BuildContext context) {
    final tripCount = trips.length;
    final totalAmount = trips.fold(0.0, (sum, t) => sum + t.total);
    final balance = trips.fold(0.0, (sum, t) => sum + t.balance);

    return Card(
      child: ListTile(
        title: Text("Vehicle: $vehicleNumber"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Trips: $tripCount"),
            Text("Total Amount: ₹${totalAmount.toStringAsFixed(2)}"),
            Text("Balance: ₹${balance.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
