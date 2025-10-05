import 'package:flutter/material.dart';
import '../../models/vehicle.dart';

class VehicleDropdown extends StatelessWidget {
  final String? selectedVehicle;
  final List<Vehicle> vehicles;
  final ValueChanged<String?> onChanged;
  final bool showAllOption;

  const VehicleDropdown({
    super.key,
    required this.selectedVehicle,
    required this.vehicles,
    required this.onChanged,
    required this.showAllOption,
  });

  @override
  Widget build(BuildContext context) {
    final options =
        showAllOption
            ? ["All", ...vehicles.map((v) => v.number)]
            : [...vehicles.map((v) => v.number)];
    return DropdownButtonFormField<String>(
      value: selectedVehicle,
      decoration: const InputDecoration(labelText: "Vehicle"),
      items:
          options
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
      onChanged: onChanged,
    );
  }
}
