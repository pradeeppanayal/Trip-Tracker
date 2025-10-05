import 'package:flutter/material.dart';
import '../../models/vehicle.dart';

class VehicleTile extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onEdit;

  const VehicleTile({super.key, required this.vehicle, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(vehicle.name),
        subtitle: Text(vehicle.number),
        trailing: IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
      ),
    );
  }
}
