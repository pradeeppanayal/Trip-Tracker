import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip_tracker/models/vehicle.dart';
// session/user_session.dart
import '../services/user_service.dart';

class UserSession {
  static String phone = "";
  static String role = "user";
  static String pin = "";
  static List<String> allottedVehicles = [];

  static bool get isAdmin => role == "admin";

  /// 🔄 Loads user details using the service layer
  static Future<bool> loadUserDetails(String uid) async {
    final data = await UserService.getUserDetails(uid);
    if (data == null) return false;

    phone = data['phone'] ?? "";
    role = data['role'] ?? "user";
    pin = data['pin'] ?? "";
    allottedVehicles = List<String>.from(data['allowedVehicleNumbers'] ?? []);
    return true;
  }

  static void clear() {
    phone = "";
    role = "user";
    allottedVehicles = [];
  }

  static String? currentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  static bool isPinMatch(String pinToCheck) {
    return pin == pinToCheck;
  }
}
