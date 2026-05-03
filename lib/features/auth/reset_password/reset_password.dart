import 'package:flutter/material.dart';
import '../forgot_password/forgot_password.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscureNew = true;
  bool obscureConfirm = true;

  final greenColor = const Color(0xFF0F3D2E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      /// 🔥 APP BAR
      appBar: AppBar(
        backgroundColor: greenColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ForgotPasswordPage(),
              ),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "Reset Password",
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            /// TITLE
            const Text(
              "Create New Password",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Your new password must be different from previously used password.",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            /// NEW PASSWORD
            const Text(
              "New Password",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            _passwordField(
              controller: newPasswordController,
              obscure: obscureNew,
              onToggle: () {
                setState(() => obscureNew = !obscureNew);
              },
            ),

            const SizedBox(height: 20),

            /// CONFIRM PASSWORD
            const Text(
              "Confirm Password",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            _passwordField(
              controller: confirmPasswordController,
              obscure: obscureConfirm,
              onToggle: () {
                setState(() => obscureConfirm = !obscureConfirm);
              },
            ),

            const SizedBox(height: 40),

            /// 🔥 BUTTON RESET PASSWORD
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 🔥 contoh validasi sederhana
                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password tidak sama"),
                      ),
                    );
                    return;
                  }

                  // TODO: lanjut ke API / sukses screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Change Password",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 INPUT FIELD PASSWORD
  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontFamily: "Inter"),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}