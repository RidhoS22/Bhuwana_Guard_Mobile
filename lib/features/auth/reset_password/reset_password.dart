import 'package:flutter/material.dart';
import '../forgot_password/forgot_password.dart';
import '../login/login_page.dart';
import '../../../services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({
    super.key,
    this.email = '',
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final authService = AuthService();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscureNew = true;
  bool obscureConfirm = true;
  bool isLoading = false;

  final greenColor = const Color(0xFF0F3D2E);

  /// VALIDATE PASSWORD
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }
    if (!_isStrongPassword(password)) {
      return 'Password harus mengandung huruf besar, huruf kecil, dan angka';
    }
    return null;
  }

  /// CHECK PASSWORD STRENGTH
  bool _isStrongPassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    return hasUppercase && hasLowercase && hasDigits;
  }

  /// RESET PASSWORD
  Future<void> resetPassword() async {
    String? newPassError = validatePassword(newPasswordController.text);
    if (newPassError != null) {
      showError(newPassError);
      return;
    }

    String? confirmPassError = validatePassword(confirmPasswordController.text);
    if (confirmPassError != null) {
      showError(confirmPassError);
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      showError('❌ Password tidak cocok');
      return;
    }

    setState(() => isLoading = true);

    try {
      if (widget.email.isNotEmpty) {
        bool loginSuccess = await authService.tryLoginWithNewPassword(
          widget.email,
          newPasswordController.text,
        );

        if (loginSuccess && mounted) {
          showSuccess('✅ Password berhasil direset!');
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        } else if (mounted) {
          showError('❌ Gagal. Silakan coba reset password lagi di email.');
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
            );
          }
        }
      } else {
        showError('❌ Email tidak ditemukan');
      }
    } catch (e) {
      if (mounted) {
        showError('❌ Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: greenColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Icon(Icons.lock_outline, size: 80, color: greenColor),
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "Password Baru",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Masukkan password baru yang kuat untuk melindungi akun Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: const Text(
                  "💡 Password harus:\n• Min 6 karakter\n• Huruf besar (A-Z)\n• Huruf kecil (a-z)\n• Angka (0-9)",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 12,
                    color: Colors.blue,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: newPasswordController,
                enabled: !isLoading,
                obscureText: obscureNew,
                decoration: InputDecoration(
                  hintText: "Password Baru",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => obscureNew = !obscureNew),
                  ),
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
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                enabled: !isLoading,
                obscureText: obscureConfirm,
                decoration: InputDecoration(
                  hintText: "Konfirmasi Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => obscureConfirm = !obscureConfirm),
                  ),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : resetPassword,
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
                          "Reset Password",
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
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.grey, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Kembali",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 13,
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
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
