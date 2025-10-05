import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business/providers/trip_provider.dart';
import '../../models/trip.dart';

class UpcomingTrips extends StatefulWidget {
  const UpcomingTrips({super.key});

  @override
  State<UpcomingTrips> createState() => _UpcomingTripsState();
}

class _UpcomingTripsState extends State<UpcomingTrips> {
  List<Trip> upcomingTrips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUpcomingTrips();
  }

  Future<void> _loadUpcomingTrips() async {
    final now = DateTime.now();
    final startDate = now.add(const Duration(days: 1));
    final endDate = now.add(const Duration(days: 10));

    final tripProvider = Provider.of<TripProvider>(context, listen: false);

    final results = await tripProvider.fetchTrips(
      startDate: startDate,
      endDate: endDate,
    );

    if (mounted) {
      setState(() {
        upcomingTrips = results;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Upcoming Trips (Next 10 days)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (upcomingTrips.isEmpty)
            const Text(
              "No upcoming trips",
              style: TextStyle(color: Colors.grey),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingTrips.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final trip = upcomingTrips[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(trip.tripName),
                    subtitle: Text(
                      "${trip.vehicleNumber} • ${trip.driverName} • ${trip.startDate.toIso8601String().split('T')[0]}",
                    ),
                    trailing: Text("₹${trip.total.toStringAsFixed(2)}"),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
