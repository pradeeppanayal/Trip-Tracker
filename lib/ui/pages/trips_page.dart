import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_tracker/models/trip.dart';
import 'package:trip_tracker/ui/components/trip-summary-tile.dart';
import '../../business/providers/trip_provider.dart';
import '../../business/providers/vehicle_provider.dart';
import '../../business/providers/driver_provider.dart';
import '../components/trip_list.dart';
import '../components/vehicle_dropdown.dart';
import '../components/driver_dropdown.dart';
import 'trip_form_page.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedVehicle;
  String? _selectedDriver;

  List<Trip> _trips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime.now();

    Provider.of<VehicleProvider>(context, listen: false).loadVehicles();
    Provider.of<DriverProvider>(context, listen: false).loadDrivers();

    _fetchTrips();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _fetchTrips() async {
    if (_startDate == null || _endDate == null) return;
    setState(() => _isLoading = true);

    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final fetchedTrips = await tripProvider.fetchTrips(
      startDate: _startDate!,
      endDate: _endDate!,
      vehicleNumber: _selectedVehicle,
      driverName: _selectedDriver,
    );

    setState(() {
      _trips = fetchedTrips;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<VehicleProvider, DriverProvider>(
      builder: (context, vehicleProvider, driverProvider, child) {
        final totalTrips = _trips.length;
        final totalAmount = _trips.fold<double>(0, (sum, t) => sum + t.total);
        final totalBalance = _trips.fold<double>(
          0,
          (sum, t) => sum + t.balance,
        );
        final totalExpense = _trips.fold<double>(
          0,
          (sum, t) => sum + Trip.calcExpense(t),
        );

        return Scaffold(
          appBar: AppBar(title: const Text("Trips")),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickStartDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: "Start"),
                          child: Text(
                            _startDate != null
                                ? _startDate!.toIso8601String().split('T')[0]
                                : "",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: _pickEndDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: "End"),
                          child: Text(
                            _endDate != null
                                ? _endDate!.toIso8601String().split('T')[0]
                                : "",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: VehicleDropdown(
                        selectedVehicle: _selectedVehicle,
                        vehicles: vehicleProvider.vehicles,
                        showAllOption: true,
                        onChanged:
                            (val) => setState(() => _selectedVehicle = val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DriverDropdown(
                        selectedDriver: _selectedDriver,
                        drivers: driverProvider.drivers,
                        showAllOption: true,
                        onChanged:
                            (val) => setState(() => _selectedDriver = val),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: _fetchTrips,
                  child: const Text("Load"),
                ),
              ),
              TripSummaryTiles(
                totalTrips: totalTrips,
                totalAmount: totalAmount,
                totalBalance: totalBalance,
                totalExpense: totalExpense,
              ),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : TripList(
                          trips: _trips,
                          onEdit: (trip) async {
                            final saved = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TripFormPage(trip: trip),
                              ),
                            );
                            if (saved == true) {
                              _fetchTrips(); // reload trips after editing
                            }
                          },
                          onDelete: (trip) async {},
                        ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              final saved = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TripFormPage()),
              );
              if (saved == true) {
                _fetchTrips(); // reload trips after adding
              }
            },
          ),
        );
      },
    );
  }
}
