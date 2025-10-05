import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business/providers/vehicle_provider.dart';
import '../../models/vehicle.dart';
import '../components/vehicles_list.dart';
import '../components/vehicle_form_dialog.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<VehicleProvider>(context, listen: false).loadVehicles();
  }

  void _showVehicleForm([Vehicle? vehicle]) {
    showDialog(
      context: context,
      builder:
          (_) => VehicleFormDialog(
            vehicle: vehicle,
            onSave: (name, number) async {
              final provider = Provider.of<VehicleProvider>(
                context,
                listen: false,
              );
              String status = "";

              if (vehicle == null) {
                status = await provider.addVehicle(
                  Vehicle(name: name, number: number),
                );
              } else {
                status = await provider.updateVehicle(
                  Vehicle(id: vehicle.id, name: name, number: number),
                );
              }

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(status)));
              if (status.contains("successfully")) Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, provider, child) {
        final vehicles = provider.vehicles;
        return Scaffold(
          appBar: AppBar(title: const Text("Vehicles")),
          body: VehiclesList(vehicles: vehicles, onEdit: _showVehicleForm),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => _showVehicleForm(),
          ),
        );
      },
    );
  }
}
