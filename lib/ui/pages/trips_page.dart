import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_tracker/business/providers/user_session.dart';
import 'package:trip_tracker/models/trip.dart';
import '../components/trip_list.dart';
import '../components/vehicle_dropdown.dart';
import '../components/driver_dropdown.dart';
import '../../business/providers/trip_provider.dart';
import '../../business/providers/vehicle_provider.dart';
import '../../business/providers/driver_provider.dart';
import 'trip_form_page.dart';
import '../components/trip-summary-tile.dart';

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
  bool _isLoading = false;
  bool _loadedOnce = false; // 👉 to detect if user has clicked LOAD

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime.now();

    // Load dropdown data (only once)
    Future.microtask(() {
      Provider.of<VehicleProvider>(context, listen: false).loadVehicles();
      Provider.of<DriverProvider>(context, listen: false).loadDrivers();
    });
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
    // 🚨 Validation
    if (_selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a vehicle before loading trips."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _loadedOnce = true;
    });

    final fetchedTrips = await Provider.of<TripProvider>(
      context,
      listen: false,
    ).fetchTrips(
      startDate: _startDate!,
      endDate: _endDate!,
      vehicleNumber: _selectedVehicle,
      driverName: _selectedDriver,
    );

    if (!mounted) return; // ❗ avoid "setState after dispose"
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
        final totalAmount = _trips.fold(0.0, (sum, t) => sum + t.total);
        final totalBalance = _trips.fold(0.0, (sum, t) => sum + t.balance);
        final totalExpense = _trips.fold(
          0.0,
          (sum, t) => sum + Trip.calcExpense(t),
        );

        return Scaffold(
          appBar: AppBar(title: const Text("Trips")),
          body: Column(
            children: [
              // 📌 REQUIRED FILTER FIELDS
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickStartDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: "Start Date *",
                          ),
                          child: Text(
                            _startDate!.toIso8601String().split('T')[0],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: _pickEndDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: "End Date *",
                          ),
                          child: Text(
                            _endDate!.toIso8601String().split('T')[0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🚗 Vehicle + Driver selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: VehicleDropdown(
                        selectedVehicle: _selectedVehicle,
                        vehicles: vehicleProvider.vehicles,
                        showAllOption: false,
                        onChanged: (v) => setState(() => _selectedVehicle = v),
                        label: "Vehicle *",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DriverDropdown(
                        selectedDriver: _selectedDriver,
                        drivers: driverProvider.drivers,
                        showAllOption: true,
                        onChanged: (v) => setState(() => _selectedDriver = v),
                        label: "Driver (Optional)",
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed:
                      (_selectedVehicle == null)
                          ? null
                          : _fetchTrips, // disable if empty
                  child: const Text("Load Trips"),
                ),
              ),

              // 📍 Guidance Before Data Load

              // 📊 Summary ONLY when trips exist
              if (!_isLoading && _loadedOnce && _trips.isNotEmpty)
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
                        : _selectedVehicle == null
                        ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Select Date & Vehicle, then press \"Load Trips\" to view trips.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        )
                        : _trips.isEmpty
                        ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "No trips found for the duration.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        )
                        : TripList(
                          trips: _trips,
                          allowEdit: UserSession.isAdmin,
                          onEdit: (trip) async {
                            final saved = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TripFormPage(trip: trip),
                              ),
                            );
                            if (saved == true) _fetchTrips();
                          },
                        ),
              ),
            ],
          ),

          // ➕ Add Trip for Admins
          floatingActionButton:
              UserSession.isAdmin
                  ? FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () async {
                      final saved = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TripFormPage()),
                      );
                      if (saved == true) _fetchTrips();
                    },
                  )
                  : null,
        );
      },
    );
  }
}
