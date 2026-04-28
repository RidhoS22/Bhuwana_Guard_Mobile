import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          // 🌿 TOP RIGHT
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

          // 🌿 BOTTOM LEFT
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

                  // BACK
                  CircleAvatar(
                    backgroundColor: greenColor,
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),

                  const SizedBox(height: 40),

                  // TITLE
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

                  // EMAIL
                  const Text(
                    "Enter Email",
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                  const SizedBox(height: 6),
                  _inputField(
                    controller: emailController,
                    hint: "Enter your email",
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 20),

                  // PASSWORD
                  const Text(
                    "Enter Password",
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                  const SizedBox(height: 6),
                  _inputField(
                    controller: passwordController,
                    hint: "Enter your password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  // FORGOT
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SIGN IN BUTTON (FIXED)
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
                        "Sign In",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DIVIDER
                  Row(
                    children: [
                      Expanded(child: Divider(color: greenColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "or sign in with",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: greenColor,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: greenColor)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // GOOGLE BUTTON
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

                  const SizedBox(height: 25),

                  // SIGN UP TEXT
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don’t have an account? ",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: greenColor,
                        ),
                        children: const [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
      obscureText: isPassword ? isObscure : false,
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
          borderSide: const BorderSide(color: Color(0xFF0F3D2E)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF0F3D2E),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}