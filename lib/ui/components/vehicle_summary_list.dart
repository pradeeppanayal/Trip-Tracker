import 'package:flutter/material.dart';
import '../../models/trip.dart';
import 'vehicle_summary_card.dart';

class VehicleSummaryList extends StatelessWidget {
  final Map<String, List<Trip>> vehicleTripsMap;

  const VehicleSummaryList({super.key, required this.vehicleTripsMap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          vehicleTripsMap.entries.map((entry) {
            return VehicleSummaryCard(
              vehicleNumber: entry.key,
              trips: entry.value.cast<Trip>(),
            );
          }).toList(),
    );
  }
}
