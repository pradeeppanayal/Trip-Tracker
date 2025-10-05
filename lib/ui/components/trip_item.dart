import 'package:flutter/material.dart';
import '../../models/trip.dart';

class TripItem extends StatelessWidget {
  final Trip trip;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TripItem({
    required this.trip,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("${trip.tripName} (${trip.vehicleNumber})"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer: ${trip.customer}"),
            Text("Driver: ${trip.driverName}"),
            Text("KM: ${trip.km}, Total: ₹${trip.total}"),
            if (trip.comment.isNotEmpty) Text("Note: ${trip.comment}"),
          ],
        ),
        trailing: IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
      ),
    );
  }
}
