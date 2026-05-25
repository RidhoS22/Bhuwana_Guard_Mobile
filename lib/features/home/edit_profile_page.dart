import 'dart:io';
import 'package:flutter/material.dart';
import 'change_password_page.dart';
// 🔥 Ganti 'nama_proyek_kamu' sesuai dengan nama package proyek tim kamu
import 'profile_language_service.dart'; // Pastikan path ini sesuai dengan struktur folder proyek kamu

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Inisialisasi Service Backend Terpadu
  final ProfileAndLanguageService _profileService = ProfileAndLanguageService();

  // Inisialisasi Controller untuk menampung data input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _selectedImage; // Menampung file gambar baru jika user mengganti foto
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDataUser(); // Ambil data asli dari Firebase saat halaman pertama kali dibuka
  }

  // Fungsi untuk menarik data dari Firestore & Auth
  void _loadDataUser() async {
    setState(() {
      _isLoading = true;
    });

    var data = await _profileService.ambilDataUser();
    if (data != null) {
      setState(() {
        _nameController.text = data['name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _emailController.text = data['email'] ?? '';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1A4336);
    const inputBorderColor = Color(0xFF1E3A34);
    const buttonColor = Color(0xFF061A12);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              child: Column(
                children: [
                  /// HEADER FOTO
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -60,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const CircleAvatar(
                                radius: 65,
                                backgroundColor: Color(0xFF7E9790),
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: Pasang ImagePicker di sini jika ingin menambahkan fitur pilih foto
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF11311C),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 90),

                  /// FORM INPUT
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Name"),
                        _buildInput(_nameController, inputBorderColor, false),

                        const SizedBox(height: 20),

                        _buildLabel("Phone number"),
                        _buildInput(_phoneController, inputBorderColor, false),

                        const SizedBox(height: 20),

                        _buildLabel("Email"),
                        _buildInput(
                          _emailController,
                          inputBorderColor,
                          true,
                        ), // Set true agar Read-Only

                        const SizedBox(height: 40),

                        /// 🔥 UPDATE BUTTON (SUDAH KONEK BACKEND)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });

                              // Mengeksekusi fungsi update data profil bagian kamu
                              bool sukses = await _profileService
                                  .updateDataProfil(
                                    namaBaru: _nameController.text,
                                    nomorHpBaru: _phoneController.text,
                                    fileGambarBaru: _selectedImage,
                                  );

                              setState(() {
                                _isLoading = false;
                              });

                              if (sukses) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Profile updated successfully",
                                    ),
                                  ),
                                );
                                Navigator.pop(
                                  context,
                                ); // Otomatis kembali ke halaman depan profil jika sukses
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to update profile"),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// 🔥 CHANGE PASSWORD BUTTON (URUSAN TEMAN TIM)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ChangePasswordPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: buttonColor,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Change Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: buttonColor,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Mengubah parameter awal menggunakan TextEditingController dan properti readOnly
  Widget _buildInput(
    TextEditingController controller,
    Color borderColor,
    bool isEmail,
  ) {
    return TextFormField(
      controller: controller,
      readOnly:
          isEmail, // Jika ini kolom email, set menjadi True agar tidak bisa diketik
      enabled:
          !isEmail, // Memberikan efek visual terkunci (agak abu-abu) pada kolom email
      style: TextStyle(
        fontSize: 16,
        color: isEmail ? Colors.black54 : Colors.black87,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1.8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: borderColor.withOpacity(0.4),
            width: 1.8,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF10B981), width: 2.2),
        ),
        filled: true,
        fillColor: isEmail
            ? Colors.grey[100]
            : Colors
                  .white, // Membedakan warna background kolom email yang terkunci
      ),
    );
  }
}
