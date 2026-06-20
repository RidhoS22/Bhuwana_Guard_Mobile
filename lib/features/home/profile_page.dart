import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_page.dart';
import 'language_page.dart';
import '../auth/login/login_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  String lokasiTampil = 'Mengambil lokasi...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  File? _imageFile;

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      final uid = FirebaseAuth.instance.currentUser!.uid;

      final file = File(pickedFile.path);

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uid.jpg');

      await ref.putFile(file);

      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'photoUrl': imageUrl,
      });

      print("UPLOAD SUCCESS: $imageUrl");

      setState(() {});
    } catch (e) {
      print("UPLOAD ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkGreenColor = Color(0xFF1E3A34);
    const lightGreenAccent = Color(0xFFD4E9D7);

    // Antisipasi jika user ternyata belum login atau session habis
    if (_currentUid.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("User tidak ditemukan, silakan login kembali."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUid)
            .snapshots(),
        builder: (context, snapshot) {
          String namaTampil = 'Memuat nama...';
          String fotoTampil = '';

          if (snapshot.hasData && snapshot.data!.exists) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;

            namaTampil = userData['name'] ?? 'Pengguna Bhuwana';
            fotoTampil = userData['photoUrl'] ?? '';
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),

                /// PROFILE HEADER (SINKRON REAL-TIME)
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
                            // Jika fotoTampil ada isinya, muat dari internet. Jika kosong, tampilkan icon orang.
                            backgroundImage: fotoTampil.isNotEmpty
                                ? NetworkImage(fotoTampil)
                                : null,
                            child: fotoTampil.isEmpty
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
                              child: GestureDetector(
                                onTap: _pickAndUploadImage,
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Menampilkan nama asli real-time dari Firebase
                      Text(
                        namaTampil,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Menampilkan lokasi asli real-time dari Firebase
                      Text(
                        lokasiTampil,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                /// PANEL MENU UTAMA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: lightGreenAccent.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        /// 👤 EDIT PROFILE
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

                        /// 🌐 LANGUAGE
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

                /// 🚪 BUTTON LOGOUT
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Proses keluar dari Firebase Auth
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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        lokasiTampil = 'GPS tidak aktif';
      });
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      setState(() {
        lokasiTampil = 'Izin lokasi ditolak';
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        lokasiTampil = 'Izin lokasi permanen ditolak';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      setState(() {
        lokasiTampil =
            "${place.subAdministrativeArea ?? ''}, ${place.administrativeArea ?? ''}";
      });
    }
  }
}
