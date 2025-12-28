import 'package:flutter/material.dart';
import 'package:trip_tracker/business/services/user_service.dart';
import 'package:trip_tracker/ui/pages/home_page.dart';

class PinSetPage extends StatefulWidget {
  const PinSetPage({super.key});

  @override
  State<PinSetPage> createState() => _PinSetPageState();
}

class _PinSetPageState extends State<PinSetPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _pinConfirmController = TextEditingController();

  String errorMessage = "";
  bool _isLoading = false;

  Future<void> checkPin() async {
    final pin = _pinController.text.trim();
    final confirmPin = _pinConfirmController.text.trim();

    setState(() {
      errorMessage = "";
      _isLoading = true;
    });

    // Validation
    if (pin.isEmpty || confirmPin.isEmpty) {
      setState(() {
        errorMessage = "Please enter and confirm your PIN";
        _isLoading = false;
      });
      return;
    }

    if (pin.length < 4) {
      setState(() {
        errorMessage = "PIN must be at least 4 digits";
        _isLoading = false;
      });
      return;
    }

    if (pin != confirmPin) {
      setState(() {
        errorMessage = "PINs do not match. Please try again.";
        _isLoading = false;
      });
      return;
    }

    // Update Firebase
    final updated = await UserService.updatePin(pin);

    if (!updated) {
      setState(() {
        errorMessage = "Failed to set PIN. Please try again.";
        _isLoading = false;
      });
      return;
    }

    // Navigate to home screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              const Text(
                "Set Your PIN",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                "Secure your account with a 4-6 digit PIN",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 32),

              /// Enter PIN
              _pinInputField(controller: _pinController, label: "Enter PIN"),

              const SizedBox(height: 20),

              /// Confirm PIN
              _pinInputField(
                controller: _pinConfirmController,
                label: "Confirm PIN",
              ),

              const SizedBox(height: 28),

              /// Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : checkPin,
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
                  elevation: 2,
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text(
                          "Continue",
                          style: TextStyle(fontSize: 16),
                        ),
              ),

              const SizedBox(height: 14),

              /// Error Message
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable PIN input widget
  Widget _pinInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: Colors.grey[200],
            hintText: "******",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onSubmitted: (_) => checkPin(),
        ),
      ],
    );
  }
}
