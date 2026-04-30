import 'package:flutter/material.dart';
import '../login/login_page.dart';
import '../verify/verify_page.dart'; // 🔥 TAMBAHAN

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isObscure = true;
  final greenColor = const Color(0xFF0F3D2E);

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
              child: Image.asset("assets/images/daun_atas.png", width: 140),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset("assets/images/daun_bawah.png", width: 140),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Create Account",
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
                              "Fill your information below or register\nwith your social account",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
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

                  const SizedBox(height: 30),

                  _label("Name"),
                  _inputField(
                      controller: nameController, hint: "Enter your name"),

                  const SizedBox(height: 16),

                  _label("Phone Number"),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(color: greenColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Text("+62")),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _inputField(
                          controller: phoneController,
                          hint: "Enter your number",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _label("Enter Email"),
                  _inputField(
                      controller: emailController,
                      hint: "Enter your email"),

                  const SizedBox(height: 16),

                  _label("Enter Password"),
                  _inputField(
                    controller: passwordController,
                    hint: "Enter your password",
                    isPassword: true,
                  ),

                  const SizedBox(height: 25),

                  /// 🔥 FIX: NAVIGASI KE VERIFY
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VerifyPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(child: Divider(color: greenColor)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("or sign in with"),
                      ),
                      Expanded(child: Divider(color: greenColor)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {},
                      child: Ink(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              "https://cdn-icons-png.flaticon.com/512/2991/2991148.png",
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            const Text("Continue with Google"),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginPage()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: greenColor),
                            children: const [
                              TextSpan(
                                text: "Sign In",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? isObscure : false,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF0F3D2E)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Color(0xFF0F3D2E), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}