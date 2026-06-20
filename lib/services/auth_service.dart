import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// ========================================
  /// SEND PASSWORD RESET EMAIL & CHECK IF EMAIL EXISTS
  /// Returns: true jika email ada dan email terkirim
  ///          false jika email tidak ada
  ///          throws exception jika error lain
  /// ========================================
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      // Validasi email format
      if (!_isValidEmail(email)) {
        throw Exception('Format email tidak valid');
      }

      final trimmedEmail = email.trim().toLowerCase();
      print('\n📧 Mengirim reset password ke: $trimmedEmail');
      
      try {
        await _firebaseAuth.sendPasswordResetEmail(email: trimmedEmail);
        
        print('✅ Email DITEMUKAN - Reset email berhasil dikirim ke $trimmedEmail');
        return true; // Email ada dan sudah dikirim ✅
        
      } on FirebaseAuthException catch (e) {
        print('⚠️ Firebase Error: ${e.code} - ${e.message}');
        
        // "user-not-found" = email TIDAK ada
        if (e.code == 'user-not-found') {
          print('❌ Email TIDAK DITEMUKAN di Firebase');
          return false; // Email tidak ada
        }
        
        // Error lain, throw exception
        String errorMsg = _handleAuthException(e);
        throw Exception(errorMsg);
      }
      
    } catch (e) {
      print('❌ Error: $e');
      throw Exception(e.toString());
    }
  }

  /// ========================================
  /// CHECK IF EMAIL EXISTS (WITHOUT SENDING)
  /// ========================================
  Future<bool> checkEmailExists(String email) async {
    try {
      // Validasi email format
      if (!_isValidEmail(email)) {
        print('❌ Format email tidak valid: $email');
        throw Exception('Format email tidak valid');
      }

      final trimmedEmail = email.trim().toLowerCase();
      print('\n🔍 Memeriksa apakah email $trimmedEmail terdaftar...');
      
      // METHOD: Login attempt dengan password dummy
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: trimmedEmail,
          password: 'check_only_12345_abc_xyz_no_login',
        );
        
        // Jika login berhasil (sangat tidak mungkin), logout dan return true
        await _firebaseAuth.signOut();
        print('✅ Email ada (login berhasil - tidak seharusnya)');
        return true;
        
      } on FirebaseAuthException catch (e) {
        print('⚠️ Login attempt error: ${e.code}');
        
        // "user-not-found" = email tidak ada
        if (e.code == 'user-not-found') {
          print('❌ Email TIDAK DITEMUKAN di Firebase');
          return false;
        }
        
        // "wrong-password" atau error lain = email ada
        if (e.code == 'wrong-password' || e.code == 'invalid-password') {
          print('✅ Email ada (password salah - email terdaftar)');
          return true;
        }
        
        // Error lain juga berarti email ada
        print('✅ Email ada (error: ${e.code})');
        return true;
      }
      
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.code}');
      throw Exception(e.message ?? 'Terjadi kesalahan saat memeriksa email');
    } catch (e) {
      print('❌ Error: $e');
      throw Exception(e.toString());
    }
  }

  /// ========================================
  /// VALIDASI FORMAT EMAIL
  /// ========================================
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  /// ========================================
  /// CONFIRM PASSWORD RESET WITH CODE
  /// ========================================
  Future<void> confirmPasswordReset(
      String code, String newPassword) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
        code: code.trim(),
        newPassword: newPassword.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// ========================================
  /// TRY LOGIN WITH NEW PASSWORD
  /// (untuk verifikasi password baru setelah reset)
  /// ========================================
  Future<bool> tryLoginWithNewPassword(
      String email, String newPassword) async {
    try {
      print('🔐 Mencoba login dengan password baru...');
      
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: newPassword.trim(),
      );
      
      print('✅ Login berhasil dengan password baru');
      return true;
    } on FirebaseAuthException catch (e) {
      print('⚠️ Login error: ${e.code}');
      
      // Password belum direset di email, atau password salah
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        return false;
      }
      
      throw _handleAuthException(e);
    }
  }


  /// ========================================
  /// HANDLE FIREBASE EXCEPTIONS
  /// ========================================
  String _handleAuthException(FirebaseAuthException e) {
    print('🔴 Firebase Auth Error: ${e.code} - ${e.message}');
    
    switch (e.code) {
      case 'user-not-found':
        return 'Email tidak terdaftar di Firebase';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Tunggu beberapa saat dan coba lagi';
      case 'operation-not-allowed':
        return 'Operasi ini tidak diizinkan. Hubungi admin';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Silakan cek koneksi Anda';
      case 'invalid-api-key':
        return 'Konfigurasi Firebase tidak valid';
      case 'app-not-authorized':
        return 'Aplikasi tidak terautentikasi dengan Firebase';
      default:
        return e.message ?? 'Terjadi kesalahan. Silakan coba lagi nanti';
    }
  }

  /// ========================================
  /// GET CURRENT USER
  /// ========================================
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// ========================================
  /// SIGN OUT
  /// ========================================
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
