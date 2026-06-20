import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../register/register_page.dart';
import '../forgot_password/forgot_password.dart';
import '../../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
  
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool isObscure = true;
  bool isLoading = false;

  final greenColor = const Color(0xFF0F3D2E);

  bool _isGoogleInit = false;

@override
  void initState() {
    super.initState();
    _ensureGoogleInit();
  }

  Future<void> _ensureGoogleInit() async {
    if (_isGoogleInit) return;
    await _googleSignIn.initialize(
      // WAJIB: isi dengan Web client ID (client_type 3) dari google-services.json
      // atau dari Firebase Console > Authentication > Sign-in method > Google
      serverClientId:
          '879775374617-ubhq5snsbrthhg4an615n5si2927k0s1.apps.googleusercontent.com',
    );
    _isGoogleInit = true;
  }

  /// =========================
  /// LOGIN EMAIL PASSWORD
  /// =========================
  Future<void> signIn() async {
    try {
      setState(() => isLoading = true);

      UserCredential userCredential =
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      /// REFRESH DATA USER
      await userCredential.user?.reload();

      /// AMBIL USER TERBARU
      User? user = FirebaseAuth.instance.currentUser;

      /// CEK VERIFIED
      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  "Email Belum Diverifikasi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: const Text(
                  "Silakan cek gmail kamu lalu verifikasi email terlebih dahulu sebelum login.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }

        return;
      }

      /// JIKA VERIFIED
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const EmergencyApp(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";

      if (e.code == 'user-not-found') {
        message = "User not found";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Text(message),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _showPhoneNumberDialog(
    DocumentReference docRef) async {
  final phoneController = TextEditingController();

  await showDialog(
    context: context,
    barrierDismissible: false, // wajib diisi dulu
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Lengkapi Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Masukkan nomor HP kamu untuk melengkapi profil.",
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Contoh: 08123456789",
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // skip
            child: const Text("Lewati"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3D2E),
            ),
            onPressed: () async {
              final phone = phoneController.text.trim();
              if (phone.isNotEmpty) {
                // Update ke Firestore
                await docRef.update({'phoneNumber': phone});
              }
              if (mounted) Navigator.pop(context);
            },
            child: const Text(
              "Simpan",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

  Future<void> signInWithGoogle() async {
  try {
    setState(() => isLoading = true);

    await _ensureGoogleInit();

    // v7: authenticate() menggantikan signIn()
    final GoogleSignInAccount googleUser =
        await _googleSignIn.authenticate();

    // v7: authentication sinkron, hanya ada idToken
    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw Exception('idToken null — cek serverClientId / SHA-1 di Firebase');
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('User tidak ditemukan setelah login');
    }

    // Simpan ke Firestore (hanya untuk user baru)
    final docRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set({
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'phoneNumber': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        await _showPhoneNumberDialog(docRef);
      }
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EmergencyApp()),
      );
    }
  } on GoogleSignInException catch (e) {
    // user menekan batal di dialog pilih akun
    if (e.code == GoogleSignInExceptionCode.canceled) return;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In error: ${e.description}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Auth Error: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 40,
            child: Transform.rotate(
              angle: 3.14,
              child: Image.asset(
                "assets/images/daun_atas.png",
                width: 140,
              ),
            ),
          ),

          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              "assets/images/daun_bawah.png",
              width: 140,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Sign In",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: greenColor,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Column(
                          children: [
                            Text(
                              "Hi, Welcome back, you’ve been missed",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: greenColor,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Container(
                              width: 220,
                              height: 1,
                              color: greenColor,
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Enter Email",
                    style:
                        TextStyle(fontFamily: "Poppins"),
                  ),

                  const SizedBox(height: 6),

                  _inputField(
                    controller: emailController,
                    hint: "Enter your email",
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Enter Password",
                    style:
                        TextStyle(fontFamily: "Poppins"),
                  ),

                  const SizedBox(height: 6),

                  _inputField(
                    controller: passwordController,
                    hint: "Enter your password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          decoration:
                              TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        padding:
                            const EdgeInsets.symmetric(
                                vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign In",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                          child:
                              Divider(color: greenColor)),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 8),
                        child: Text(
                          "or sign in with",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: greenColor,
                          ),
                        ),
                      ),
                      Expanded(
                          child:
                              Divider(color: greenColor)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// GOOGLE BUTTON
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(14),
                      onTap: signInWithGoogle,
                      child: Ink(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(
                                vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Image.network(
                              "https://cdn-icons-png.flaticon.com/512/2991/2991148.png",
                              height: 20,
                            ),

                            const SizedBox(width: 10),

                            const Text(
                                "Continue with Google"),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const RegisterPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(
                                vertical: 4),
                        child: RichText(
                          text: TextSpan(
                            text:
                                "Don’t have an account? ",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: greenColor,
                            ),
                            children: const [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText:
          isPassword ? isObscure : false,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),

        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )
            : null,

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF0F3D2E),
          ),
          borderRadius:
              BorderRadius.circular(12),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF0F3D2E),
            width: 2,
          ),
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }
}