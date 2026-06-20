import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

      // 🔥 START DARI SPLASH
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(), // 🔥 splash dulu
        '/login': (context) => const LoginPage(),
      },
    );
  }
}