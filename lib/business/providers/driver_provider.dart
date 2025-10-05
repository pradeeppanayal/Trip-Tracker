import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/driver.dart';

class DriverProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Driver> _drivers = [];

  List<Driver> get drivers => _drivers;

  Future<void> loadDrivers() async {
    final snapshot = await _db.collection('drivers').get();
    _drivers =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return Driver.fromMap({...data, 'id': doc.id});
        }).toList();
    notifyListeners();
  }

  Future<String> addDriver(Driver driver) async {
    try {
      final docRef = await _db.collection('drivers').add(driver.toMap());
      _drivers.add(
        Driver(
          id: docRef.id,
          name: driver.name,
          contact: driver.contact,
          comment: driver.comment,
        ),
      );
      notifyListeners();
      return "Driver added successfully";
    } catch (e) {
      return "Failed to add driver: $e";
    }
  }

  Future<String> updateDriver(Driver driver) async {
    try {
      if (driver.id == null) return "Driver ID missing";
      await _db.collection('drivers').doc(driver.id).update(driver.toMap());
      final index = _drivers.indexWhere((d) => d.id == driver.id);
      if (index != -1) _drivers[index] = driver;
      notifyListeners();
      return "Driver updated successfully";
    } catch (e) {
      return "Failed to update driver: $e";
    }
  }

  Future<String> deleteDriver(String id) async {
    try {
      await _db.collection('drivers').doc(id).delete();
      _drivers.removeWhere((d) => d.id == id);
      notifyListeners();
      return "Driver deleted successfully";
    } catch (e) {
      return "Failed to delete driver: $e";
    }
  }
}
