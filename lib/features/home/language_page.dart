import 'package:flutter/material.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    const navColor = Color(0xFF1E3A34);
    const listBgColor = Color(0xFFE2F0E5);

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
          _buildLanguageItem("English", listBgColor),
          _buildLanguageItem("Espanyol", listBgColor),
          _buildLanguageItem("Chinese", listBgColor),
          _buildLanguageItem("Indonesian", listBgColor),
        ],
      ),
    );
  }

  // WIDGET ITEM BAHASA (MIRIP SCREENSHOT)
  Widget _buildLanguageItem(String language, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8), // Sudut tumpul dikit
        ),
        child: Text(
          language,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
