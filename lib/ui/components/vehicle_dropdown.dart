import 'package:flutter/material.dart';
import '../../models/vehicle.dart';

class VehicleDropdown extends StatelessWidget {
  final String? selectedVehicle;
  final List<Vehicle> vehicles;
  final ValueChanged<String?> onChanged;
  final bool showAllOption;
  final String? label;

  const VehicleDropdown({
    super.key,
    required this.selectedVehicle,
    required this.vehicles,
    required this.onChanged,
    required this.showAllOption,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final options =
        showAllOption && vehicles.isNotEmpty
            ? ["All", ...vehicles.map((v) => v.number)]
            : [...vehicles.map((v) => v.number)];
    final textLabel = label ?? "Vehicle";
    return DropdownButtonFormField<String>(
      value: selectedVehicle,
      decoration: InputDecoration(labelText: textLabel),
      items:
          options
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
      onChanged: onChanged,
    );
  }
}
