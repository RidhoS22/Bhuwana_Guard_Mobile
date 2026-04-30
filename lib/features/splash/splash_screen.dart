import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/login/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // ⏳ delay 2 detik lalu ke login
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// 🔥 LOGO
            Image.asset(
              "assets/images/logo.png", // ← ganti sesuai nama logo kamu
              width: 120,
            ),

            const SizedBox(height: 20),

            /// 🔥 TEXT
            const Text(
              "BHUWANA GUARD",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F3D2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}