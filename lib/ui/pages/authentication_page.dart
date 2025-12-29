// pages/authentication_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    if (!mounted) return;
    setState(() {
      loading = true;
      error = null;
    });

    try {
      // 🔹 Validation
      if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
        throw "Please enter both email and password.";
      }

      // 🔹 Login
      final user = await UserService.login(
        email.text.trim(),
        password.text.trim(),
      );
      if (user == null) throw "Unable to login. Please try again.";

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PinSetPage()),
      );
    } on FirebaseAuthException catch (e) {
      // 🎯 Friendly Firebase error messages
      if (mounted) {
        setState(() {
          error = "Login failed. ${e.message ?? 'Please try again.'}";
        });
      }
    } catch (e) {
      // 🔹 Other (non-Firebase) error
      if (mounted) {
        setState(() {
          error = e.toString().replaceAll("Exception:", "").trim();
        });
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
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
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            if (error != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : loginUser,
              child:
                  loading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text("Login"),
            ),

            TextButton(
              onPressed: () {
                if (email.text.trim().isEmpty) {
                  setState(() => error = "Enter your email to reset password.");
                  return;
                }
                UserService.sendPasswordResetEmail(email: email.text.trim());
                setState(
                  () => error = "Password reset link sent to your email.",
                );
              },
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
