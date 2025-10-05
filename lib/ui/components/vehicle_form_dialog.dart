import 'package:flutter/material.dart';
import '../../models/vehicle.dart';

class VehicleFormDialog extends StatefulWidget {
  final Vehicle? vehicle;
  final Function(String, String) onSave;

  const VehicleFormDialog({super.key, this.vehicle, required this.onSave});

  @override
  State<VehicleFormDialog> createState() => _VehicleFormDialogState();
}

class _VehicleFormDialogState extends State<VehicleFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vehicle?.name ?? "");
    _numberController = TextEditingController(
      text: widget.vehicle?.number ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.vehicle == null ? "Add Vehicle" : "Edit Vehicle"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: _numberController,
            decoration: const InputDecoration(labelText: "Number"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_nameController.text, _numberController.text);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
