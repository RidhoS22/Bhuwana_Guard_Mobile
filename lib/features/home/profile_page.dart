import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_page.dart';
import 'language_page.dart';
import '../auth/login/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Mengambil UID user yang sedang login saat ini
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    const darkGreenColor = Color(0xFF1E3A34);
    const lightGreenAccent = Color(0xFFD4E9D7);

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        // 1. Menghubungkan aliran data realtime langsung ke dokumen user di Firestore
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc('DPMTzVrH2Tb1mvPVWhw4ZfVVZRC2') // 🔥 GANTI DI SINI, JAB!
            .snapshots(),
        builder: (context, snapshot) {
          // ... sisa kode builder kamu di bawahnya ...
          // Data default cadangan jika Firebase kosong atau masih loading
          String nameFromFirebase = "Karel Septian";
          String photoUrlFromFirebase = "";

          if (snapshot.hasData && snapshot.data!.exists) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            nameFromFirebase = userData['name'] ?? "Karel Septian";
            photoUrlFromFirebase = userData['photoUrl'] ?? "";
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),

                /// PROFILE (OTOMATIS SINKRON)
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
                              border: Border.all(
                                color: darkGreenColor,
                                width: 3,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: const Color(0xFFC4D6CD),
                            // 2. Jika ada photoUrl dari Firebase, pasang gambarnya. Jika tidak, pakai icon person.
                            backgroundImage: photoUrlFromFirebase.isNotEmpty
                                ? NetworkImage(photoUrlFromFirebase)
                                : null,
                            child: photoUrlFromFirebase.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.white,
                                  )
                                : null,
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
                      // 3. Nama sekarang mengambil variabel dari Firebase
                      Text(
                        nameFromFirebase,
                        style: const TextStyle(
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
                      onPressed: () async {
                        // Tambahkan proses logout dari Firebase Auth sebelum pindah halaman
                        await FirebaseAuth.instance.signOut();

                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        }
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
          );
        },
      ),
    );
  }
}
