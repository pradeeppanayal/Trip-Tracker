import 'package:flutter/material.dart';
import '../../models/trip.dart';
import 'trip_item.dart';

class TripList extends StatelessWidget {
  final List<Trip> trips;
  final Function(Trip) onEdit;
  final bool allowEdit;
  const TripList({
    required this.trips,
    required this.onEdit,
    required this.allowEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return const Center(
        child: Text(
          "No trips found for selected filter",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return TripItem(
          trip: trip,
          onEdit: () => onEdit(trip),
          allowEdit: allowEdit,
        );
      },
    );
  }
}
