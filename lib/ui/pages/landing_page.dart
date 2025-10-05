import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_tracker/ui/components/total_summary.dart';
import 'package:trip_tracker/ui/components/upcoming_trips.dart';
import '../../business/providers/trip_provider.dart';
import '../../business/providers/vehicle_provider.dart';
import '../components/vehicle_summary_list.dart';
import '../../models/trip.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _loadMonthlyTrips();
  }

  void _loadMonthlyTrips() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime.now();

    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    tripProvider.loadTrips(startDate: startDate, endDate: endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TripProvider, VehicleProvider>(
      builder: (context, tripProvider, vehicleProvider, child) {
        final trips = tripProvider.trips;
        final vehicles = vehicleProvider.vehicles;

        // Total summary values
        final totalTrips = trips.isNotEmpty ? trips.length : 0;
        final totalVehicles = vehicles.isNotEmpty ? vehicles.length : 0;
        final totalAmount =
            trips.isNotEmpty ? trips.fold(0.0, (sum, t) => sum + t.total) : 0.0;
        final totalBalance =
            trips.isNotEmpty
                ? trips.fold(0.0, (sum, t) => sum + t.balance)
                : 0.0;
        final totalExpense =
            trips.isNotEmpty
                ? trips.fold(0.0, (sum, t) => sum + Trip.calcExpense(t))
                : 0.0;

        // Map trips per vehicle
        final Map<String, List<Trip>> vehicleTripsMap = {};
        for (var v in vehicles) {
          vehicleTripsMap[v.number] =
              trips.where((t) => t.vehicleNumber == v.number).toList();
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Dashboard")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Total summary as individual color-coded boxes
                TotalSummary(
                  totalTrips: totalTrips,
                  totalAmount: totalAmount,
                  totalBalance: totalBalance,
                  totalExpense:
                      totalExpense, // make sure TotalSummary supports this
                ),

                const SizedBox(height: 16),
                Text(
                  "Vehicle Summary: $totalVehicles",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                VehicleSummaryList(vehicleTripsMap: vehicleTripsMap),
                const SizedBox(height: 16),
                const UpcomingTrips(),
              ],
            ),
          ),
        );
      },
    );
  }
}
