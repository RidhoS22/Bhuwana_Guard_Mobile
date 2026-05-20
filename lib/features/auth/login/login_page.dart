import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  bool isObscure = true;
  bool isLoading = false;

  final greenColor = const Color(0xFF0F3D2E);

  /// =========================
  /// LOGIN EMAIL PASSWORD
  /// =========================
  Future<void> signIn() async {
    try {
      setState(() => isLoading = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

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
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      setState(() => isLoading = true);

      final GoogleSignIn googleSignIn =
          GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser =
          await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const EmergencyApp(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Google Sign In Failed"),
        ),
      );
    } finally {
      setState(() => isLoading = false);
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