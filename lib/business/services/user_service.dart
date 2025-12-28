// services/user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:trip_tracker/business/providers/user_session.dart';

class UserService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  /// ✉ Email / Password Login Only (no sign-up allowed)
  static Future<User?> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return cred.user;
  }

  /// 🔥 Fetch user access details from Firestore
  static Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  /// 🚪 Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  static void sendPasswordResetEmail({required String email}) {
    _auth.sendPasswordResetEmail(email: email);
  }

  static Future<bool> updatePin(String pin) async {
    String? uid = UserSession.currentUserId();
    if (uid == null) return false; // prevent crash

    final doc = _db.collection("users").doc(uid);

    try {
      await doc.update({"pin": pin}); // update only the field needed
      return true;
    } catch (e) {
      print("Error updating PIN: $e");
      return false;
    }
  }
}
