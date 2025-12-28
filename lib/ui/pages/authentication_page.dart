// pages/authentication_page.dart
import 'package:flutter/material.dart';
import 'package:trip_tracker/business/services/user_service.dart';
import 'package:trip_tracker/ui/pages/pin_set_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> loginUser() async {
    /// Start loading
    if (mounted) {
      setState(() {
        loading = true;
        error = null;
      });
    }

    try {
      final user = await UserService.login(email.text, password.text);
      if (user == null) throw "Login failed.";

      /// Before navigating → check if widget still alive
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PinSetPage()),
      );
      return; // stop further setState
    } catch (e) {
      if (mounted) {
        setState(() => error = e.toString());
      }
    }

    /// Finish loading when safe
    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            if (error != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : loginUser,
              child:
                  loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
            ),

            TextButton(
              onPressed: () {
                UserService.sendPasswordResetEmail(email: email.text.trim());
              },
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
