import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import 'vehicle_tile.dart';

class VehiclesList extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Function(Vehicle) onEdit;

  const VehiclesList({super.key, required this.vehicles, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    if (vehicles.isEmpty) {
      return const Center(
        child: Text(
          "No vehicle information available",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];
        return VehicleTile(vehicle: vehicle, onEdit: () => onEdit(vehicle));
      },
    );
  }
}
