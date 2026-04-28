import 'package:flutter/material.dart';
import 'features/auth/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhuwana Tech Mobile',

      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF4F4F4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F3D2E),
        ),
      ),

      // 🔥 initial route
      initialRoute: '/',

      // 🔥 routes
      routes: {
        '/': (context) => const LoginPage(),
        // nanti tambah di sini:
        // '/register': (context) => const RegisterPage(),
      },
    );
  }
}