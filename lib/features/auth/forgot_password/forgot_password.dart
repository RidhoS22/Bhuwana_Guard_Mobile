import 'package:flutter/material.dart';
import '../login/login_page.dart';
import '../../../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final authService = AuthService();
  final emailController = TextEditingController();

  bool isLoading = false;

  final greenColor = const Color(0xFF0F3D2E);

  /// ========================================
  /// SEND PASSWORD RESET EMAIL
  /// ========================================
  Future<void> sendPasswordResetEmail() async {
    final email = emailController.text.trim().toLowerCase();

    // Validasi email kosong
    if (email.isEmpty) {
      showError('❌ Silakan masukkan email Anda');
      return;
    }

    // Validasi format email
    if (!_isValidEmail(email)) {
      showError('❌ Format email tidak valid\nContoh: user@example.com');
      return;
    }

    setState(() => isLoading = true);

    try {
      print('\n════════════════════════════════════════');
      print('🔐 PROSES FORGOT PASSWORD DIMULAI');
      print('════════════════════════════════════════');
      print('Email: $email\n');

      // Send reset password email
      // Method ini juga cek apakah email ada atau tidak
      bool emailExists = await authService.sendPasswordResetEmail(email);

      if (!emailExists) {
        print('❌ EMAIL TIDAK DITEMUKAN DI FIREBASE\n');
        if (mounted) {
          showError(
            '❌ Email Tidak Ditemukan\n\n'
            'Email: $email\n\n'
            'Email ini tidak terdaftar di sistem\n'
            'Bhuwana Guard.\n\n'
            'Silakan:\n'
            '✓ Periksa kembali email Anda\n'
            '✓ Atau buat akun baru terlebih dahulu'
          );
        }
        return;
      }

      print('✅✅ RESET EMAIL BERHASIL DIKIRIM ✅✅\n');

      if (mounted) {
        showSuccess(
          '✅ Email Reset Password Dikirim!\n\n'
          'Ke: $email\n\n'
          'Silakan lakukan:\n'
          '1️⃣ Buka email Anda\n'
          '2️⃣ Cari email dari Bhuwana Guard\n'
          '3️⃣ Klik link "Reset Password"\n'
          '4️⃣ Buat password baru Anda\n\n'
          '⏰ Link reset berlaku 1 jam'
        );

        // Kembali ke login page setelah 2 detik
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ),
            );
          }
        });
      }
    } on Exception catch (e) {
      print('❌ ERROR: ${e.toString()}');
      if (mounted) {
        String errorMsg = e.toString().replaceAll('Exception: ', '');
        showError(
          '❌ Error: $errorMsg\n\n'
          'Silakan coba lagi atau hubungi support'
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  /// ========================================
  /// VALIDASI FORMAT EMAIL
  /// ========================================
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }



  /// ========================================
  /// SHOW ERROR SNACKBAR
  /// ========================================
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// ========================================
  /// SHOW SUCCESS SNACKBAR
  /// ========================================
  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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
                builder: (_) => const LoginPage(),
              ),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: _buildEmailScreen(),
    );
  }

  /// ========================================
  /// BUILD EMAIL INPUT SCREEN
  /// ========================================
  Widget _buildEmailScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            /// ICON
            Icon(
              Icons.email_outlined,
              size: 80,
              color: greenColor,
            ),

            const SizedBox(height: 30),

            /// TITLE
            const Text(
              "Reset Password",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            /// DESCRIPTION
            const Text(
              "Masukkan email Anda dan kami akan mengirimkan link untuk mereset password",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            /// EMAIL INPUT FIELD
            TextField(
              controller: emailController,
              enabled: !isLoading,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Masukkan email Anda",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: greenColor, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: greenColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// SEND BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : sendPasswordResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Kirim Link Reset",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            /// BACK TO LOGIN
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Kembali ke ",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      color: greenColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
