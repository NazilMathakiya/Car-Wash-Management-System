import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageServicesPage extends StatefulWidget {
  const ManageServicesPage({super.key});

  @override
  State<ManageServicesPage> createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends State<ManageServicesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Modern Deep Blue Colors
  static const deepBlue1 = Color(0xFF0D47A1);
  static const deepBlue2 = Color(0xFF1976D2);
  static const lightBlue = Color(0xFF42A5F5);
  static const bgLight = Color(0xFFF5F7FA);
  static const bgWhite = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF212121);
  static const textGray = Color(0xFF757575);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Photo Background
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: deepBlue2,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Add Service Button
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                ),
                onPressed: () {
                  _showAddUpdateBottomSheet(context);
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Photo Background with Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          deepBlue1,
                          deepBlue2,
                          lightBlue,
                        ],
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.15,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=800',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(),
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          deepBlue2.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    left: 20,
                    bottom: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Manage Services",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "View and manage all car wash services",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Box
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: bgWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search services by name or description...",
                    hintStyle: TextStyle(color: textGray.withOpacity(0.6), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: deepBlue2, size: 24),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear_rounded, color: textGray, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    filled: true,
                    fillColor: bgWhite,
                  ),
                ),
              ),
            ),
          ),

          // Services List
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('services').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: deepBlue2),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmptyState());
              }

              // Filter services based on search query
              var filteredDocs = snapshot.data!.docs.where((doc) {
                if (_searchQuery.isEmpty) return true;
                var data = doc.data() as Map<String, dynamic>;
                String name = (data['serviceName'] ?? '').toString().toLowerCase();
                String description = (data['description'] ?? '').toString().toLowerCase();
                return name.contains(_searchQuery) || description.contains(_searchQuery);
              }).toList();

              if (filteredDocs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded, size: 64, color: textGray.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            "No services found",
                            style: TextStyle(fontSize: 16, color: textGray, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Try a different search term",
                            style: TextStyle(fontSize: 13, color: textGray.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      var doc = filteredDocs[index];
                      var data = doc.data() as Map<String, dynamic>;

                      String serviceName = data['serviceName'] ?? 'Unknown Service';
                      String description = data['description'] ?? 'No description';
                      int price = data['price'] ?? 0;
                      String? imageUrl = data['imageUrl'];

                      return _buildCompactServiceCard(
                        context,
                        doc.id,
                        serviceName,
                        description,
                        price,
                        imageUrl,
                        data,
                      );
                    },
                    childCount: filteredDocs.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Compact Service Card Widget
  Widget _buildCompactServiceCard(
      BuildContext context,
      String docId,
      String serviceName,
      String description,
      int price,
      String? imageUrl,
      Map<String, dynamic> data,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showServiceDetailsSheet(context, docId, serviceName, description, price, imageUrl, data),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Service Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                  )
                      : _buildPlaceholderImage(),
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: textGray.withOpacity(0.8),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: lightBlue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.currency_rupee, size: 13, color: deepBlue2),
                            Text(
                              '$price',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: deepBlue2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: textGray.withOpacity(0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Placeholder Image Widget
  Widget _buildPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.local_car_wash_rounded,
          size: 40,
          color: lightBlue.withOpacity(0.5),
        ),
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: lightBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_car_wash_rounded,
                size: 64,
                color: lightBlue.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Services Yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap + to add your first service",
              style: TextStyle(
                fontSize: 14,
                color: textGray.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Service Details Bottom Sheet
  void _showServiceDetailsSheet(
      BuildContext context,
      String docId,
      String serviceName,
      String description,
      int price,
      String? imageUrl,
      Map<String, dynamic> data,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: bgWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            // Handle Bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textGray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Service Image
            if (imageUrl != null && imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildLargePlaceholder(),
                ),
              )
            else
              _buildLargePlaceholder(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Name
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            serviceName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: textGray.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded, size: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Price Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: lightBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.currency_rupee, size: 20, color: deepBlue2),
                          const SizedBox(width: 4),
                          Text(
                            '$price',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: deepBlue2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Description
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textGray,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: textDark,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepBlue2,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showAddUpdateBottomSheet(context, docId: docId, currentData: data);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.edit_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Update",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteDialog(docId, serviceName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.delete_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Delete",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
    );
  }

  // Large Placeholder for Details Sheet
  Widget _buildLargePlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: lightBlue.withOpacity(0.1),
      ),
      child: Center(
        child: Icon(
          Icons.local_car_wash_rounded,
          size: 80,
          color: lightBlue.withOpacity(0.5),
        ),
      ),
    );
  }

  // Delete Confirmation Dialog
  void _showDeleteDialog(String docId, String serviceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.warning_rounded, color: Colors.red, size: 28),
            ),
            const SizedBox(width: 12),
            const Text(
              "Delete Service?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to delete '$serviceName'? This action cannot be undone.",
          style: const TextStyle(color: textGray, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: textGray, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _deleteService(docId);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Delete Service Function
  Future<void> _deleteService(String docId) async {
    try {
      await _firestore.collection('services').doc(docId).delete();
      _showSnackBar("Service Deleted Successfully ✓", Colors.red);
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    }
  }

  // Show Add/Update Bottom Sheet
  void _showAddUpdateBottomSheet(BuildContext context, {String? docId, Map<String, dynamic>? currentData}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddUpdateServiceBottomSheet(
        docId: docId,
        currentData: currentData,
      ),
    );
  }

  // SnackBar
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
}

// ============================================
// ADD/UPDATE SERVICE BOTTOM SHEET
// ============================================

class AddUpdateServiceBottomSheet extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? currentData;

  const AddUpdateServiceBottomSheet({
    super.key,
    this.docId,
    this.currentData,
  });

  @override
  State<AddUpdateServiceBottomSheet> createState() => _AddUpdateServiceBottomSheetState();
}

class _AddUpdateServiceBottomSheetState extends State<AddUpdateServiceBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  bool _loading = false;
  XFile? _selectedImage;
  String? _currentImageUrl;

  // Cloudinary Credentials
  static const String cloudinaryCloudName = "dttplfqeu";
  static const String cloudinaryUploadPreset = "flutter_services";

  // Colors
  static const deepBlue1 = Color(0xFF0D47A1);
  static const deepBlue2 = Color(0xFF1976D2);
  static const lightBlue = Color(0xFF42A5F5);
  static const bgLight = Color(0xFFF5F7FA);
  static const bgWhite = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF212121);
  static const textGray = Color(0xFF757575);

  @override
  void initState() {
    super.initState();
    if (widget.currentData != null) {
      _nameController.text = widget.currentData!['serviceName'] ?? '';
      _descController.text = widget.currentData!['description'] ?? '';
      _priceController.text = widget.currentData!['price']?.toString() ?? '';
      _currentImageUrl = widget.currentData!['imageUrl'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Pick Image
  Future<void> pickImage() async {
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

  // Upload to Cloudinary
  Future<String?> uploadToCloudinary(XFile imageFile) async {
    try {
      final url = Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload');

      var request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = cloudinaryUploadPreset;
      request.fields['folder'] = 'services';

      if (kIsWeb) {
        var bytes = await imageFile.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: imageFile.name,
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseString);
        return jsonResponse['secure_url'];
      }
      return null;
    } catch (e) {
      print('Cloudinary error: $e');
      return null;
    }
  }

  // Add or Update Service
  Future<void> saveService() async {
    String name = _nameController.text.trim();
    String desc = _descController.text.trim();
    String priceText = _priceController.text.trim();

    if (name.isEmpty || desc.isEmpty || priceText.isEmpty) {
      _showSnackBar("All fields are required", Colors.red);
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      String? imageUrl = _currentImageUrl;

      // Upload new image if selected
      if (_selectedImage != null) {
        imageUrl = await uploadToCloudinary(_selectedImage!);
        if (imageUrl == null) {
          _showSnackBar("Image upload failed", Colors.red);
          setState(() {
            _loading = false;
          });
          return;
        }
      }

      int price = int.parse(priceText);

      if (widget.docId == null) {
        // Add New Service
        await _firestore.collection('services').add({
          "serviceName": name,
          "description": desc,
          "price": price,
          "imageUrl": imageUrl,
          "createdAt": FieldValue.serverTimestamp(),
        });
        _showSnackBar("Service Added Successfully 🎉", deepBlue2);
      } else {
        // Update Existing Service
        await _firestore.collection('services').doc(widget.docId).update({
          "serviceName": name,
          "description": desc,
          "price": price,
          "imageUrl": imageUrl,
          "updatedAt": FieldValue.serverTimestamp(),
        });
        _showSnackBar("Service Updated Successfully ✓", deepBlue2);
      }

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

  @override
  Widget build(BuildContext context) {
    bool isUpdate = widget.docId != null;

    return Container(
      decoration: const BoxDecoration(
        color: bgWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isUpdate ? "Update Service" : "Add Service",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: textGray.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, size: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Image Picker
              const Text(
                "Service Image",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: lightBlue, width: 2, style: BorderStyle.solid),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: kIsWeb
                        ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                        : Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
                  )
                      : _currentImageUrl != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(_currentImageUrl!, fit: BoxFit.cover),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_rounded, size: 50, color: lightBlue),
                      const SizedBox(height: 8),
                      const Text(
                        "Tap to upload image",
                        style: TextStyle(color: textGray, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Service Name
              const Text(
                "Service Name *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter service name",
                  filled: true,
                  fillColor: bgLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                "Description *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter service description",
                  filled: true,
                  fillColor: bgLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Price
              const Text(
                "Price *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter price",
                  prefixText: "₹ ",
                  filled: true,
                  fillColor: bgLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepBlue2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: _loading ? null : saveService,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                      : Text(
                    isUpdate ? "Update Service" : "Add Service",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}