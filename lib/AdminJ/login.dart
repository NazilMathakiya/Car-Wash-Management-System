import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../User/userlogin.dart';
import 'home.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // Focus Nodes
  final FocusNode userFocus = FocusNode();
  final FocusNode passFocus = FocusNode();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _introVisible = false;

  // Refined Color Palette
  static const bgLight = Color(0xFFF4F7FB);
  static const bgWhite = Color(0xFFFFFFFF);
  static const primaryBlue = Color(0xFF0D47A1); // Deep indigo
  static const accentBlue = Color(0xFF1976D2); // Vibrant blue
  static const accentTeal = Color(0xFF00BFA5);
  static const textDark = Color(0xFF0B2B3B);
  static const textGray = Color(0xFF6B7280);

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> loginAdmin() async {
    setState(() => _loading = true);

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc('auth')
          .get();

      if (!snapshot.exists) {
        showError("Admin data not found!");
        setState(() => _loading = false);
        return;
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final savedEmail = data['email'];
      final savedPhone = data['Admin_Contact No'];
      final savedPassword = data['Password'];

      String input = userController.text.trim();
      String password = passController.text.trim();

      if (input != savedEmail && input != savedPhone) {
        showError("Invalid Email or Mobile Number!");
        setState(() => _loading = false);
        return;
      }

      if (password != savedPassword) {
        showError("Incorrect Password!");
        setState(() => _loading = false);
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
    } catch (e) {
      showError("Error: $e");
    }

    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    // Intro animation
    Future.delayed(const Duration(milliseconds: 120), () {
      setState(() => _introVisible = true);
    });

    // Rebuild when focus changes to update field shadows
    userFocus.addListener(() => setState(() {}));
    passFocus.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ******** Modern Blue Gradient Top ********
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryBlue, accentBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),

                  // Content (animated)
                  Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: _introVisible ? 1 : 0,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 600),
                        scale: _introVisible ? 1 : 0.95,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.white24, Colors.white10],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.admin_panel_settings_rounded,
                                size: 58,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Sign in to continue to the dashboard",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ******** Modern White Card ********
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: bgWhite,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Login Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter your credentials to continue",
                    style: TextStyle(
                      fontSize: 13,
                      color: textGray,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Email / Phone input
                  _buildTextField(
                    controller: userController,
                    focusNode: userFocus,
                    hint: "Email or Mobile Number",
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(passFocus);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password Input
                  _buildTextField(
                    controller: passController,
                    focusNode: passFocus,
                    hint: "Password",
                    icon: Icons.lock_outline_rounded,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: textGray,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    onSubmitted: (_) => loginAdmin(),
                  ),

                  const SizedBox(height: 12),

                  SizedBox.shrink(),


                  const SizedBox(height: 32),

                  // ******** Login Button ********
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryBlue, accentBlue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _loading ? null : loginAdmin,
                      child: _loading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login_rounded, color: Colors.white, size: 22),
                          SizedBox(width: 10),
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Security Note
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        const Text(
                          "User Login",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputAction? textInputAction,
    Widget? suffixIcon,
    Function(String)? onSubmitted,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: bgLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: focusNode.hasFocus ? Colors.black.withOpacity(0.08) : Colors.black.withOpacity(0.03),
            blurRadius: focusNode.hasFocus ? 14 : 10,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: focusNode.hasFocus ? primaryBlue.withOpacity(0.18) : Colors.transparent, width: 1),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        style: const TextStyle(
          fontSize: 15,
          color: textDark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: textGray.withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryBlue.withOpacity(0.15), accentBlue.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryBlue, size: 20),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
          filled: true,
          fillColor: bgLight,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );

  }
}