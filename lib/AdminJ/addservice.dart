// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'bottom_nav.dart';
//
//
// class AddServicePage extends StatefulWidget {
//   const AddServicePage({super.key});
//
//   @override
//   State<AddServicePage> createState() => _AddServicePageState();
// }
//
// class _AddServicePageState extends State<AddServicePage> {
//   final _nameController = TextEditingController();
//   final _descController = TextEditingController();
//   final _priceController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   bool _loading = false;
//
//   // Modern Blue Color Palette
//   static const bgLight = Color(0xFFFAFAFA);
//   static const bgWhite = Color(0xFFFFFFFF);
//   static const primaryBlue = Color(0xFF2196F3);
//   static const accentBlue = Color(0xFF03A9F4);
//   static const lightBlue = Color(0xFF4FC3F7);
//   static const textDark = Color(0xFF212121);
//   static const textGray = Color(0xFF757575);
//
//   Future<void> addService() async {
//     String name = _nameController.text.trim();
//     String desc = _descController.text.trim();
//     String priceText = _priceController.text.trim();
//
//     if (name.isEmpty || desc.isEmpty || priceText.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("All fields are required"),
//           backgroundColor: Colors.red.shade400,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     }
//
//     setState(() {
//       _loading = true;
//     });
//
//     try {
//       int price = int.parse(priceText);
//
//       await _firestore.collection('services').add({
//         "serviceName": name,
//         "description": desc,
//         "price": price,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("Service Added Successfully 🎉"),
//           backgroundColor: primaryBlue,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//
//       Navigator.pop(context);
//
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error: $e"),
//           backgroundColor: Colors.red.shade400,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     }
//
//     setState(() {
//       _loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgLight,
//
//       appBar: AppBar(
//         backgroundColor: bgWhite,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: primaryBlue.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(Icons.arrow_back_rounded, color: primaryBlue, size: 20),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [primaryBlue.withOpacity(0.2), accentBlue.withOpacity(0.1)],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(Icons.add_circle_outline_rounded, color: primaryBlue, size: 22),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               "Add New Service",
//               style: TextStyle(
//                 color: textDark,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: -0.3,
//               ),
//             ),
//           ],
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Card
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [primaryBlue.withOpacity(0.1), accentBlue.withOpacity(0.05)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: primaryBlue.withOpacity(0.2), width: 1),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [primaryBlue, accentBlue],
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: primaryBlue.withOpacity(0.3),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(Icons.local_car_wash_rounded, color: Colors.white, size: 28),
//                   ),
//                   const SizedBox(width: 16),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Service Information",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: textDark,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           "Fill in the details below",
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: textGray,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Service Name Field
//             _buildLabel("Service Name", Icons.handyman_rounded),
//             const SizedBox(height: 10),
//             _buildTextField(
//               controller: _nameController,
//               hint: "e.g., Premium Car Wash",
//               icon: Icons.handyman_rounded,
//             ),
//
//             const SizedBox(height: 24),
//
//             // Service Description Field
//             _buildLabel("Service Description", Icons.description_rounded),
//             const SizedBox(height: 10),
//             _buildTextField(
//               controller: _descController,
//               hint: "Describe the service in detail...",
//               icon: Icons.description_rounded,
//               maxLines: 4,
//               minLines: 3,
//             ),
//
//             const SizedBox(height: 24),
//
//             // Service Price Field
//             _buildLabel("Service Price", Icons.payments_rounded),
//             const SizedBox(height: 10),
//             _buildTextField(
//               controller: _priceController,
//               hint: "Enter price amount",
//               icon: Icons.payments_rounded,
//               keyboardType: TextInputType.number,
//               prefix: const Text(
//                 "₹ ",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: primaryBlue,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 40),
//
//             // Add Button
//             Container(
//               width: double.infinity,
//               height: 56,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [primaryBlue, accentBlue],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: primaryBlue.withOpacity(0.4),
//                     blurRadius: 16,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 onPressed: _loading ? null : addService,
//                 child: _loading
//                     ? const SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2.5,
//                   ),
//                 )
//                     : const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.add_circle_rounded, color: Colors.white, size: 22),
//                     SizedBox(width: 10),
//                     Text(
//                       "Add Service",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.3,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//
//       bottomNavigationBar: const GlassBottomNav(currentIndex: 1),
//     );
//   }
//
//   Widget _buildLabel(String text, IconData icon) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: primaryBlue.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, size: 16, color: primaryBlue),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//             color: textDark,
//             letterSpacing: -0.2,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     TextInputType? keyboardType,
//     int? maxLines,
//     int? minLines,
//     Widget? prefix,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: bgWhite,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines ?? 1,
//         minLines: minLines ?? 1,
//         style: const TextStyle(
//           fontSize: 15,
//           color: textDark,
//           fontWeight: FontWeight.w500,
//         ),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(
//             color: textGray.withOpacity(0.6),
//             fontSize: 14,
//           ),
//           prefixIcon: Container(
//             margin: const EdgeInsets.all(12),
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [primaryBlue.withOpacity(0.15), accentBlue.withOpacity(0.1)],
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: primaryBlue, size: 20),
//           ),
//           prefix: prefix,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: primaryBlue, width: 2),
//           ),
//           filled: true,
//           fillColor: bgWhite,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'bottom_nav.dart';
//
//
// class AddServicePage extends StatefulWidget {
//   const AddServicePage({super.key});
//
//   @override
//   State<AddServicePage> createState() => _AddServicePageState();
// }
//
// class _AddServicePageState extends State<AddServicePage> {
//   final _nameController = TextEditingController();
//   final _descController = TextEditingController();
//   final _priceController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   bool _loading = false;
//
//   // Modern Blue Color Palette
//   static const bgLight = Color(0xFFFAFAFA);
//   static const bgWhite = Color(0xFFFFFFFF);
//   static const primaryBlue = Color(0xFF2196F3);
//   static const accentBlue = Color(0xFF03A9F4);
//   static const lightBlue = Color(0xFF4FC3F7);
//   static const textDark = Color(0xFF212121);
//   static const textGray = Color(0xFF757575);
//
//   Future<void> addService() async {
//     String name = _nameController.text.trim();
//     String desc = _descController.text.trim();
//     String priceText = _priceController.text.trim();
//
//     if (name.isEmpty || desc.isEmpty || priceText.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("All fields are required"),
//           backgroundColor: Colors.red.shade400,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     }
//
//     setState(() {
//       _loading = true;
//     });
//
//     try {
//       int price = int.parse(priceText);
//
//       await _firestore.collection('services').add({
//         "serviceName": name,
//         "description": desc,
//         "price": price,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("Service Added Successfully 🎉"),
//           backgroundColor: primaryBlue,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//
//       Navigator.pop(context);
//
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error: $e"),
//           backgroundColor: Colors.red.shade400,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     }
//
//     setState(() {
//       _loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgLight,
//
//       appBar: AppBar(
//         backgroundColor: bgWhite,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: primaryBlue.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(Icons.arrow_back_rounded, color: primaryBlue, size: 20),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [primaryBlue.withOpacity(0.2), accentBlue.withOpacity(0.1)],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(Icons.add_circle_outline_rounded, color: primaryBlue, size: 22),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               "Add New Service",
//               style: TextStyle(
//                 color: textDark,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: -0.3,
//               ),
//             ),
//           ],
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Card
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [primaryBlue.withOpacity(0.1), accentBlue.withOpacity(0.05)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: primaryBlue.withOpacity(0.2), width: 1),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [primaryBlue, accentBlue],
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: primaryBlue.withOpacity(0.3),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(Icons.local_car_wash_rounded, color: Colors.white, size: 28),
//                   ),
//                   const SizedBox(width: 16),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Service Information",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: textDark,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           "Fill in the details below",
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: textGray,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Service Name Field
//             _buildLabel("Service Name", Icons.handyman_rounded),
//             const SizedBox(height: 10),
//             _buildTextField(
//               controller: _nameController,
//               hint: "e.g., Premium Car Wash",
//               icon: Icons.handyman_rounded,
//             ),
//
//             const SizedBox(height: 24),
//
//             // Service Description Field
//             _buildLabel("Service Description", Icons.description_rounded),
//             const SizedBox(height: 10),
//             _buildTextField(
//               controller: _descController,
//               hint: "Describe the service in detail...",
//               icon: Icons.description_rounded,
//               maxLines: 4,
//               minLines: 3,
//             ),
//
//             const SizedBox(height: 24),
//
//             // Service Price Field
//             _buildLabel("Service Price", Icons.payments_rounded),
//             const SizedBox(height: 10),
//             _buildTextField(
//               controller: _priceController,
//               hint: "Enter price amount",
//               icon: Icons.payments_rounded,
//               keyboardType: TextInputType.number,
//               prefix: const Text(
//                 "₹ ",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: primaryBlue,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 40),
//
//             // Add Button
//             Container(
//               width: double.infinity,
//               height: 56,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [primaryBlue, accentBlue],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: primaryBlue.withOpacity(0.4),
//                     blurRadius: 16,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 onPressed: _loading ? null : addService,
//                 child: _loading
//                     ? const SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2.5,
//                   ),
//                 )
//                     : const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.add_circle_rounded, color: Colors.white, size: 22),
//                     SizedBox(width: 10),
//                     Text(
//                       "Add Service",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.3,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//
//       bottomNavigationBar: const GlassBottomNav(currentIndex: 1),
//     );
//   }
//
//   Widget _buildLabel(String text, IconData icon) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: primaryBlue.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, size: 16, color: primaryBlue),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//             color: textDark,
//             letterSpacing: -0.2,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     TextInputType? keyboardType,
//     int? maxLines,
//     int? minLines,
//     Widget? prefix,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: bgWhite,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines ?? 1,
//         minLines: minLines ?? 1,
//         style: const TextStyle(
//           fontSize: 15,
//           color: textDark,
//           fontWeight: FontWeight.w500,
//         ),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(
//             color: textGray.withOpacity(0.6),
//             fontSize: 14,
//           ),
//           prefixIcon: Container(
//             margin: const EdgeInsets.all(12),
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [primaryBlue.withOpacity(0.15), accentBlue.withOpacity(0.1)],
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: primaryBlue, size: 20),
//           ),
//           prefix: prefix,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: primaryBlue, width: 2),
//           ),
//           filled: true,
//           fillColor: bgWhite,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  bool _loading = false;
  XFile? _selectedImage; // XFile for cross-platform support
  String? _imagePreviewUrl;

  // 🔥 CLOUDINARY CREDENTIALS
  static const String cloudinaryCloudName = "dttplfqeu";
  static const String cloudinaryUploadPreset = "flutter_services";

  // Modern Blue Color Palette
  static const bgLight = Color(0xFFFAFAFA);
  static const bgWhite = Color(0xFFFFFFFF);
  static const primaryBlue = Color(0xFF2196F3);
  static const accentBlue = Color(0xFF03A9F4);
  static const textDark = Color(0xFF212121);
  static const textGray = Color(0xFF757575);

  // Gallery se Image Pick
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
      }
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    }
  }

  // Camera se Image Capture
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
      }
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    }
  }

  // Cloudinary Upload Function (Web + Mobile Compatible)
  Future<String?> uploadToCloudinary(XFile imageFile) async {
    try {
      final url = Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload'
      );

      var request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = cloudinaryUploadPreset;
      request.fields['folder'] = 'services';

      // Web and Mobile compatible
      if (kIsWeb) {
        // For Web
        var bytes = await imageFile.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: imageFile.name,
        ));
      } else {
        // For Mobile
        request.files.add(
            await http.MultipartFile.fromPath('file', imageFile.path)
        );
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseString);
        return jsonResponse['secure_url'];
      } else {
        print('Upload failed: $responseString');
        return null;
      }
    } catch (e) {
      print('Cloudinary error: $e');
      return null;
    }
  }

  // Service Add Function
  Future<void> addService() async {
    String name = _nameController.text.trim();
    String desc = _descController.text.trim();
    String priceText = _priceController.text.trim();

    if (name.isEmpty || desc.isEmpty || priceText.isEmpty) {
      _showSnackBar("All fields are required", Colors.red);
      return;
    }

    if (_selectedImage == null) {
      _showSnackBar("Please select an image", Colors.red);
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      // Upload image to Cloudinary
      String? imageUrl = await uploadToCloudinary(_selectedImage!);

      if (imageUrl == null) {
        _showSnackBar("Image upload failed", Colors.red);
        setState(() {
          _loading = false;
        });
        return;
      }

      // Save to Firestore
      int price = int.parse(priceText);

      await _firestore.collection('services').add({
        "serviceName": name,
        "description": desc,
        "price": price,
        "imageUrl": imageUrl,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _showSnackBar("Service Added Successfully 🎉", primaryBlue);
      Navigator.pop(context);

    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    }

    setState(() {
      _loading = false;
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: bgWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select Image Source",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: "Gallery",
                    onTap: () {
                      Navigator.pop(context);
                      pickImageFromGallery();
                    },
                  ),
                ),
                if (!kIsWeb) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.camera_alt_rounded,
                      label: "Camera",
                      onTap: () {
                        Navigator.pop(context);
                        pickImageFromCamera();
                      },
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue.withOpacity(0.1), accentBlue.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryBlue.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryBlue, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: textDark,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgWhite,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: primaryBlue, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBlue.withOpacity(0.2), accentBlue.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_circle_outline_rounded, color: primaryBlue, size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              "Add New Service",
              style: TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBlue.withOpacity(0.1), accentBlue.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryBlue.withOpacity(0.2), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryBlue, accentBlue],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.local_car_wash_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Fill in the details below",
                          style: TextStyle(
                            fontSize: 13,
                            color: textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // IMAGE PICKER (Web + Mobile Compatible)
            _buildLabel("Service Image", Icons.image_rounded),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: bgWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedImage != null ? primaryBlue : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Web and Mobile Compatible Image Display
                      kIsWeb
                          ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                          : Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.red.shade400,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 20),
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryBlue.withOpacity(0.1), accentBlue.withOpacity(0.05)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add_photo_alternate_rounded, size: 48, color: primaryBlue),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Tap to select image",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textGray,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Service Name
            _buildLabel("Service Name", Icons.handyman_rounded),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _nameController,
              hint: "e.g., Premium Car Wash",
              icon: Icons.handyman_rounded,
            ),

            const SizedBox(height: 24),

            // Description
            _buildLabel("Service Description", Icons.description_rounded),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _descController,
              hint: "Describe the service in detail...",
              icon: Icons.description_rounded,
              maxLines: 4,
              minLines: 3,
            ),

            const SizedBox(height: 24),

            // Price
            _buildLabel("Service Price", Icons.payments_rounded),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _priceController,
              hint: "Enter price amount",
              icon: Icons.payments_rounded,
              keyboardType: TextInputType.number,
              prefix: const Text(
                "₹ ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Add Button
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
                onPressed: _loading ? null : addService,
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
                    Icon(Icons.add_circle_rounded, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text(
                      "Add Service",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: primaryBlue),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textDark,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    int? minLines,
    Widget? prefix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
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
          prefix: prefix,
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
          fillColor: bgWhite,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}