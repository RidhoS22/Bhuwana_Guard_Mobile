import 'package:flutter/material.dart';
import '../login/login_page.dart';

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
          /// 🌿 TOP RIGHT
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

          /// 🌿 BOTTOM LEFT
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  /// 🔙 BACK
                  CircleAvatar(
                    backgroundColor: greenColor,
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),

                  const SizedBox(height: 30),

                  /// TITLE
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
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
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

                  const SizedBox(height: 30),

                  /// NAME
                  const Text("Name",
                      style: TextStyle(fontFamily: "Poppins")),
                  const SizedBox(height: 6),
                  _inputField(
                    controller: nameController,
                    hint: "Enter your name",
                  ),

                  const SizedBox(height: 16),

                  /// PHONE
                  const Text("Phone Number",
                      style: TextStyle(fontFamily: "Poppins")),
                  const SizedBox(height: 6),
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

                  /// EMAIL
                  const Text("Enter Email",
                      style: TextStyle(fontFamily: "Poppins")),
                  const SizedBox(height: 6),
                  _inputField(
                    controller: emailController,
                    hint: "Enter your email",
                  ),

                  const SizedBox(height: 16),

                  /// PASSWORD
                  const Text("Enter Password",
                      style: TextStyle(fontFamily: "Poppins")),
                  const SizedBox(height: 6),
                  _inputField(
                    controller: passwordController,
                    hint: "Enter your password",
                    isPassword: true,
                  ),

                  const SizedBox(height: 25),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DIVIDER
                  Row(
                    children: [
                      Expanded(child: Divider(color: greenColor)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "or sign in with",
                          style: TextStyle(fontFamily: "Poppins"),
                        ),
                      ),
                      Expanded(child: Divider(color: greenColor)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// GOOGLE
                  SizedBox(
                    width: double.infinity,
                    child: Container(
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
                          const Text(
                            "Continue with Google",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔁 BACK TO LOGIN
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginPage()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: greenColor,
                          ),
                          children: const [
                            TextSpan(
                              text: "Sign In",
                              style: TextStyle(
                                color: Colors.blue,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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