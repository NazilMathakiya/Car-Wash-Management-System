import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageBookingScreen extends StatefulWidget {
  const ManageBookingScreen({super.key});

  @override
  State<ManageBookingScreen> createState() => _ManageBookingScreenState();
}

class _ManageBookingScreenState extends State<ManageBookingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, pending, completed, cancelled

  // Enhanced Color Palette
  static const bgLight = Color(0xFFF5F7FA);
  static const bgWhite = Color(0xFFFFFFFF);
  static const deepBlue1 = Color(0xFF0D47A1);
  static const deepBlue2 = Color(0xFF1976D2);
  static const lightBlue = Color(0xFF42A5F5);
  static const textDark = Color(0xFF212121);
  static const textGray = Color(0xFF757575);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFF59E0B);
      case "completed":
        return const Color(0xFF10B981);
      case "cancelled":
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Icons.schedule_rounded;
      case "completed":
        return Icons.check_circle_rounded;
      case "cancelled":
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Future<void> deleteBooking(String id) async {
    await FirebaseFirestore.instance.collection("bookings").doc(id).delete();
    _showSnackBar("Booking deleted successfully ✓", const Color(0xFFEF4444));
  }

  Future<void> updateBookingStatus(String id, String newStatus) async {
    await FirebaseFirestore.instance.collection("bookings").doc(id).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    _showSnackBar("Status updated successfully ✓", getStatusColor(newStatus));
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

  void showStatusUpdateDialog(String id, String currentStatus) {
    String selectedStatus = currentStatus.toLowerCase();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgWhite,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightBlue.withOpacity(0.2), lightBlue.withOpacity(0.1)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_calendar_rounded, color: deepBlue2, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                "Update Status",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Change the booking status",
                style: TextStyle(
                  fontSize: 14,
                  color: textGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // Status Options
              StatefulBuilder(
                builder: (context, setDialogState) {
                  return Column(
                    children: [
                      _buildStatusOption(
                        "Pending",
                        Icons.schedule_rounded,
                        const Color(0xFFF59E0B),
                        selectedStatus == "pending",
                            () {
                          setDialogState(() {
                            selectedStatus = "pending";
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildStatusOption(
                        "Completed",
                        Icons.check_circle_rounded,
                        const Color(0xFF10B981),
                        selectedStatus == "completed",
                            () {
                          setDialogState(() {
                            selectedStatus = "completed";
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildStatusOption(
                        "Cancelled",
                        Icons.cancel_rounded,
                        const Color(0xFFEF4444),
                        selectedStatus == "cancelled",
                            () {
                          setDialogState(() {
                            selectedStatus = "cancelled";
                          });
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: textGray,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        updateBookingStatus(id, selectedStatus);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepBlue2,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusOption(
      String label,
      IconData icon,
      Color color,
      bool isSelected,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : bgLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : textDark,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<String> getUserName(String uid) async {
    if (uid.isEmpty) return "N/A";

    try {
      var doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (doc.exists) return doc["name"] ?? "N/A";
    } catch (e) {
      print("User fetch error: $e");
    }
    return "N/A";
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: bgWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    const Text(
                      "Filter Bookings",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: textGray.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Filter Options
                _buildFilterOption("All Bookings", 'all', Icons.list_alt_rounded),
                const SizedBox(height: 12),
                _buildFilterOption("Pending", 'pending', Icons.schedule_rounded),
                const SizedBox(height: 12),
                _buildFilterOption("Completed", 'completed', Icons.check_circle_rounded),
                const SizedBox(height: 12),
                _buildFilterOption("Cancelled", 'cancelled', Icons.cancel_rounded),
                const SizedBox(height: 20),

                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepBlue2,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Apply Filter",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, String value, IconData icon) {
    bool isSelected = _filterStatus == value;
    Color statusColor = value == 'all'
        ? deepBlue2
        : value == 'pending'
        ? const Color(0xFFF59E0B)
        : value == 'completed'
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);

    return GestureDetector(
      onTap: () {
        setState(() {
          _filterStatus = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? statusColor.withOpacity(0.15) : bgLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? statusColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: statusColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? statusColor : textDark,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
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
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Photo Background
          SliverAppBar(
            expandedHeight: 160,
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
              // Filter Button
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      const Icon(Icons.filter_list_rounded, color: Colors.white, size: 24),
                      if (_filterStatus != 'all')
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                onPressed: _showFilterBottomSheet,
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient Background
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
                  ),
                  // Pattern Overlay
                  Opacity(
                    opacity: 0.1,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=800'),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {
                            // Silently handle image load error
                          },
                        ),
                      ),
                    ),
                  ),
                  // Dark Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          deepBlue2.withOpacity(0.7),
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
                          "Manage Bookings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Update and manage all bookings",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            letterSpacing: 0.2,
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
                    hintText: "Search bookings by name, vehicle, or service...",
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

          // Bookings List
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("bookings")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: deepBlue2),
                    ),
                  ),
                );
              }

              var bookings = snapshot.data!.docs;

              // Sort by timestamp (newest first)
              bookings.sort((a, b) {
                var aData = a.data() as Map<String, dynamic>;
                var bData = b.data() as Map<String, dynamic>;

                // Try to get timestamp
                var aTimestamp = aData['timestamp'];
                var bTimestamp = bData['timestamp'];

                if (aTimestamp != null && bTimestamp != null) {
                  if (aTimestamp is Timestamp && bTimestamp is Timestamp) {
                    return bTimestamp.compareTo(aTimestamp); // Descending order
                  }
                }
                return 0;
              });

              // Apply filters
              var filteredBookings = bookings.where((booking) {
                var data = booking.data() as Map<String, dynamic>;
                String status = (data["status"] ?? "pending").toLowerCase();

                // Filter by status
                if (_filterStatus != 'all' && status != _filterStatus) {
                  return false;
                }

                // Filter by search query
                if (_searchQuery.isNotEmpty) {
                  String vehicleNumber = (data["vehicleNumber"] ?? "").toLowerCase();
                  String serviceName = (data["serviceName"] ?? "").toLowerCase();
                  return vehicleNumber.contains(_searchQuery) || serviceName.contains(_searchQuery);
                }

                return true;
              }).toList();

              if (filteredBookings.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
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
                              _searchQuery.isNotEmpty || _filterStatus != 'all'
                                  ? Icons.search_off_rounded
                                  : Icons.event_busy_rounded,
                              size: 64,
                              color: lightBlue.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _searchQuery.isNotEmpty || _filterStatus != 'all'
                                ? "No bookings found"
                                : "No bookings yet",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty || _filterStatus != 'all'
                                ? "Try a different search or filter"
                                : "Bookings will appear here",
                            style: TextStyle(
                              fontSize: 14,
                              color: textGray.withOpacity(0.8),
                            ),
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
                      var booking = filteredBookings[index];
                      var data = booking.data() as Map<String, dynamic>;

                      String userId = data["uid"] ?? data["userId"] ?? "";
                      String status = data["status"] ?? "pending";

                      return FutureBuilder(
                        future: getUserName(userId),
                        builder: (context, snap) {
                          String userName = snap.data ?? "N/A";

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: bgWhite,
                              borderRadius: BorderRadius.circular(18),
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
                                borderRadius: BorderRadius.circular(18),
                                onTap: () => _showBookingDetailsSheet(context, booking.id, userName, data, status),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      // Header Row
                                      Row(
                                        children: [
                                          // Avatar
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [deepBlue2, lightBlue],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),

                                          // User Info
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: textDark,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  data["vehicleNumber"] ?? "N/A",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: textGray.withOpacity(0.8),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Status Badge
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: getStatusColor(status).withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  getStatusIcon(status),
                                                  size: 14,
                                                  color: getStatusColor(status),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  status[0].toUpperCase() + status.substring(1),
                                                  style: TextStyle(
                                                    color: getStatusColor(status),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),

                                      // Booking Details
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: bgLight,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            _buildCompactDetailRow(
                                              Icons.cleaning_services_rounded,
                                              data["serviceName"] ?? "N/A",
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildCompactDetailRow(
                                                    Icons.calendar_today_rounded,
                                                    data["date"] ?? "N/A",
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: _buildCompactDetailRow(
                                                    Icons.access_time_rounded,
                                                    data["time"] ?? "N/A",
                                                  ),
                                                ),
                                              ],
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
                        },
                      );
                    },
                    childCount: filteredBookings.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDetailRow(IconData icon, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: lightBlue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: deepBlue2),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Booking Details Bottom Sheet
  void _showBookingDetailsSheet(
      BuildContext context,
      String bookingId,
      String userName,
      Map<String, dynamic> data,
      String status,
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

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [deepBlue2, lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "ID: ${bookingId.substring(0, 8)}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: textGray,
                          ),
                        ),
                      ],
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
            ),

            const Divider(height: 1),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: getStatusColor(status).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getStatusIcon(status),
                            size: 18,
                            color: getStatusColor(status),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: getStatusColor(status),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Booking Details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: bgLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            Icons.cleaning_services_rounded,
                            "Service",
                            data["serviceName"] ?? "N/A",
                          ),
                          const SizedBox(height: 14),
                          _buildDetailRow(
                            Icons.calendar_today_rounded,
                            "Date",
                            data["date"] ?? "N/A",
                          ),
                          const SizedBox(height: 14),
                          _buildDetailRow(
                            Icons.access_time_rounded,
                            "Time",
                            data["time"] ?? "N/A",
                          ),
                          const SizedBox(height: 14),
                          _buildDetailRow(
                            Icons.directions_car_rounded,
                            "Vehicle",
                            data["vehicleNumber"] ?? "N/A",
                          ),
                        ],
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
                      onPressed: () {
                        Navigator.pop(context);
                        showStatusUpdateDialog(bookingId, status);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepBlue2,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
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
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteDialog(bookingId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: lightBlue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: deepBlue2),
        ),
        const SizedBox(width: 12),
        Text(
          "$label:",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textGray,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(String bookingId) {
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
              "Delete Booking?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to delete this booking? This action cannot be undone.",
          style: TextStyle(color: textGray, fontSize: 15),
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
              await deleteBooking(bookingId);
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
}