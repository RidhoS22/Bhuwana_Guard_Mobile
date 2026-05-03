import 'package:flutter/material.dart';
import '../login/login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscureOld = true;
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
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "Change Password",
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

            /// OLD PASSWORD
            const Text(
              "Old Password",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            _passwordField(
              controller: oldPasswordController,
              obscure: obscureOld,
              onToggle: () {
                setState(() => obscureOld = !obscureOld);
              },
            ),

            const SizedBox(height: 20),

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

            const SizedBox(height: 30),

            /// 🔥 FORGOT PASSWORD BUTTON (SUDAH DIGENDUTIN)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  padding: const EdgeInsets.symmetric(vertical: 18), // 🔥 FIX
                  minimumSize: const Size.fromHeight(50), // 🔥 tambahan biar mantap
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14), // 🔥 lebih smooth
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// 🔥 CHANGE PASSWORD BUTTON (SUDAH DIGENDUTIN)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  padding: const EdgeInsets.symmetric(vertical: 18), // 🔥 FIX
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Change password",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
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

  /// 🔥 INPUT FIELD
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