import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/trip.dart';

class TripProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Trip> _trips = [];

  List<Trip> get trips => _trips;

  Future<List<Trip>> fetchTrips({
    required DateTime startDate,
    required DateTime endDate,
    String? vehicleNumber,
    String? driverName,
  }) async {
    // Normalize dates to ignore time
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    Query query = _db
        .collection('trips')
        .where('startDate', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('startDate', isLessThanOrEqualTo: end.toIso8601String());

    final snapshot = await query.get();
    var trips =
        snapshot.docs
            .map(
              (doc) => Trip.fromMap(doc.data() as Map<String, dynamic>, doc.id),
            )
            .toList();
    if (vehicleNumber != null && vehicleNumber != "All") {
      trips =
          trips.where((trip) => trip.vehicleNumber == vehicleNumber).toList();
    }
    if (driverName != null && driverName != "All") {
      trips = trips.where((trip) => trip.driverName == driverName).toList();
    }
    return trips;
  }

  /// Load trips for a date range and optional vehicle
  Future<String> loadTrips({
    required DateTime startDate,
    required DateTime endDate,
    String? vehicleNumber,
    String? driverName,
  }) async {
    try {
      _trips = await fetchTrips(
        startDate: startDate,
        endDate: endDate,
        vehicleNumber: vehicleNumber,
        driverName: driverName,
      );
      notifyListeners();
      return "Trips loaded successfully";
    } catch (e) {
      print("Failed to load trips: $e");
      return "Failed to load trips: $e";
    }
  }

  Future<String> addTrip(Trip trip) async {
    try {
      final docRef = await _db.collection('trips').add(trip.toMap());
      return "Trip added successfully";
    } catch (e) {
      return "Failed to add trip: $e";
    }
  }

  Future<String> updateTrip(Trip trip) async {
    if (trip.id == null) return "Trip ID is null!";
    try {
      await _db.collection('trips').doc(trip.id).update(trip.toMap());
      return "Trip updated successfully";
    } catch (e) {
      return "Failed to update trip: $e";
    }
  }
}
