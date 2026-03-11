// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({super.key});
//
//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }
//
// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final oldCtrl = TextEditingController();
//   final newCtrl = TextEditingController();
//   final confirmCtrl = TextEditingController();
//
//   bool isLoading = false;
//   bool oldVerified = false;
//   bool _obscureOld = true;
//   bool _obscureNew = true;
//   bool _obscureConfirm = true;
//
//   final String uid = FirebaseAuth.instance.currentUser!.uid;
//   String? userEmail;
//
//   @override
//   void dispose() {
//     oldCtrl.dispose();
//     newCtrl.dispose();
//     confirmCtrl.dispose();
//     super.dispose();
//   }
//
//   /// 🔹 VERIFY OLD PASSWORD
//   Future<void> verifyOldPassword() async {
//     if (oldCtrl.text.trim().isEmpty) {
//       _snack("Enter old password", isError: true);
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(uid)
//           .get();
//
//       if (!doc.exists) {
//         _snack("User record not found", isError: true);
//         setState(() => isLoading = false);
//         return;
//       }
//
//       final storedPassword = doc['password'];
//       userEmail = doc['email']; // Store email for re-authentication
//
//       if (storedPassword == oldCtrl.text.trim()) {
//         setState(() {
//           oldVerified = true;
//           isLoading = false;
//         });
//         _snack("Old password verified ✓", isError: false);
//       } else {
//         setState(() => isLoading = false);
//         _snack("Old password incorrect", isError: true);
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       _snack("Error: $e", isError: true);
//     }
//   }
//
//   /// 🔹 UPDATE PASSWORD (Both Firebase Auth & Firestore)
//   Future<void> updatePassword() async {
//     if (newCtrl.text.isEmpty || confirmCtrl.text.isEmpty) {
//       _snack("Fill all fields", isError: true);
//       return;
//     }
//
//     if (newCtrl.text.length < 6) {
//       _snack("Password must be at least 6 characters", isError: true);
//       return;
//     }
//
//     if (newCtrl.text != confirmCtrl.text) {
//       _snack("Passwords do not match", isError: true);
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//
//       // Step 1: Re-authenticate user with old password
//       if (userEmail != null) {
//         final credential = EmailAuthProvider.credential(
//           email: userEmail!,
//           password: oldCtrl.text.trim(),
//         );
//
//         await user.reauthenticateWithCredential(credential);
//         print("✅ Re-authentication successful");
//       }
//
//       // Step 2: Update password in Firebase Authentication
//       await user.updatePassword(newCtrl.text.trim());
//       print("✅ Firebase Auth password updated");
//
//       // Step 3: Update password in Firestore
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(uid)
//           .update({"password": newCtrl.text.trim()});
//       print("✅ Firestore password updated");
//
//       setState(() => isLoading = false);
//       _snack("Password updated successfully 🎉", isError: false);
//
//       Future.delayed(const Duration(seconds: 2), () {
//         if (mounted) Navigator.pop(context);
//       });
//
//     } on FirebaseAuthException catch (e) {
//       setState(() => isLoading = false);
//
//       String errorMsg = "Failed to update password";
//
//       if (e.code == 'weak-password') {
//         errorMsg = "Password is too weak";
//       } else if (e.code == 'requires-recent-login') {
//         errorMsg = "Please log out and log in again before changing password";
//       } else if (e.code == 'wrong-password') {
//         errorMsg = "Old password is incorrect";
//       } else {
//         errorMsg = "Error: ${e.message}";
//       }
//
//       _snack(errorMsg, isError: true);
//     } catch (e) {
//       setState(() => isLoading = false);
//       _snack("Error: ${e.toString()}", isError: true);
//     }
//   }
//
//   void _snack(String msg, {required bool isError}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isError ? Icons.error_outline : Icons.check_circle_outline,
//               color: Colors.white,
//             ),
//             const SizedBox(width: 12),
//             Expanded(child: Text(msg)),
//           ],
//         ),
//         backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String label,
//     required bool obscure,
//     required VoidCallback onToggle,
//     required IconData prefixIcon,
//     bool enabled = true,
//     String? helperText,
//   }) {
//     return TextField(
//       controller: controller,
//       enabled: enabled,
//       obscureText: obscure,
//       style: const TextStyle(fontSize: 16),
//       decoration: InputDecoration(
//         labelText: label,
//         helperText: helperText,
//         prefixIcon: Icon(prefixIcon, size: 22),
//         suffixIcon: IconButton(
//           icon: Icon(
//             obscure ? Icons.visibility_off : Icons.visibility,
//             size: 22,
//           ),
//           onPressed: enabled ? onToggle : null,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade200),
//         ),
//         filled: true,
//         fillColor: enabled ? Colors.white : Colors.grey.shade100,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text("Change Password"),
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 8),
//
//               // Header Icon & Title
//               Center(
//                 child: Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.lock_reset_rounded,
//                     size: 56,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               Text(
//                 "Secure Your Account",
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               Text(
//                 "Password will be updated in both Firebase Auth & Firestore",
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//
//               const SizedBox(height: 32),
//
//               // Step 1: Verify Old Password
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: oldVerified
//                                 ? Colors.green.shade100
//                                 : Colors.blue.shade100,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Icon(
//                             oldVerified ? Icons.check_circle : Icons.security,
//                             color: oldVerified
//                                 ? Colors.green.shade700
//                                 : Colors.blue.shade700,
//                             size: 20,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             "Step 1: Verify Identity",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleMedium
//                                 ?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         if (oldVerified)
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade50,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.green.shade200),
//                             ),
//                             child: Text(
//                               "Verified",
//                               style: TextStyle(
//                                 color: Colors.green.shade700,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     _buildPasswordField(
//                       controller: oldCtrl,
//                       label: "Current Password",
//                       obscure: _obscureOld,
//                       onToggle: () => setState(() => _obscureOld = !_obscureOld),
//                       prefixIcon: Icons.lock_outline,
//                       enabled: !oldVerified,
//                     ),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: (isLoading || oldVerified)
//                             ? null
//                             : verifyOldPassword,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: oldVerified
//                               ? Colors.green
//                               : Theme.of(context).primaryColor,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                           disabledBackgroundColor: Colors.grey.shade300,
//                         ),
//                         child: isLoading
//                             ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                             : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               oldVerified
//                                   ? Icons.check_circle
//                                   : Icons.verified_user,
//                               size: 20,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               oldVerified
//                                   ? "Verified"
//                                   : "Verify Password",
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // Step 2: Set New Password
//               AnimatedOpacity(
//                 opacity: oldVerified ? 1.0 : 0.4,
//                 duration: const Duration(milliseconds: 300),
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.shade100,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Icon(
//                               Icons.key,
//                               color: Colors.blue.shade700,
//                               size: 20,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               "Step 2: Create New Password",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleMedium
//                                   ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       _buildPasswordField(
//                         controller: newCtrl,
//                         label: "New Password",
//                         obscure: _obscureNew,
//                         onToggle: () =>
//                             setState(() => _obscureNew = !_obscureNew),
//                         prefixIcon: Icons.lock,
//                         enabled: oldVerified,
//                         helperText: "Minimum 6 characters",
//                       ),
//                       const SizedBox(height: 16),
//                       _buildPasswordField(
//                         controller: confirmCtrl,
//                         label: "Confirm New Password",
//                         obscure: _obscureConfirm,
//                         onToggle: () =>
//                             setState(() => _obscureConfirm = !_obscureConfirm),
//                         prefixIcon: Icons.lock_clock,
//                         enabled: oldVerified,
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed:
//                           (oldVerified && !isLoading) ? updatePassword : null,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green.shade600,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             elevation: 0,
//                             disabledBackgroundColor: Colors.grey.shade300,
//                           ),
//                           child: isLoading
//                               ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                               : const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.save, size: 20),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Update Password",
//                                 style: TextStyle(
//                                   fontSize: 16,
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
//               ),
//
//               const SizedBox(height: 24),
//
//               // Security Tips
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.blue.shade200),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.info_outline,
//                           color: Colors.blue.shade800,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           "What Gets Updated",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue.shade900,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInfoTip("✅ Firebase Authentication password"),
//                     const SizedBox(height: 6),
//                     _buildInfoTip("✅ Firestore database password"),
//                     const SizedBox(height: 6),
//                     _buildInfoTip("✅ You can login with new password immediately"),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Security Tips
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.amber.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.amber.shade200),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.tips_and_updates,
//                           color: Colors.amber.shade800,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           "Security Tips",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.amber.shade900,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     _buildTip("Use a mix of letters, numbers & symbols"),
//                     const SizedBox(height: 6),
//                     _buildTip("Avoid common words or personal info"),
//                     const SizedBox(height: 6),
//                     _buildTip("Don't reuse passwords from other accounts"),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTip(String text) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(
//           Icons.check_circle,
//           size: 16,
//           color: Colors.amber.shade700,
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.amber.shade900,
//               height: 1.4,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoTip(String text) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 13,
//             color: Colors.blue.shade900,
//             height: 1.4,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool isLoading = false;
  bool oldVerified = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final String uid = FirebaseAuth.instance.currentUser!.uid;
  String? userEmail;

  // Blue theme colors matching the Edit Profile screen
  final Color primaryBlue = const Color(0xFF2196F3);
  final Color lightBlue = const Color(0xFF42A5F5);
  final Color verifiedBlue = const Color(0xFF1E88E5);

  @override
  void dispose() {
    oldCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  /// 🔹 VERIFY OLD PASSWORD
  Future<void> verifyOldPassword() async {
    if (oldCtrl.text.trim().isEmpty) {
      _snack("Enter old password", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (!doc.exists) {
        _snack("User record not found", isError: true);
        setState(() => isLoading = false);
        return;
      }

      final storedPassword = doc['password'];
      userEmail = doc['email']; // Store email for re-authentication

      if (storedPassword == oldCtrl.text.trim()) {
        setState(() {
          oldVerified = true;
          isLoading = false;
        });
        _snack("Old password verified ✓", isError: false);
      } else {
        setState(() => isLoading = false);
        _snack("Old password incorrect", isError: true);
      }
    } catch (e) {
      setState(() => isLoading = false);
      _snack("Error: $e", isError: true);
    }
  }

  /// 🔹 UPDATE PASSWORD (Both Firebase Auth & Firestore)
  Future<void> updatePassword() async {
    if (newCtrl.text.isEmpty || confirmCtrl.text.isEmpty) {
      _snack("Fill all fields", isError: true);
      return;
    }

    if (newCtrl.text.length < 6) {
      _snack("Password must be at least 6 characters", isError: true);
      return;
    }

    if (newCtrl.text != confirmCtrl.text) {
      _snack("Passwords do not match", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;

      // Step 1: Re-authenticate user with old password
      if (userEmail != null) {
        final credential = EmailAuthProvider.credential(
          email: userEmail!,
          password: oldCtrl.text.trim(),
        );

        await user.reauthenticateWithCredential(credential);
        print("✅ Re-authentication successful");
      }

      // Step 2: Update password in Firebase Authentication
      await user.updatePassword(newCtrl.text.trim());
      print("✅ Firebase Auth password updated");

      // Step 3: Update password in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({"password": newCtrl.text.trim()});
      print("✅ Firestore password updated");

      setState(() => isLoading = false);
      _snack("Password updated successfully 🎉", isError: false);

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });

    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);

      String errorMsg = "Failed to update password";

      if (e.code == 'weak-password') {
        errorMsg = "Password is too weak";
      } else if (e.code == 'requires-recent-login') {
        errorMsg = "Please log out and log in again before changing password";
      } else if (e.code == 'wrong-password') {
        errorMsg = "Old password is incorrect";
      } else {
        errorMsg = "Error: ${e.message}";
      }

      _snack(errorMsg, isError: true);
    } catch (e) {
      setState(() => isLoading = false);
      _snack("Error: ${e.toString()}", isError: true);
    }
  }

  void _snack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    required IconData prefixIcon,
    bool enabled = true,
    String? helperText,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscure,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        helperStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(prefixIcon, size: 22, color: primaryBlue),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            size: 22,
            color: primaryBlue,
          ),
          onPressed: enabled ? onToggle : null,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Change Password"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              // Header Icon & Title
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 56,
                    color: primaryBlue,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Secure Your Account",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Password will be updated in both Firebase Auth & Firestore",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 32),

              // Step 1: Verify Old Password
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: oldVerified
                                ? primaryBlue.withOpacity(0.1)
                                : primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            oldVerified ? Icons.check_circle : Icons.security,
                            color: oldVerified ? primaryBlue : primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Step 1: Verify Identity",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        if (oldVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: primaryBlue.withOpacity(0.3)),
                            ),
                            child: Text(
                              "Verified",
                              style: TextStyle(
                                color: primaryBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      controller: oldCtrl,
                      label: "Current Password",
                      obscure: _obscureOld,
                      onToggle: () => setState(() => _obscureOld = !_obscureOld),
                      prefixIcon: Icons.lock_outline,
                      enabled: !oldVerified,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (isLoading || oldVerified)
                            ? null
                            : verifyOldPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: oldVerified ? primaryBlue : primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              oldVerified
                                  ? Icons.check_circle
                                  : Icons.verified_user,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              oldVerified
                                  ? "Verified"
                                  : "Verify Password",
                              style: const TextStyle(
                                fontSize: 16,
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

              const SizedBox(height: 24),

              // Step 2: Set New Password
              AnimatedOpacity(
                opacity: oldVerified ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.key,
                              color: primaryBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Step 2: Create New Password",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        controller: newCtrl,
                        label: "New Password",
                        obscure: _obscureNew,
                        onToggle: () =>
                            setState(() => _obscureNew = !_obscureNew),
                        prefixIcon: Icons.lock,
                        enabled: oldVerified,
                        helperText: "Minimum 6 characters",
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        controller: confirmCtrl,
                        label: "Confirm New Password",
                        obscure: _obscureConfirm,
                        onToggle: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        prefixIcon: Icons.lock_clock,
                        enabled: oldVerified,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                          (oldVerified && !isLoading) ? updatePassword : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            disabledBackgroundColor: Colors.grey.shade300,
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 16,
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
              ),

              const SizedBox(height: 24),

              // What Gets Updated
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryBlue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: primaryBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "What Gets Updated",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoTip("✅ Firebase Authentication password"),
                    const SizedBox(height: 6),
                    _buildInfoTip("✅ Firestore database password"),
                    const SizedBox(height: 6),
                    _buildInfoTip("✅ You can login with new password immediately"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Security Tips
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.tips_and_updates,
                          color: Colors.grey.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Security Tips",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTip("Use a mix of letters, numbers & symbols"),
                    const SizedBox(height: 6),
                    _buildTip("Avoid common words or personal info"),
                    const SizedBox(height: 6),
                    _buildTip("Don't reuse passwords from other accounts"),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: primaryBlue,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}