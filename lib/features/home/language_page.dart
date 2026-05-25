import 'package:flutter/material.dart';
// 🔥 Sesuaikan nama_proyek_kamu dengan package proyek asli tim kamu
import 'profile_language_service.dart'; // Import service backend terpadu yang sudah kita buat

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    const navColor = Color(0xFF1E3A34);
    const listBgColor = Color(0xFFE2F0E5);

    // Inisialisasi Service Backend Terpadu yang kita buat kemarin
    final ProfileAndLanguageService _profileService =
        ProfileAndLanguageService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: navColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Language",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Memanggil item bahasa sekaligus melempar fungsi update ke backend
          _buildLanguageItem(context, "English", listBgColor, () async {
            await _profileService.updatePilihanBahasa('en');
            _showSuccessSnackbar(context, "Language changed to English");
          }),

          _buildLanguageItem(context, "Espanyol", listBgColor, () async {
            await _profileService.updatePilihanBahasa('es');
            _showSuccessSnackbar(context, "Idioma cambiado a Español");
          }),

          _buildLanguageItem(context, "Chinese", listBgColor, () async {
            await _profileService.updatePilihanBahasa('zh');
            _showSuccessSnackbar(context, "语言已更改为中文");
          }),

          _buildLanguageItem(context, "Indonesian", listBgColor, () async {
            await _profileService.updatePilihanBahasa('id');
            _showSuccessSnackbar(context, "Bahasa diubah ke Indonesia");
          }),
        ],
      ),
    );
  }

  // WIDGET ITEM BAHASA (Sekarang Bisa Diklik dengan Efek InkWell)
  Widget _buildLanguageItem(
    BuildContext context,
    String language,
    Color bgColor,
    VoidCallback onTapAction,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap:
              onTapAction, // Menjalankan fungsi update backend saat baris diklik
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              language,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi pembantu untuk memunculkan snackbar sukses & menutup halaman
  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
    Navigator.pop(
      context,
    ); // Otomatis balik ke halaman utama profil setelah pilih bahasa
  }
}
