import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class ProfileAndLanguageService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseStorage _storage = FirebaseStorage.instance;

  // =================================================================
  // 1. READ: AMBIL DATA PROFIL & BAHASA (Untuk Mengisi Form Saat Di-load)
  // =================================================================
  Future<Map<String, dynamic>?> ambilDataUser() async {
    try {
      String uid = _auth.currentUser!.uid;
      String emailAuth = _auth.currentUser?.email ?? "";

      // Ambil data dari Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        // Gabungkan data Firestore dengan Email dari Firebase Auth
        return {
          'name': data['name'] ?? '',
          'phone': data['phone'] ?? '',
          'photoUrl': data['photoUrl'] ?? '',
          'language': data['language'] ?? 'id', // Default 'id' jika belum diset
          'email':
              emailAuth, // Diambil dari Auth untuk ditampilkan secara Read-Only
        };
      }
      return null;
    } catch (e) {
      print("Gagal mengambil data user: $e");
      return null;
    }
  }

  // =================================================================
  // 2. UPDATE PROFIL: SIMPAN PERUBAHAN NAMA, NO HP, & FOTO PROFIL
  // =================================================================
  Future<bool> updateDataProfil({
    required String namaBaru,
    required String nomorHpBaru,
    File? fileGambarBaru, // Diisi jika user memilih foto baru dari galeri
  }) async {
    try {
      String uid = _auth.currentUser!.uid;
      String? urlFotoFinal;

      // Jika user mengganti foto, upload dulu file-nya ke Firebase Storage
      if (fileGambarBaru != null) {
        //Reference storageRef = _storage.ref().child(
          //'users_profile/$uid/avatar.jpg',
        //);
        //UploadTask uploadTask = storageRef.putFile(fileGambarBaru);
        //TaskSnapshot snapshot = await uploadTask;
        //urlFotoFinal = await snapshot.ref.getDownloadURL();
      }

      // Siapkan map data untuk dikirim ke Firestore
      Map<String, dynamic> dataUpdate = {
        'name': namaBaru,
        'phone': nomorHpBaru,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Jika ada foto baru yang berhasil di-upload, tambahkan ke map dataUpdate
      if (urlFotoFinal != null) {
        dataUpdate['photoUrl'] = urlFotoFinal;
      }

      // Jalankan perintah update ke Firestore
      await _firestore.collection('users').doc(uid).update(dataUpdate);
      print("Data profil berhasil diperbarui!");
      return true;
    } catch (e) {
      print("Gagal memperbarui profil: $e");
      return false;
    }
  }

  // =================================================================
  // 3. UPDATE BAHASA: SIMPAN PILIHAN BAHASA SAAT DIKLIK PADA DAFTAR
  // =================================================================
  Future<bool> updatePilihanBahasa(String kodeBahasa) async {
    try {
      String uid = _auth.currentUser!.uid;

      // Update field 'language' pada dokumen user di Firestore
      await _firestore.collection('users').doc(uid).update({
        'language': kodeBahasa, // Contoh input: 'en', 'es', 'zh', 'id'
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print("Preferensi bahasa di database berhasil diubah ke: $kodeBahasa");
      return true;
    } catch (e) {
      print("Gagal mengubah bahasa di database: $e");
      return false;
    }
  }
}
