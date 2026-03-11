// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   final String name;
//   final String phone;
//   final String address;
//
//   const EditProfileScreen({
//     super.key,
//     required this.name,
//     required this.phone,
//     required this.address,
//   });
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final user = FirebaseAuth.instance.currentUser;
//
//   late TextEditingController nameController;
//   late TextEditingController phoneController;
//   late TextEditingController addressController;
//
//   final _formKey = GlobalKey<FormState>();
//   bool saving = false;
//
//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.name);
//     phoneController = TextEditingController(text: widget.phone);
//     addressController = TextEditingController(text: widget.address);
//   }
//
//   Future<void> saveProfile() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     setState(() => saving = true);
//
//     try {
//       await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
//         "name": nameController.text.trim(),
//         "phone": phoneController.text.trim(),
//         "address": addressController.text.trim(),
//       });
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 12),
//                 Text("Profile updated successfully!"),
//               ],
//             ),
//             backgroundColor: const Color(0xFF10B981),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//
//         Future.delayed(const Duration(milliseconds: 500), () {
//           Navigator.pop(context, true);
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.white),
//                 const SizedBox(width: 12),
//                 Expanded(child: Text("Error: $e")),
//               ],
//             ),
//             backgroundColor: const Color(0xFFEF4444),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//       }
//     }
//
//     setState(() => saving = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: AppBar(
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF6366F1),
//                 Color(0xFF8B5CF6),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         title: const Text(
//           "Edit Profile",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         centerTitle: true,
//         actions: [
//           if (!saving)
//             TextButton.icon(
//               onPressed: saveProfile,
//               icon: const Icon(Icons.check, color: Colors.white, size: 20),
//               label: const Text(
//                 "Save",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//
//               // Profile Avatar with Edit Badge
//               Stack(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color(0xFF6366F1),
//                           Color(0xFF8B5CF6),
//                         ],
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF6366F1).withOpacity(0.3),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 55,
//                       backgroundColor: Colors.white,
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundColor: const Color(0xFFF1F5F9),
//                         child: Text(
//                           nameController.text.isNotEmpty
//                               ? nameController.text[0].toUpperCase()
//                               : "U",
//                           style: const TextStyle(
//                             fontSize: 40,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF6366F1),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [
//                             Color(0xFF6366F1),
//                             Color(0xFF8B5CF6),
//                           ],
//                         ),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 3),
//                       ),
//                       child: const Icon(
//                         Icons.edit,
//                         size: 18,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 30),
//
//               // Title
//               const Text(
//                 "Update Your Information",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               Text(
//                 "Keep your profile up to date",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
//               // Form Card
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.06),
//                       blurRadius: 20,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     // Full Name
//                     _buildEnhancedTextField(
//                       controller: nameController,
//                       label: "Full Name",
//                       icon: Icons.person_outline,
//                       hint: "Enter your full name",
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return "Please enter your name";
//                         }
//                         return null;
//                       },
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Phone Number
//                     _buildEnhancedTextField(
//                       controller: phoneController,
//                       label: "Phone Number",
//                       icon: Icons.phone_outlined,
//                       hint: "Enter your phone number",
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return "Please enter your phone number";
//                         }
//                         if (value.length < 10) {
//                           return "Please enter a valid phone number";
//                         }
//                         return null;
//                       },
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Address
//                     _buildEnhancedTextField(
//                       controller: addressController,
//                       label: "Address",
//                       icon: Icons.location_on_outlined,
//                       hint: "Enter your address",
//                       maxLines: 3,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return "Please enter your address";
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
//               // Save Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: saving
//                     ? Center(
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                         ),
//                       ],
//                     ),
//                     child: const CircularProgressIndicator(
//                       color: Color(0xFF6366F1),
//                     ),
//                   ),
//                 )
//                     : ElevatedButton(
//                   onPressed: saveProfile,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     padding: EdgeInsets.zero,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: Ink(
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color(0xFF6366F1),
//                           Color(0xFF8B5CF6),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF6366F1).withOpacity(0.4),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.save_outlined, color: Colors.white),
//                           SizedBox(width: 8),
//                           Text(
//                             "Save Changes",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Cancel Button
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text(
//                   "Cancel",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEnhancedTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     required String hint,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF64748B),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           maxLines: maxLines,
//           validator: validator,
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: TextStyle(
//               color: Colors.grey.shade400,
//               fontSize: 15,
//             ),
//             prefixIcon: Icon(
//               icon,
//               color: const Color(0xFF6366F1),
//               size: 22,
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF8FAFC),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: Color(0xFFEF4444)),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 16,
//             ),
//           ),
//           style: const TextStyle(
//             fontSize: 15,
//             color: Color(0xFF1E293B),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String address;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  final _formKey = GlobalKey<FormState>();
  bool saving = false;

  // Blue Theme Colors
  static const primaryBlue = Color(0xFF2196F3);
  static const darkBlue = Color(0xFF1976D2);
  static const lightBlue = Color(0xFF42A5F5);
  static const bgLight = Color(0xFFF8FAFC);
  static const bgWhite = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF1E293B);
  static const textGray = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    addressController = TextEditingController(text: widget.address);
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => saving = true);

    try {
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text("Profile updated successfully!"),
              ],
            ),
            backgroundColor: primaryBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context, true);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text("Error: $e")),
              ],
            ),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }

    setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, darkBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          if (!saving)
            TextButton.icon(
              onPressed: saveProfile,
              icon: const Icon(Icons.check, color: Colors.white, size: 20),
              label: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Profile Avatar with Blue Theme
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [primaryBlue, lightBlue],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: primaryBlue.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryBlue, darkBlue],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // User Name
              Text(
                nameController.text.isNotEmpty ? nameController.text : "User",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 8),

              // Verified Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryBlue.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, color: primaryBlue, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Verified User",
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Title
              const Text(
                "Update Your Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Keep your profile up to date",
                style: TextStyle(
                  fontSize: 14,
                  color: textGray,
                ),
              ),

              const SizedBox(height: 30),

              // Form Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: bgWhite,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Full Name
                    _buildEnhancedTextField(
                      controller: nameController,
                      label: "Full Name",
                      icon: Icons.person_outline,
                      hint: "Enter your full name",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Phone Number
                    _buildEnhancedTextField(
                      controller: phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      hint: "Enter your phone number",
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your phone number";
                        }
                        if (value.length < 10) {
                          return "Please enter a valid phone number";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Address
                    _buildEnhancedTextField(
                      controller: addressController,
                      label: "Address",
                      icon: Icons.location_on_outlined,
                      hint: "Enter your address",
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your address";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: saving
                    ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const CircularProgressIndicator(
                      color: primaryBlue,
                    ),
                  ),
                )
                    : ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryBlue, darkBlue],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_outlined, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Save Changes",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 16,
                    color: textGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textGray,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 15,
            ),
            prefixIcon: Icon(
              icon,
              color: primaryBlue,
              size: 22,
            ),
            filled: true,
            fillColor: bgLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryBlue.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryBlue.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: const TextStyle(
            fontSize: 15,
            color: textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}