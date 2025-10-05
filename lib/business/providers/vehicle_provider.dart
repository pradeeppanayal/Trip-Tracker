import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/vehicle.dart';
import 'package:flutter/material.dart';

class VehicleProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  Future<String> loadVehicles() async {
    try {
      final snapshot = await _db.collection('vehicles').get();
      _vehicles =
          snapshot.docs.map((doc) {
            return Vehicle.fromMap(doc.data(), doc.id);
          }).toList();
      notifyListeners();
      return "Loaded successfully";
    } catch (e) {
      return "Failed to load vehicles: $e";
    }
  }

  Future<String> addVehicle(Vehicle vehicle) async {
    try {
      final docRef = await _db.collection('vehicles').add({
        'name': vehicle.name,
        'number': vehicle.number,
      });
      vehicle.id = docRef.id; // assign the generated ID
      _vehicles.add(vehicle);
      notifyListeners();
      return "Vehicle added successfully";
    } catch (e) {
      return "Failed to add vehicle: $e";
    }
  }

  Future<String> updateVehicle(Vehicle vehicle) async {
    if (vehicle.id == null) return "Vehicle ID is null!";
    try {
      await _db.collection('vehicles').doc(vehicle.id).update({
        'name': vehicle.name,
        'number': vehicle.number,
      });
      final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
      if (index != -1) _vehicles[index] = vehicle;
      notifyListeners();
      return "Vehicle updated successfully";
    } catch (e) {
      return "Failed to update vehicle: $e";
    }
  }
}
