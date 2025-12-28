import 'package:flutter/material.dart';
import '../../models/trip.dart';

class TripItem extends StatelessWidget {
  final Trip trip;
  final VoidCallback onEdit;
  final bool allowEdit;

  const TripItem({
    required this.trip,
    required this.onEdit,
    this.allowEdit = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        title: Text(
          "${trip.tripName} (${trip.vehicleNumber})",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer: ${trip.customer}"),
            Text("Driver: ${trip.driverName}"),
            Text("KM: ${trip.km}, Total: ₹${trip.total}"),
            if (trip.comment.isNotEmpty)
              Text(
                "Note: ${trip.comment}",
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
          ],
        ),

        // 👇 show only when allowEdit = true
        trailing:
            allowEdit
                ? IconButton(icon: const Icon(Icons.edit), onPressed: onEdit)
                : null,
      ),
    );
  }
}
