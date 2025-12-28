import 'package:flutter/material.dart';
import 'package:trip_tracker/business/providers/user_session.dart';
import 'package:trip_tracker/business/services/user_service.dart';
import 'package:trip_tracker/ui/pages/home_page.dart';
import 'package:trip_tracker/ui/pages/main_page.dart'; // <-- Make sure MainPage is imported

class PinCheckPage extends StatefulWidget {
  const PinCheckPage({super.key});

  @override
  State<PinCheckPage> createState() => _PinCheckPageState();
}

class _PinCheckPageState extends State<PinCheckPage> {
  final TextEditingController _pinController = TextEditingController();
  String errorMessage = "";

  void checkPin() {
    String pin = _pinController.text.trim();
    setState(() => errorMessage = "");

    if (pin.isEmpty) {
      setState(() => errorMessage = "Please enter your PIN");
      return;
    }

    if (UserSession.isPinMatch(pin)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      return;
    }

    setState(() => errorMessage = "Incorrect PIN. Please try again.");
  }

  Future<void> logout() async {
    await UserService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Page Title
              const Text(
                "Enter Your PIN",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 20),

              /// PIN Input
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "******",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (_) => checkPin(),
              ),

              const SizedBox(height: 20),

              /// Continue Button
              ElevatedButton(
                onPressed: checkPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Continue", style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 16),

              /// Error Message
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              const SizedBox(height: 28),

              /// LOGOUT BUTTON
              TextButton(
                onPressed: logout,
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
