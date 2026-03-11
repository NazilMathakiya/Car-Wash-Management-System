// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});
//
//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     super.dispose();
//   }
//
//   // Send password to email
//   Future<void> sendPasswordToEmail() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => isLoading = true);
//
//     String email = emailController.text.trim();
//
//     try {
//       print('Checking email in Firestore: $email');
//
//       // Check if email exists in Firestore
//       final userQuery = await FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .limit(1)
//           .get();
//
//       if (userQuery.docs.isEmpty) {
//         setState(() => isLoading = false);
//         _showErrorDialog(
//           "Email Not Found",
//           "No user has been registered with this email address.\n\nEmail: $email\n\nPlease register first..",
//         );
//         return;
//       }
//
//       // Get user data
//       final userData = userQuery.docs.first.data();
//       String? userName = userData['name'];
//       String? userPassword = userData['password'];
//
//       if (userPassword == null) {
//         setState(() => isLoading = false);
//         _showErrorDialog("Error", "I did not find the username and password in the database.");
//         return;
//       }
//
//       print('User found: $userName');
//       print('Password: $userPassword');
//
//       // Show success dialog with password
//       setState(() => isLoading = false);
//       _showSuccessDialog(email, userName ?? 'User', userPassword);
//
//     } on FirebaseException catch (e) {
//       print('Firestore Error: ${e.code} - ${e.message}');
//       setState(() => isLoading = false);
//       _showErrorDialog("Database Error", "Error: ${e.message ?? e.code}");
//     } catch (e) {
//       print('Error: $e');
//       setState(() => isLoading = false);
//       _showErrorDialog("Error", "Something went wrong.: ${e.toString()}");
//     }
//   }
//
//   // SUCCESS DIALOG with Password
//   void _showSuccessDialog(String email, String name, String password) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF10B981).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(
//                 Icons.check_circle,
//                 color: Color(0xFF10B981),
//                 size: 28,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Text(
//                 'Account Found!',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'What are your account details:',
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // User Info Card
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF0F9FF),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: const Color(0xFF3B82F6)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Name
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.person,
//                         color: Color(0xFF3B82F6),
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Name:',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.black54,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           name,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//
//                   // Email
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.email,
//                         color: Color(0xFF3B82F6),
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Email:',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.black54,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           email,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//
//                   // Divider
//                   const Divider(color: Color(0xFF3B82F6)),
//                   const SizedBox(height: 12),
//
//                   // Password
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.lock,
//                         color: Color(0xFFEF4444),
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Password:',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.black54,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFEF2F2),
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color: const Color(0xFFEF4444),
//                               width: 1.5,
//                             ),
//                           ),
//                           child: SelectableText(
//                             password,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFFEF4444),
//                               letterSpacing: 2,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Warning Box
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFEF3C7),
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: const Color(0xFFF59E0B)),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(
//                     Icons.warning_amber_rounded,
//                     color: Color(0xFFF59E0B),
//                     size: 20,
//                   ),
//                   const SizedBox(width: 8),
//                   const Expanded(
//                     child: Text(
//                       'Remember our passwords and keep them safe. Do not share them with anyone.',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.black87,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               Navigator.pop(context); // Go back to login
//             },
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24,
//                 vertical: 12,
//               ),
//               backgroundColor: const Color(0xFF3B82F6),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               'Okay, Got It!',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ERROR DIALOG
//   void _showErrorDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEF4444).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(
//                 Icons.error_outline,
//                 color: Color(0xFFEF4444),
//                 size: 28,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           message,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.black87,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(
//               backgroundColor: const Color(0xFFEF4444),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               'OK',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // UI
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(Icons.arrow_back_ios),
//                   color: const Color(0xFF1E293B),
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Header
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF3B82F6).withOpacity(0.3),
//                         blurRadius: 20,
//                         offset: const Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: const Icon(
//                           Icons.lock_reset,
//                           color: Colors.white,
//                           size: 48,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Forgot Password?',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Enter your registered email and we will send you your password.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.white.withOpacity(0.9),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//
//                 // Form
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Email Address',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1E293B),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//
//                       TextFormField(
//                         controller: emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           hintText: 'Enter your registered email',
//                           prefixIcon: Icon(
//                             Icons.email_outlined,
//                             color: Colors.grey[400],
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: const BorderSide(
//                               color: Color(0xFFE2E8F0),
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: const BorderSide(
//                               color: Color(0xFFE2E8F0),
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(16),
//                             borderSide: const BorderSide(
//                               color: Color(0xFF3B82F6),
//                               width: 2,
//                             ),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Enter Email';
//                           }
//                           if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                               .hasMatch(value)) {
//                             return 'Enter Valid Email';
//                           }
//                           return null;
//                         },
//                       ),
//
//                       const SizedBox(height: 32),
//
//                       // Submit button
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: isLoading ? null : sendPasswordToEmail,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF3B82F6),
//                             disabledBackgroundColor: Colors.grey[300],
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: isLoading
//                               ? const SizedBox(
//                             height: 24,
//                             width: 24,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2.5,
//                             ),
//                           )
//                               : const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Get My Password',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               SizedBox(width: 8),
//                               Icon(Icons.arrow_forward,
//                                   color: Colors.white, size: 20),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       // Info Box
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFDCFCE7),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: const Color(0xFF10B981),
//                           ),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.info_outline,
//                               color: Colors.green[700],
//                               size: 20,
//                             ),
//                             const SizedBox(width: 12),
//                             const Expanded(
//                               child: Text(
//                                 'Enter your registered email. If the email is in our database, your password will be displayed.',
//                                 style: TextStyle(fontSize: 13, height: 1.5),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 24),
//
//                       Center(
//                         child: TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.arrow_back,
//                                   size: 18, color: Color(0xFF3B82F6)),
//                               SizedBox(width: 8),
//                               Text(
//                                 'Back to Login',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Color(0xFF3B82F6),
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passkeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showPasskeyField = false;
  String? verifiedEmail;
  String? userName;
  String? userPassword;

  @override
  void dispose() {
    emailController.dispose();
    passkeyController.dispose();
    super.dispose();
  }

  // Step 1: Verify Email
  Future<void> verifyEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    String email = emailController.text.trim();

    try {
      print('Checking email in Firestore: $email');

      // Check if email exists in Firestore
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        setState(() => isLoading = false);
        _showErrorDialog(
          "Email Not Found",
          "No user has been registered with this email address.\n\nEmail: $email\n\nPlease register first.",
        );
        return;
      }

      // Get user data
      final userData = userQuery.docs.first.data();
      userName = userData['name'];
      userPassword = userData['password'];
      verifiedEmail = email;

      print('User found: $userName');

      // Show passkey field
      setState(() {
        isLoading = false;
        showPasskeyField = true;
      });

      // Show info dialog
      _showInfoDialog(
        "Email Verified!",
        "Email found in our database.\n\nNow enter your security passkey to retrieve your password.",
      );

    } on FirebaseException catch (e) {
      print('Firestore Error: ${e.code} - ${e.message}');
      setState(() => isLoading = false);
      _showErrorDialog("Database Error", "Error: ${e.message ?? e.code}");
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
      _showErrorDialog("Error", "Something went wrong: ${e.toString()}");
    }
  }

  // Step 2: Verify Passkey and Show Password
  Future<void> verifyPasskeyAndShowPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    String enteredPasskey = passkeyController.text.trim();

    try {
      // Get the passkey from Firestore
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: verifiedEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        setState(() => isLoading = false);
        _showErrorDialog("Error", "User data not found.");
        return;
      }

      final userData = userQuery.docs.first.data();
      String? storedPasskey = userData['passkey'];

      if (storedPasskey == null) {
        setState(() => isLoading = false);
        _showErrorDialog(
          "Passkey Not Set",
          "No passkey found for this account. Please contact support.",
        );
        return;
      }

      // Verify passkey
      if (enteredPasskey != storedPasskey) {
        setState(() => isLoading = false);
        _showErrorDialog(
          "Incorrect Passkey",
          "The passkey you entered is incorrect.\n\nPlease try again.",
        );
        return;
      }

      // Passkey is correct - show password
      setState(() => isLoading = false);
      _showSuccessDialog(verifiedEmail!, userName ?? 'User', userPassword!);

    } on FirebaseException catch (e) {
      print('Firestore Error: ${e.code} - ${e.message}');
      setState(() => isLoading = false);
      _showErrorDialog("Database Error", "Error: ${e.message ?? e.code}");
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
      _showErrorDialog("Error", "Something went wrong: ${e.toString()}");
    }
  }

  // INFO DIALOG
  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.info_outline,
                color: Color(0xFF3B82F6),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SUCCESS DIALOG with Password
  void _showSuccessDialog(String email, String name, String password) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF10B981),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Account Found!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your account details:',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // User Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF3B82F6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Color(0xFF3B82F6),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Name:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Email
                  Row(
                    children: [
                      const Icon(
                        Icons.email,
                        color: Color(0xFF3B82F6),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          email,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Divider
                  const Divider(color: Color(0xFF3B82F6)),
                  const SizedBox(height: 12),

                  // Password
                  Row(
                    children: [
                      const Icon(
                        Icons.lock,
                        color: Color(0xFFEF4444),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Password:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFEF4444),
                              width: 1.5,
                            ),
                          ),
                          child: SelectableText(
                            password,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEF4444),
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Warning Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF59E0B)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFF59E0B),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Remember your password and keep it safe. Do not share it with anyone.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to login
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              backgroundColor: const Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Okay, Got It!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ERROR DIALOG
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Color(0xFFEF4444),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                  color: const Color(0xFF1E293B),
                ),
                const SizedBox(height: 20),

                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.lock_reset,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your email and passkey to retrieve your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Field
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !showPasskeyField,
                        decoration: InputDecoration(
                          hintText: 'Enter your registered email',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: showPasskeyField
                                ? Colors.grey[300]
                                : Colors.grey[400],
                          ),
                          suffixIcon: showPasskeyField
                              ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF10B981),
                          )
                              : null,
                          filled: true,
                          fillColor: showPasskeyField
                              ? Colors.grey[100]
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Enter Valid Email';
                          }
                          return null;
                        },
                      ),

                      // Passkey Field (shown after email verification)
                      if (showPasskeyField) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Security Passkey',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: passkeyController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter your security passkey',
                            prefixIcon: Icon(
                              Icons.key,
                              color: Colors.grey[400],
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF3B82F6),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Passkey';
                            }
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : (showPasskeyField
                              ? verifyPasskeyAndShowPassword
                              : verifyEmail),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                showPasskeyField
                                    ? 'Get My Password'
                                    : 'Verify Email',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward,
                                  color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Info Box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.green[700],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                showPasskeyField
                                    ? 'Enter your security passkey to retrieve your password. This passkey was set during registration.'
                                    : 'Enter your registered email. If found, you will be asked to enter your security passkey.',
                                style:
                                const TextStyle(fontSize: 13, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back,
                                  size: 18, color: Color(0xFF3B82F6)),
                              SizedBox(width: 8),
                              Text(
                                'Back to Login',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF3B82F6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}