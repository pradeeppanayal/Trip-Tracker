import 'package:flutter/material.dart';
import 'package:trip_tracker/business/providers/user_session.dart';
import 'package:trip_tracker/ui/pages/app_error_page.dart';
import 'package:trip_tracker/ui/pages/authentication_page.dart';
import 'package:trip_tracker/ui/pages/pin_check_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initializeApp();
    });
  }

  /// Handles the startup validation sequence
  Future<void> _initializeApp() async {
    // 1️⃣ Check if user logged in
    final userId = UserSession.currentUserId();
    if (userId == null) {
      return _redirect(const AuthenticationPage());
    }

    // 2️⃣ Validate user exists in DB
    final exists = await UserSession.loadUserDetails(userId);
    if (!exists && mounted) {
      return _redirect(
        const AppErrorPage(msg: "User does not exist. Contact admin."),
      );
    }

    // 3️⃣ Logged in + valid → go to PIN check
    if (mounted) {
      _redirect(const PinCheckPage());
    }
  }

  /// NAVIGATION HANDLER
  void _redirect(Widget page) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    // This acts like a splash/loading screen while checks run
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Center(child: CircularProgressIndicator(strokeWidth: 3)),
    );
  }
}
