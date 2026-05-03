import 'package:flutter/material.dart';
import '../login/login_page.dart';
import '../reset_password/reset_password.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(4, (_) => FocusNode());

  final greenColor = const Color(0xFF0F3D2E);

  void handleInput(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      /// 🔥 APP BAR
      appBar: AppBar(
        backgroundColor: greenColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [

              const SizedBox(height: 20),

              /// TEXT
              const Text(
                "Please enter the code we just sent to email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "@email@gmail.com",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 13,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 30),

              /// OTP BOXES
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: SizedBox(
                          width: 60,
                          child: TextField(
                            controller: controllers[index],
                            focusNode: focusNodes[index],
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            keyboardType: TextInputType.number,

                            /// AUTO PINDAH
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                if (index < 3) {
                                  focusNodes[index + 1].requestFocus();
                                } else {
                                  focusNodes[index].unfocus();
                                }
                              } else {
                                if (index > 0) {
                                  focusNodes[index - 1].requestFocus();
                                }
                              }
                            },

                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: greenColor, width: 1.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: greenColor, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

              const SizedBox(height: 20),

              /// RESEND
              Column(
                children: [
                  const Text(
                    "Didn't receive OTP?",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Resend code",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 12,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40), // 🔥 GANTI SPACER JADI INI

              /// VERIFY BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResetPasswordPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}