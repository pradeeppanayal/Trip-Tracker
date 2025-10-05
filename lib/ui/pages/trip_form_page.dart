import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_tracker/business/providers/trip_provider.dart';
import '../../models/trip.dart';
import '../../business/providers/vehicle_provider.dart';
import '../../business/providers/driver_provider.dart';
import '../components/vehicle_dropdown.dart';
import '../components/driver_dropdown.dart';

class TripFormPage extends StatefulWidget {
  final Trip? trip;

  const TripFormPage({super.key, this.trip});

  @override
  State<TripFormPage> createState() => _TripFormPageState();
}

class _TripFormPageState extends State<TripFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? _vehicleNumber;
  String? _driverName;
  String? _tripName;
  String? _customer;
  double? _km;
  double? _total;
  double? _diesel;
  double? _driverCharge;
  double? _otherExpense;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _comment;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<VehicleProvider>(context, listen: false).loadVehicles();
      Provider.of<DriverProvider>(context, listen: false).loadDrivers();
    });

    if (widget.trip != null) {
      final t = widget.trip!;
      _vehicleNumber = t.vehicleNumber;
      _driverName = t.driverName;
      _tripName = t.tripName;
      _customer = t.customer;
      _km = t.km;
      _total = t.total;
      _diesel = t.diesel;
      _driverCharge = t.driverCharge;
      _otherExpense = t.otherExpense;
      _startDate = t.startDate;
      _endDate = t.endDate;
      _comment = t.comment;
    } else {
      final now = DateTime.now();
      _startDate = now;
      _endDate = now;
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final trip = Trip(
        id: widget.trip?.id,
        vehicleNumber: _vehicleNumber!,
        driverName: _driverName!,
        tripName: _tripName!,
        customer: _customer ?? "",
        km: _km ?? 0,
        total: _total ?? 0,
        diesel: _diesel ?? 0,
        driverCharge: _driverCharge ?? 0,
        otherExpense: _otherExpense ?? 0,
        startDate: _startDate!,
        endDate: _endDate!,
        comment: _comment ?? "",
      );

      final tripProvider = Provider.of<TripProvider>(context, listen: false);

      if (widget.trip == null) {
        // New Trip
        await tripProvider.addTrip(trip);
      } else {
        // Editing existing Trip
        await tripProvider.updateTrip(trip);
      }

      if (mounted) {
        Navigator.pop(
          context,
          true,
        ); // return true so TripsPage knows it was saved
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<VehicleProvider, DriverProvider>(
      builder: (context, vehicleProvider, driverProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.trip == null ? "Add Trip" : "Edit Trip"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  VehicleDropdown(
                    selectedVehicle: _vehicleNumber,
                    vehicles: vehicleProvider.vehicles,
                    showAllOption: false,
                    onChanged: (val) => setState(() => _vehicleNumber = val),
                  ),
                  const SizedBox(height: 12),
                  DriverDropdown(
                    selectedDriver: _driverName,
                    drivers: driverProvider.drivers,
                    showAllOption: false,
                    onChanged: (val) => setState(() => _driverName = val),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _tripName,
                    decoration: const InputDecoration(labelText: "Trip Name"),
                    validator:
                        (val) => val == null || val.isEmpty ? "Required" : null,
                    onSaved: (val) => _tripName = val,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _customer,
                    decoration: const InputDecoration(labelText: "Customer"),
                    onSaved: (val) => _customer = val,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDate(true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "Start Date",
                            ),
                            child: Text(
                              _startDate?.toIso8601String().split("T")[0] ?? "",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDate(false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "End Date",
                            ),
                            child: Text(
                              _endDate?.toIso8601String().split("T")[0] ?? "",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _km?.toString(),
                    decoration: const InputDecoration(labelText: "Kilometers"),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _km = double.tryParse(val ?? "0"),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _total?.toString(),
                    decoration: const InputDecoration(
                      labelText: "Total Amount",
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _total = double.tryParse(val ?? "0"),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _diesel?.toString(),
                    decoration: const InputDecoration(
                      labelText: "Diesel Expense",
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _diesel = double.tryParse(val ?? "0"),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _driverCharge?.toString(),
                    decoration: const InputDecoration(
                      labelText: "Driver Charge",
                    ),
                    keyboardType: TextInputType.number,
                    onSaved:
                        (val) => _driverCharge = double.tryParse(val ?? "0"),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _otherExpense?.toString(),
                    decoration: const InputDecoration(
                      labelText: "Other Expense",
                    ),
                    keyboardType: TextInputType.number,
                    onSaved:
                        (val) => _otherExpense = double.tryParse(val ?? "0"),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _comment,
                    decoration: const InputDecoration(labelText: "Comment"),
                    onSaved: (val) => _comment = val,
                  ),
                  const SizedBox(height: 24),

                  /// Cancel + Save at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
