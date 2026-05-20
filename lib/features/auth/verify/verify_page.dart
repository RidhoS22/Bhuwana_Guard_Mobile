import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login/login_page.dart';

class VerifyPage extends StatefulWidget {
  final String email;

  const VerifyPage({
    super.key,
    required this.email,
  });

  @override
  State<VerifyPage> createState() =>
      _VerifyPageState();
}

class _VerifyPageState
    extends State<VerifyPage> {
  final greenColor =
      const Color(0xFF0F3D2E);

  bool isLoading = false;

  void showModernSnackBar(
      String message,
      Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        behavior:
            SnackBarBehavior.floating,
        backgroundColor: color,
        margin:
            const EdgeInsets.all(20),
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),
        content: Text(message),
      ),
    );
  }

  Future<void>
      checkVerification() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance
        .currentUser
        ?.reload();

    final user =
        FirebaseAuth.instance
            .currentUser;

    if (user != null &&
        user.emailVerified) {
      showModernSnackBar(
        "Email verified successfully",
        Colors.green,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const LoginPage(),
        ),
      );
    } else {
      showModernSnackBar(
        "Please verify your email first",
        Colors.red,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void>
      resendVerification() async {
    await FirebaseAuth.instance
        .currentUser
        ?.sendEmailVerification();

    showModernSnackBar(
      "Verification email resent",
      Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F4F4),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: greenColor,
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Icon(
                Icons.mark_email_read,
                size: 90,
                color: greenColor,
              ),

              const SizedBox(height: 24),

              Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                  color: greenColor,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                "We sent a verification link to:",
                textAlign:
                    TextAlign.center,
              ),

              const SizedBox(height: 6),

              Text(
                widget.email,
                style:
                    const TextStyle(
                  color: Colors.blue,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : checkVerification,
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        greenColor,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 16,
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color:
                              Colors.white,
                        )
                      : const Text(
                          "I Have Verified",
                          style:
                              TextStyle(
                            color: Colors
                                .white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed:
                    resendVerification,
                child: const Text(
                  "Resend Email",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}