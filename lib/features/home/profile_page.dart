import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'language_page.dart';
import '../auth/login/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const darkGreenColor = Color(0xFF1E3A34);
    const lightGreenAccent = Color(0xFFD4E9D7);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),

            /// PROFILE
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: darkGreenColor, width: 3),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 65,
                        backgroundColor: Color(0xFFC4D6CD),
                        child: Icon(Icons.person, size: 80, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Color(0xFF37655B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Karel Septian",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Desa kertosono, Kecamatan kertoyani",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            /// MENU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: lightGreenAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    /// 🔥 EDIT PROFILE
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text("Edit Profile"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),

                    /// 🔥 LANGUAGE
                    ListTile(
                      leading: const Icon(Icons.public),
                      title: const Text("Language"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LanguagePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 LOGOUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    /// pakai pushReplacement biar ga bisa balik lagi ke home
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightGreenAccent.withOpacity(0.5),
                    foregroundColor: darkGreenColor,
                    elevation: 0,
                  ),
                  child: const Text("Logout"),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}