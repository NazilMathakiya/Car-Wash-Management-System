  // // import 'package:cloud_firestore/cloud_firestore.dart';
  // // import 'package:firebase_auth/firebase_auth.dart';
  // // import 'package:flutter/material.dart';
  // // import 'package:car/User/Login.dart';
  // //
  // // class SignUpScreen extends StatefulWidget {
  // //   const SignUpScreen({super.key});
  // //
  // //   @override
  // //   State<SignUpScreen> createState() => _SignUpScreenState();
  // // }
  // //
  // // class _SignUpScreenState extends State<SignUpScreen> {
  // //   final TextEditingController nameController = TextEditingController();
  // //   final TextEditingController emailController = TextEditingController();
  // //   final TextEditingController phoneController = TextEditingController();
  // //   final TextEditingController addressController = TextEditingController();
  // //   final TextEditingController passwordController = TextEditingController();
  // //
  // //   bool isLoading = false;
  // //
  // //   Future<void> registerUser() async {
  // //     if (nameController.text.isEmpty ||
  // //         emailController.text.isEmpty ||
  // //         phoneController.text.isEmpty ||
  // //         addressController.text.isEmpty ||
  // //         passwordController.text.isEmpty) {
  // //       ScaffoldMessenger.of(context).showSnackBar(
  // //         const SnackBar(content: Text("All fields are mandatory")),
  // //       );
  // //       return;
  // //     }
  // //
  // //     setState(() => isLoading = true);
  // //
  // //     try {
  // //       UserCredential userCredential =
  // //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  // //         email: emailController.text.trim(),
  // //         password: passwordController.text.trim(),
  // //       );
  // //
  // //       String uid = userCredential.user!.uid;
  // //
  // //       await FirebaseFirestore.instance.collection("users").doc(uid).set({
  // //         "uid": uid,
  // //         "name": nameController.text,
  // //         "email": emailController.text,
  // //         "phone": phoneController.text,
  // //         "address": addressController.text,
  // //         "password": passwordController.text, // FIXED
  // //         "created_at": DateTime.now(),
  // //       });
  // //
  // //       ScaffoldMessenger.of(context).showSnackBar(
  // //         const SnackBar(content: Text("Registration Successful! Please login.")),
  // //       );
  // //
  // //       Navigator.pushReplacement(
  // //         context,
  // //         MaterialPageRoute(builder: (context) => const LoginScreen()),
  // //       );
  // //     } on FirebaseAuthException catch (e) {
  // //       ScaffoldMessenger.of(context).showSnackBar(
  // //         SnackBar(content: Text(e.message ?? "Error occurred")),
  // //       );
  // //     }
  // //
  // //     setState(() => isLoading = false);
  // //   }
  // //
  // //   @override
  // //   Widget build(BuildContext context) {
  // //     return Scaffold(
  // //       backgroundColor: Colors.white,
  // //       body: SingleChildScrollView(
  // //         child: Column(
  // //           children: [
  // //             Container(
  // //               height: 230,
  // //               width: double.infinity,
  // //               decoration: const BoxDecoration(
  // //                 color: Color(0xFFF5A623),
  // //                 borderRadius: BorderRadius.only(
  // //                   bottomLeft: Radius.circular(200),
  // //                   bottomRight: Radius.circular(200),
  // //                 ),
  // //               ),
  // //               child: const Center(
  // //                 child: Text(
  // //                   "Sign UP",
  // //                   style: TextStyle(
  // //                     fontSize: 28,
  // //                     fontWeight: FontWeight.bold,
  // //                   ),
  // //                 ),
  // //               ),
  // //             ),
  // //
  // //             const SizedBox(height: 10),
  // //
  // //             Padding(
  // //               padding: const EdgeInsets.symmetric(horizontal: 20),
  // //               child: Container(
  // //                 padding: const EdgeInsets.all(20),
  // //                 decoration: BoxDecoration(
  // //                   color: Colors.white,
  // //                   borderRadius: BorderRadius.circular(15),
  // //                   boxShadow: [
  // //                     BoxShadow(
  // //                       color: Colors.black12,
  // //                       blurRadius: 10,
  // //                     ),
  // //                   ],
  // //                 ),
  // //                 child: Column(
  // //                   children: [
  // //                     inputField(Icons.person, "Enter User Name", nameController),
  // //                     const SizedBox(height: 10),
  // //                     inputField(Icons.email, "Enter User Email", emailController),
  // //                     const SizedBox(height: 10),
  // //                     inputField(Icons.phone, "Enter Contact No", phoneController),
  // //                     const SizedBox(height: 10),
  // //                     inputField(Icons.location_on, "Enter Address",
  // //                         addressController),
  // //                     const SizedBox(height: 10),
  // //                     inputField(Icons.lock, "Enter Password",
  // //                         passwordController,
  // //                         isPassword: true),
  // //                     const SizedBox(height: 20),
  // //
  // //                     // ⭐ FIXED SIGN UP BUTTON
  // //                     GestureDetector(
  // //                       onTap: registerUser,
  // //                       child: Container(
  // //                         height: 45,
  // //                         width: 200,
  // //                         alignment: Alignment.center,
  // //                         decoration: BoxDecoration(
  // //                           color: const Color(0xFFF5A623),
  // //                           borderRadius: BorderRadius.circular(10),
  // //                         ),
  // //                         child: isLoading
  // //                             ? const CircularProgressIndicator()
  // //                             : const Text(
  // //                           "Sign UP",
  // //                           style: TextStyle(
  // //                             fontSize: 16,
  // //                             fontWeight: FontWeight.bold,
  // //                           ),
  // //                         ),
  // //                       ),
  // //                     ),
  // //                   ],
  // //                 ),
  // //               ),
  // //             ),
  // //
  // //             const SizedBox(height: 30),
  // //             Column(
  // //               children: const [
  // //                 Icon(Icons.local_car_wash, size: 60),
  // //                 Text(
  // //                   "CLEAN GO",
  // //                   style: TextStyle(fontWeight: FontWeight.bold),
  // //                 ),
  // //               ],
  // //             )
  // //           ],
  // //         ),
  // //       ),
  // //     );
  // //   }
  // //
  // //   Widget inputField(IconData icon, String hint, TextEditingController controller,
  // //       {bool isPassword = false}) {
  // //     return TextField(
  // //       controller: controller,
  // //       obscureText: isPassword,
  // //       decoration: InputDecoration(
  // //         prefixIcon: Icon(icon),
  // //         hintText: hint,
  // //         border: OutlineInputBorder(
  // //           borderRadius: BorderRadius.circular(10),
  // //         ),
  // //       ),
  // //     );
  // //   }
  // // }
  //
  //
  // import 'package:car/User/userlogin.dart';
  // import 'package:cloud_firestore/cloud_firestore.dart';
  // import 'package:firebase_auth/firebase_auth.dart';
  // import 'package:flutter/material.dart';
  //
  //
  // class SignUpScreen extends StatefulWidget {
  //   const SignUpScreen({super.key});
  //
  //   @override
  //   State<SignUpScreen> createState() => _SignUpScreenState();
  // }
  //
  // class _SignUpScreenState extends State<SignUpScreen> {
  //   final TextEditingController nameController = TextEditingController();
  //   final TextEditingController emailController = TextEditingController();
  //   final TextEditingController phoneController = TextEditingController();
  //   final TextEditingController addressController = TextEditingController();
  //   final TextEditingController passwordController = TextEditingController();
  //
  //   bool isLoading = false;
  //   bool _obscurePassword = true;
  //
  //   Future<void> registerUser() async {
  //     if (nameController.text.isEmpty ||
  //         emailController.text.isEmpty ||
  //         phoneController.text.isEmpty ||
  //         addressController.text.isEmpty ||
  //         passwordController.text.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Text("All fields are mandatory"),
  //           backgroundColor: Colors.red.shade400,
  //           behavior: SnackBarBehavior.floating,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //       );
  //       return;
  //     }
  //
  //     setState(() => isLoading = true);
  //
  //     try {
  //       UserCredential userCredential =
  //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: emailController.text.trim(),
  //         password: passwordController.text.trim(),
  //       );
  //
  //       String uid = userCredential.user!.uid;
  //
  //       await FirebaseFirestore.instance.collection("users").doc(uid).set({
  //         "uid": uid,
  //         "name": nameController.text,
  //         "email": emailController.text,
  //         "phone": phoneController.text,
  //         "address": addressController.text,
  //         "password": passwordController.text,
  //         "created_at": DateTime.now(),
  //       });
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Text("Registration Successful! Please login."),
  //           backgroundColor: Colors.green.shade400,
  //           behavior: SnackBarBehavior.floating,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //       );
  //
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const LoginScreen()),
  //       );
  //     } on FirebaseAuthException catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(e.message ?? "Error occurred"),
  //           backgroundColor: Colors.red.shade400,
  //           behavior: SnackBarBehavior.floating,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //       );
  //     }
  //
  //     setState(() => isLoading = false);
  //   }
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       body: Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //             colors: [
  //               Colors.blue.shade600,
  //               Colors.purple.shade500,
  //             ],
  //           ),
  //         ),
  //         child: SafeArea(
  //           child: SingleChildScrollView(
  //             child: Padding(
  //               padding: const EdgeInsets.all(20),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   const SizedBox(height: 20),
  //
  //                   // Logo & Title
  //                   Container(
  //                     width: 100,
  //                     height: 100,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       shape: BoxShape.circle,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black.withOpacity(0.2),
  //                           blurRadius: 20,
  //                           offset: const Offset(0, 5),
  //                         ),
  //                       ],
  //                     ),
  //                     child: Icon(
  //                       Icons.water_drop_rounded,
  //                       size: 50,
  //                       color: Colors.blue.shade600,
  //                     ),
  //                   ),
  //
  //                   const SizedBox(height: 20),
  //
  //                   const Text(
  //                     "Create Account",
  //                     style: TextStyle(
  //                       fontSize: 32,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       letterSpacing: 1,
  //                     ),
  //                   ),
  //
  //                   const SizedBox(height: 8),
  //
  //                   Text(
  //                     "Sign up to get started",
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       color: Colors.white.withOpacity(0.9),
  //                     ),
  //                   ),
  //
  //                   const SizedBox(height: 30),
  //
  //                   // Sign Up Form Card
  //                   Container(
  //                     padding: const EdgeInsets.all(24),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(24),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black.withOpacity(0.1),
  //                           blurRadius: 20,
  //                           offset: const Offset(0, 10),
  //                         ),
  //                       ],
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         // Name Field
  //                         _buildTextField(
  //                           controller: nameController,
  //                           icon: Icons.person_outline,
  //                           hint: "Full Name",
  //                           iconColor: Colors.blue.shade600,
  //                         ),
  //
  //                         const SizedBox(height: 16),
  //
  //                         // Email Field
  //                         _buildTextField(
  //                           controller: emailController,
  //                           icon: Icons.email_outlined,
  //                           hint: "Email Address",
  //                           iconColor: Colors.blue.shade600,
  //                           keyboardType: TextInputType.emailAddress,
  //                         ),
  //
  //                         const SizedBox(height: 16),
  //
  //                         // Phone Field
  //                         _buildTextField(
  //                           controller: phoneController,
  //                           icon: Icons.phone_outlined,
  //                           hint: "Phone Number",
  //                           iconColor: Colors.blue.shade600,
  //                           keyboardType: TextInputType.phone,
  //                         ),
  //
  //                         const SizedBox(height: 16),
  //
  //                         // Address Field
  //                         _buildTextField(
  //                           controller: addressController,
  //                           icon: Icons.location_on_outlined,
  //                           hint: "Address",
  //                           iconColor: Colors.blue.shade600,
  //                         ),
  //
  //                         const SizedBox(height: 16),
  //
  //                         // Password Field
  //                         _buildTextField(
  //                           controller: passwordController,
  //                           icon: Icons.lock_outline,
  //                           hint: "Password",
  //                           iconColor: Colors.blue.shade600,
  //                           isPassword: true,
  //                           obscureText: _obscurePassword,
  //                           suffixIcon: IconButton(
  //                             icon: Icon(
  //                               _obscurePassword
  //                                   ? Icons.visibility_off_outlined
  //                                   : Icons.visibility_outlined,
  //                               color: Colors.grey,
  //                             ),
  //                             onPressed: () {
  //                               setState(() {
  //                                 _obscurePassword = !_obscurePassword;
  //                               });
  //                             },
  //                           ),
  //                         ),
  //
  //                         const SizedBox(height: 30),
  //
  //                         // Sign Up Button
  //                         InkWell(
  //                           onTap: isLoading ? null : registerUser,
  //                           child: Container(
  //                             height: 56,
  //                             decoration: BoxDecoration(
  //                               gradient: LinearGradient(
  //                                 colors: [
  //                                   Colors.blue.shade600,
  //                                   Colors.purple.shade500,
  //                                 ],
  //                               ),
  //                               borderRadius: BorderRadius.circular(16),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.blue.withOpacity(0.3),
  //                                   blurRadius: 15,
  //                                   offset: const Offset(0, 5),
  //                                 ),
  //                               ],
  //                             ),
  //                             child: Center(
  //                               child: isLoading
  //                                   ? const SizedBox(
  //                                 width: 24,
  //                                 height: 24,
  //                                 child: CircularProgressIndicator(
  //                                   valueColor:
  //                                   AlwaysStoppedAnimation<Color>(
  //                                       Colors.white),
  //                                   strokeWidth: 2.5,
  //                                 ),
  //                               )
  //                                   : const Text(
  //                                 "Sign Up",
  //                                 style: TextStyle(
  //                                   fontSize: 18,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.white,
  //                                   letterSpacing: 1,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //
  //                         const SizedBox(height: 20),
  //
  //                         // Already have account
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               "Already have an account? ",
  //                               style: TextStyle(
  //                                 color: Colors.grey.shade600,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                             GestureDetector(
  //                               onTap: () {
  //                                 Navigator.pushReplacement(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                     builder: (context) => const LoginScreen(),
  //                                   ),
  //                                 );
  //                               },
  //                               child: Text(
  //                                 "Sign In",
  //                                 style: TextStyle(
  //                                   color: Colors.blue.shade600,
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //
  //                   const SizedBox(height: 30),
  //
  //                   // Bottom Logo
  //                   Column(
  //                     children: [
  //                       Icon(
  //                         Icons.local_car_wash,
  //                         size: 50,
  //                         color: Colors.white.withOpacity(0.9),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       Text(
  //                         "CLEAN GO",
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16,
  //                           color: Colors.white.withOpacity(0.9),
  //                           letterSpacing: 2,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //
  //                   const SizedBox(height: 20),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //
  //   Widget _buildTextField({
  //     required TextEditingController controller,
  //     required IconData icon,
  //     required String hint,
  //     required Color iconColor,
  //     bool isPassword = false,
  //     bool obscureText = false,
  //     Widget? suffixIcon,
  //     TextInputType? keyboardType,
  //   }) {
  //     return Container(
  //       decoration: BoxDecoration(
  //         color: Colors.grey.shade50,
  //         borderRadius: BorderRadius.circular(16),
  //         border: Border.all(
  //           color: Colors.grey.shade200,
  //           width: 1,
  //         ),
  //       ),
  //       child: TextField(
  //         controller: controller,
  //         obscureText: obscureText,
  //         keyboardType: keyboardType,
  //         style: const TextStyle(
  //           fontSize: 15,
  //           color: Colors.black87,
  //         ),
  //         decoration: InputDecoration(
  //           prefixIcon: Icon(icon, color: iconColor, size: 22),
  //           suffixIcon: suffixIcon,
  //           hintText: hint,
  //           hintStyle: TextStyle(
  //             color: Colors.grey.shade400,
  //             fontSize: 15,
  //           ),
  //           border: InputBorder.none,
  //           contentPadding: const EdgeInsets.symmetric(
  //             horizontal: 20,
  //             vertical: 18,
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  import 'package:car/User/userlogin.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';

  class SignUpScreen extends StatefulWidget {
    const SignUpScreen({super.key});

    @override
    State<SignUpScreen> createState() => _SignUpScreenState();
  }

  class _SignUpScreenState extends State<SignUpScreen> {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController passkeyController = TextEditingController(); // Added Passkey Controller

    bool isLoading = false;
    bool _obscurePassword = true;
    bool _obscurePasskey = true; // Added for passkey visibility

    Future<void> registerUser() async {
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          phoneController.text.isEmpty ||
          addressController.text.isEmpty ||
          passwordController.text.isEmpty ||
          passkeyController.text.isEmpty) { // Added passkey validation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("All fields are mandatory"),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      // Passkey length validation (minimum 4 digits recommended)
      if (passkeyController.text.length < 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Passkey must be at least 4 characters"),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      setState(() => isLoading = true);

      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        String uid = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          "uid": uid,
          "name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "address": addressController.text,
          "password": passwordController.text,
          "passkey": passkeyController.text, // Storing passkey in Firebase
          "created_at": DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Registration Successful! Please login."),
            backgroundColor: Colors.green.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "Error occurred"),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }

      setState(() => isLoading = false);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade600,
                Colors.purple.shade500,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Logo & Title
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.water_drop_rounded,
                        size: 50,
                        color: Colors.blue.shade600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Sign up to get started",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Sign Up Form Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Name Field
                          _buildTextField(
                            controller: nameController,
                            icon: Icons.person_outline,
                            hint: "Full Name",
                            iconColor: Colors.blue.shade600,
                          ),

                          const SizedBox(height: 16),

                          // Email Field
                          _buildTextField(
                            controller: emailController,
                            icon: Icons.email_outlined,
                            hint: "Email Address",
                            iconColor: Colors.blue.shade600,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 16),

                          // Phone Field
                          _buildTextField(
                            controller: phoneController,
                            icon: Icons.phone_outlined,
                            hint: "Phone Number",
                            iconColor: Colors.blue.shade600,
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 16),

                          // Address Field
                          _buildTextField(
                            controller: addressController,
                            icon: Icons.location_on_outlined,
                            hint: "Address",
                            iconColor: Colors.blue.shade600,
                          ),

                          const SizedBox(height: 16),

                          // Password Field
                          _buildTextField(
                            controller: passwordController,
                            icon: Icons.lock_outline,
                            hint: "Password",
                            iconColor: Colors.blue.shade600,
                            isPassword: true,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Passkey Field (NEW)
                          _buildTextField(
                            controller: passkeyController,
                            icon: Icons.pin_outlined,
                            hint: "Passkey (Min 4 characters)",
                            iconColor: Colors.purple.shade500,
                            isPassword: true,
                            obscureText: _obscurePasskey,
                            keyboardType: TextInputType.number,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePasskey
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePasskey = !_obscurePasskey;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Sign Up Button
                          InkWell(
                            onTap: isLoading ? null : registerUser,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade600,
                                    Colors.purple.shade500,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 2.5,
                                  ),
                                )
                                    : const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Already have account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: Colors.blue.shade600,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Bottom Logo
                    Column(
                      children: [
                        Icon(
                          Icons.local_car_wash,
                          size: 50,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "CLEAN GO",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildTextField({
      required TextEditingController controller,
      required IconData icon,
      required String hint,
      required Color iconColor,
      bool isPassword = false,
      bool obscureText = false,
      Widget? suffixIcon,
      TextInputType? keyboardType,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: iconColor, size: 22),
            suffixIcon: suffixIcon,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 15,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
        ),
      );
    }
  }