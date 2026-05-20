import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  final FocusNode _oldPassFocus = FocusNode();
  final FocusNode _newPassFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();

  bool _oldPassVisible = false;
  bool _newPassVisible = false;
  bool _confirmPassVisible = false;

  bool get _isButtonActive =>
      _oldPassController.text.isNotEmpty &&
      _newPassController.text.length >= 8 &&
      (_newPassController.text == _confirmPassController.text);

  @override
  void initState() {
    super.initState();
    _oldPassController.addListener(() => setState(() {}));
    _newPassController.addListener(() => setState(() {}));
    _confirmPassController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    _oldPassFocus.dispose();
    _newPassFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  void _showSuccessDialog(Color themeColor) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: themeColor,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your password has been changed successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF1A4336);
    const focusGreen = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Change Password",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [const SizedBox(width: 48)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            _buildLabel("Old Password", darkGreen),
            _buildTextField(
              "Enter old password",
              _oldPassController,
              _oldPassFocus,
              _oldPassVisible,
              () => setState(() => _oldPassVisible = !_oldPassVisible),
              focusGreen,
            ),

            const SizedBox(height: 20),

            _buildLabel("New Password", darkGreen),
            _buildTextField(
              "Minimal 8 characters",
              _newPassController,
              _newPassFocus,
              _newPassVisible,
              () => setState(() => _newPassVisible = !_newPassVisible),
              focusGreen,
            ),

            const SizedBox(height: 20),

            _buildLabel("Confirm Password", darkGreen),
            _buildTextField(
              "Confirm new password",
              _confirmPassController,
              _confirmPassFocus,
              _confirmPassVisible,
              () => setState(() => _confirmPassVisible = !_confirmPassVisible),
              focusGreen,
            ),

            const SizedBox(height: 40),

            /// 🔥 TINGGAL INI SAJA (UPDATE PASSWORD)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isButtonActive
                    ? () => _showSuccessDialog(darkGreen)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  disabledBackgroundColor: darkGreen.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Update Password",
                  style: TextStyle(
                    color: _isButtonActive ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label, Color color) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: color),
        ),
      );

  Widget _buildTextField(
    String hint,
    TextEditingController ctrl,
    FocusNode fn,
    bool vis,
    VoidCallback toggle,
    Color fColor,
  ) {
    return TextFormField(
      controller: ctrl,
      focusNode: fn,
      obscureText: !vis,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF2D5E6E), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: fColor, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            vis
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: fn.hasFocus ? fColor : Colors.grey,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }
}