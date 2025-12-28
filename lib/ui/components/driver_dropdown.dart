import 'package:flutter/material.dart';
import '../../models/driver.dart';

class DriverDropdown extends StatelessWidget {
  final String? selectedDriver;
  final List<Driver> drivers;
  final ValueChanged<String?> onChanged;
  final bool showAllOption;
  final String? label;

  const DriverDropdown({
    super.key,
    required this.selectedDriver,
    required this.drivers,
    required this.onChanged,
    required this.showAllOption,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final options =
        showAllOption
            ? ["All", ...drivers.map((d) => d.name)]
            : [...drivers.map((d) => d.name)];

    return DropdownButtonFormField<String>(
      value: selectedDriver,
      decoration: InputDecoration(labelText: label ?? "Driver"),
      items:
          options
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
      onChanged: onChanged,
    );
  }
}
