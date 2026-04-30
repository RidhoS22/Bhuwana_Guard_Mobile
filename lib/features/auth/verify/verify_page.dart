import 'package:flutter/material.dart';
import '../register/register_page.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(4, (_) => FocusNode());

  final greenColor = const Color(0xFF0F3D2E);

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        children: [
          /// 🌿 TOP RIGHT
          Positioned(
            right: 0,
            top: 40,
            child: Transform.rotate(
              angle: 3.14,
              child: Image.asset("assets/images/daun_atas.png", width: 140),
            ),
          ),

          /// 🌿 BOTTOM LEFT
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset("assets/images/daun_bawah.png", width: 140),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// 🔙 BACK BUTTON
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: greenColor,
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// TITLE
                  Text(
                    "Verify Code",
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
                      const Text(
                        "Please enter the code we just sent to email",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "@email@gmail.com",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(width: 220, height: 1, color: greenColor),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// 🔥 OTP BOXES (FIXED CENTER + AUTO MOVE)
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

                            /// 🔥 AUTO PINDAH
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
                      const Text("Didn’t receive OTP?"),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Resend code"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// VERIFY BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String otp = controllers
                            .map((c) => c.text)
                            .join();

                        debugPrint("OTP: $otp");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Verify",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}