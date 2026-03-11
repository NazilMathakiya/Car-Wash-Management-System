import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return const Color(0xFF10B981);
      case "cancelled":
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Icons.check_circle_rounded;
      case "cancelled":
        return Icons.cancel_rounded;
      default:
        return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsList(userId, null),
                  _buildBookingsList(userId, 'Pending'),
                  _buildBookingsList(userId, 'Completed'),
                  _buildBookingsList(userId, 'Cancelled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: _buildHeaderTop(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: _buildTabs(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Bookings',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Track your car wash services',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 28),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: const Color(0xFF1E40AF),
        unselectedLabelColor: Colors.white.withOpacity(0.85),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Pending'),
          Tab(text: 'Completed'),
          Tab(text: 'Cancelled'),
        ],
      ),
    );
  }

  Widget _buildBookingsList(String userId, String? statusFilter) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("bookings")
          .where("uid", isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
          );
        }

        var bookings = snapshot.data!.docs;

        if (statusFilter != null) {
          bookings = bookings.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final status = data["status"] ?? "Pending";
            return status.toLowerCase() == statusFilter.toLowerCase();
          }).toList();
        }

        if (bookings.isEmpty) {
          return _buildEmptyState(statusFilter);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            var data = bookings[index].data() as Map<String, dynamic>;
            final status = data["status"] ?? "Pending";
            final bookingId = bookings[index].id;

            return _buildBookingCard(
              data: data,
              status: status,
              bookingId: bookingId,
            );
          },
        );
      },
    );
  }

  Widget _buildBookingCard({
    required Map<String, dynamic> data,
    required String status,
    required String bookingId,
  }) {
    final isCompleted = status.toLowerCase() == "completed";
    final isCancelled = status.toLowerCase() == "cancelled";

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(status).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔥 CRITICAL FIX
        children: [
          _buildCardHeader(data, status),
          _buildCardDetails(data, status, bookingId, isCompleted, isCancelled),
        ],
      ),
    );
  }

  Widget _buildCardHeader(Map<String, dynamic> data, String status) {
    return Container(
      padding: const EdgeInsets.all(16), // 🔥 REDUCED FROM 20 TO 16
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStatusColor(status).withOpacity(0.12),
            _getStatusColor(status).withOpacity(0.04),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          _buildServiceIcon(status),
          const SizedBox(width: 12), // 🔥 REDUCED FROM 16 TO 12
          Expanded( // 🔥 WRAPPED IN EXPANDED
            child: _buildServiceInfo(data),
          ),
          _buildStatusBadge(status),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(String status) {
    return Container(
      padding: const EdgeInsets.all(12), // 🔥 REDUCED FROM 14 TO 12
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(status).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.local_car_wash_rounded,
        color: _getStatusColor(status),
        size: 24, // 🔥 REDUCED FROM 26 TO 24
      ),
    );
  }

  Widget _buildServiceInfo(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 🔥 ADDED
      children: [
        Text(
          data['serviceName'] ?? "Service",
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16, // 🔥 REDUCED FROM 18 TO 16
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
          maxLines: 1, // 🔥 ADDED
          overflow: TextOverflow.ellipsis, // 🔥 ADDED
        ),
        const SizedBox(height: 4), // 🔥 REDUCED FROM 6 TO 4
        Wrap( // 🔥 CHANGED FROM ROW TO WRAP FOR BETTER RESPONSIVENESS
          spacing: 8,
          runSpacing: 4,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[600]), // 🔥 REDUCED FROM 15 TO 14
                const SizedBox(width: 4),
                Text(
                  data['time'] ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500), // 🔥 REDUCED FROM 13 TO 12
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  data['date'] ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // 🔥 REDUCED PADDING
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(status).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 🔥 ADDED
        children: [
          Icon(_getStatusIcon(status), size: 14, color: Colors.white), // 🔥 REDUCED FROM 16 TO 14
          const SizedBox(width: 4), // 🔥 REDUCED FROM 6 TO 4
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11, // 🔥 REDUCED FROM 13 TO 11
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetails(Map<String, dynamic> data, String status,
      String bookingId, bool isCompleted, bool isCancelled) {
    return Padding(
      padding: const EdgeInsets.all(16), // 🔥 REDUCED FROM 20 TO 16
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔥 ADDED
        children: [
          _buildPricingCard(data),
          if (isCompleted && !isCancelled) ...[
            const SizedBox(height: 12), // 🔥 REDUCED FROM 16 TO 12
            _buildReviewSection(bookingId, data),
          ],
          const SizedBox(height: 14), // 🔥 REDUCED FROM 18 TO 14
          _buildActionButtons(status, bookingId, data),
        ],
      ),
    );
  }

  Widget _buildPricingCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16), // 🔥 REDUCED FROM 18 TO 16
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔥 ADDED
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min, // 🔥 ADDED
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.currency_rupee_rounded, color: Colors.white, size: 16), // 🔥 REDUCED FROM 18 TO 16
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Service Price',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70), // 🔥 REDUCED FROM 14 TO 13
                  ),
                ],
              ),
              Text(
                '₹${data['price']}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white), // 🔥 REDUCED FROM 16 TO 15
              ),
            ],
          ),
          const SizedBox(height: 10), // 🔥 REDUCED FROM 12 TO 10
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min, // 🔥 ADDED
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.discount_rounded, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Discount',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
                  ),
                ],
              ),
              Text(
                '${data['discount']}%',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12), // 🔥 REDUCED FROM 14 TO 12
            child: Divider(color: Colors.white24, thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min, // 🔥 ADDED
                children: [
                  Icon(Icons.payments_rounded, color: Colors.white, size: 22), // 🔥 REDUCED FROM 24 TO 22
                  SizedBox(width: 10),
                  Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white), // 🔥 REDUCED FROM 16 TO 15
                  ),
                ],
              ),
              Text(
                '₹${data['totalAmount']}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white), // 🔥 REDUCED FROM 24 TO 22
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(String status, String bookingId, Map<String, dynamic> data) {
    final bool isCompleted = status.toLowerCase() == "completed";
    final bool isPending = status.toLowerCase() == "pending";
    final bool isCancelled = status.toLowerCase() == "cancelled";

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showBookingDetails(context, data),
            icon: const Icon(Icons.info_outline_rounded, size: 18), // 🔥 REDUCED FROM 20 TO 18
            label: const Text('Details'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14), // 🔥 REDUCED FROM 16 TO 14
              side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              foregroundColor: const Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (isPending)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showCancelDialog(context, bookingId),
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Cancel'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: const Color(0xFFEF4444).withOpacity(0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        if (isCompleted)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showReviewDialog(context, bookingId, data),
              icon: const Icon(Icons.star_rounded, size: 18),
              label: const Text('Review'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: const Color(0xFFF59E0B).withOpacity(0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        if (isCancelled)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block_rounded, size: 18, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Cancelled',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey.shade600), // 🔥 REDUCED FROM 15 TO 14
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewSection(String bookingId, Map<String, dynamic> data) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('reviews').doc(bookingId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Container(
            padding: const EdgeInsets.all(16), // 🔥 REDUCED FROM 18 TO 16
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFF59E0B).withOpacity(0.1), const Color(0xFFFBBF24).withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3), width: 1.5),
            ),
            child: const Row(
              children: [
                Icon(Icons.star_border_rounded, color: Color(0xFFF59E0B), size: 22), // 🔥 REDUCED FROM 24 TO 22
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Share your experience!',
                    style: TextStyle(fontSize: 14, color: Color(0xFF92400E), fontWeight: FontWeight.w600), // 🔥 REDUCED FROM 15 TO 14
                  ),
                ),
              ],
            ),
          );
        }

        final reviewData = snapshot.data!.data() as Map<String, dynamic>;
        final rating = reviewData['rating'] ?? 0;
        final comment = reviewData['comment'] ?? '';

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF10B981).withOpacity(0.1), const Color(0xFF34D399).withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // 🔥 ADDED
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20), // 🔥 REDUCED FROM 22 TO 20
                  const SizedBox(width: 10),
                  const Text(
                    'Your Review',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF065F46)), // 🔥 REDUCED FROM 15 TO 14
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min, // 🔥 ADDED
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: const Color(0xFFF59E0B),
                        size: 18, // 🔥 REDUCED FROM 20 TO 18
                      ),
                    ),
                  ),
                ],
              ),
              if (comment.isNotEmpty) ...[
                const SizedBox(height: 8), // 🔥 REDUCED FROM 10 TO 8
                Text(
                  comment,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4), // 🔥 REDUCED FROM 14 TO 13
                  maxLines: 2, // 🔥 ADDED
                  overflow: TextOverflow.ellipsis, // 🔥 ADDED
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  void _showReviewDialog(BuildContext context, String bookingId, Map<String, dynamic> bookingData) async {
    int selectedRating = 0;
    final TextEditingController commentController = TextEditingController();

    try {
      final doc = await FirebaseFirestore.instance.collection('reviews').doc(bookingId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        selectedRating = data['rating'] ?? 0;
        commentController.text = data['comment'] ?? '';
      }
    } catch (e) {
      print("Error fetching review: $e");
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // 🔥 GET SCREEN WIDTH FOR RESPONSIVE DESIGN
            final screenWidth = MediaQuery.of(context).size.width;
            final dialogPadding = screenWidth < 360 ? 16.0 : 20.0; // 🔥 RESPONSIVE PADDING
            final starSize = screenWidth < 360 ? 38.0 : 44.0; // 🔥 RESPONSIVE STAR SIZE

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), // 🔥 ADDED INSET PADDING
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  maxHeight: MediaQuery.of(context).size.height * 0.85, // 🔥 MAX HEIGHT
                ),
                padding: EdgeInsets.all(dialogPadding), // 🔥 RESPONSIVE PADDING
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔥 ICON - REDUCED SIZE
                      Container(
                        padding: const EdgeInsets.all(18), // 🔥 REDUCED FROM 24
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [const Color(0xFFF59E0B).withOpacity(0.2), const Color(0xFFFBBF24).withOpacity(0.1)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 42), // 🔥 REDUCED FROM 52
                      ),
                      const SizedBox(height: 16), // 🔥 REDUCED FROM 24

                      // 🔥 TITLE - RESPONSIVE FONT SIZE
                      Text(
                        "Rate Your Experience",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth < 360 ? 20 : 22, // 🔥 RESPONSIVE
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8), // 🔥 REDUCED FROM 10

                      // 🔥 SERVICE NAME BADGE - FLEXIBLE
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // 🔥 REDUCED PADDING
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            bookingData['serviceName'] ?? 'Service',
                            style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700), // 🔥 REDUCED FROM 14
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // 🔥 REDUCED FROM 28

                      // 🔥 RATING SECTION - RESPONSIVE
                      Container(
                        padding: const EdgeInsets.all(16), // 🔥 REDUCED FROM 20
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16), // 🔥 REDUCED FROM 18
                          border: Border.all(color: Colors.grey[200]!, width: 1.5),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Tap to rate",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)), // 🔥 REDUCED FROM 14
                            ),
                            const SizedBox(height: 12), // 🔥 REDUCED FROM 16

                            // 🔥 STARS - RESPONSIVE WITH WRAP FOR SMALL SCREENS
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 4, // 🔥 REDUCED SPACING
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setDialogState(() {
                                      selectedRating = index + 1;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2), // 🔥 REDUCED FROM 6
                                    child: AnimatedScale(
                                      scale: index < selectedRating ? 1.1 : 1.0, // 🔥 REDUCED FROM 1.15
                                      duration: const Duration(milliseconds: 200),
                                      child: Icon(
                                        index < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                                        color: index < selectedRating ? const Color(0xFFF59E0B) : Colors.grey[400],
                                        size: starSize, // 🔥 RESPONSIVE SIZE
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            if (selectedRating > 0) ...[
                              const SizedBox(height: 8), // 🔥 REDUCED FROM 10
                              Text(
                                _getRatingText(selectedRating),
                                style: const TextStyle(fontSize: 14, color: Color(0xFFF59E0B), fontWeight: FontWeight.w700), // 🔥 REDUCED FROM 15
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 18), // 🔥 REDUCED FROM 24

                      // 🔥 FEEDBACK SECTION
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Share your feedback (optional)",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B)), // 🔥 REDUCED FROM 14
                          ),
                          const SizedBox(height: 10), // 🔥 REDUCED FROM 12
                          TextField(
                            controller: commentController,
                            maxLines: 3, // 🔥 REDUCED FROM 4
                            maxLength: 200,
                            decoration: InputDecoration(
                              hintText: "Tell us about your experience...",
                              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13), // 🔥 ADDED FONT SIZE
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12), // 🔥 REDUCED FROM 14
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              contentPadding: const EdgeInsets.all(12), // 🔥 REDUCED FROM 16
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20), // 🔥 REDUCED FROM 28

                      // 🔥 ACTION BUTTONS - RESPONSIVE
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14), // 🔥 REDUCED FROM 16
                                side: BorderSide(color: Colors.grey[300]!, width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // 🔥 REDUCED FROM 14
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: screenWidth < 360 ? 13 : 14, // 🔥 RESPONSIVE
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // 🔥 REDUCED FROM 14
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: selectedRating == 0
                                  ? null
                                  : () => _submitReview(context, bookingId, bookingData, selectedRating, commentController),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14), // 🔥 REDUCED FROM 16
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey[300],
                                elevation: 4,
                                shadowColor: const Color(0xFF3B82F6).withOpacity(0.4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // 🔥 REDUCED FROM 14
                              ),
                              child: Text(
                                "Submit Review",
                                style: TextStyle(
                                  fontSize: screenWidth < 360 ? 13 : 14, // 🔥 RESPONSIVE
                                  fontWeight: FontWeight.w700,
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
          },
        );
      },
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1: return "Poor";
      case 2: return "Fair";
      case 3: return "Good";
      case 4: return "Very Good";
      case 5: return "Excellent";
      default: return "";
    }
  }

  Future<void> _submitReview(
      BuildContext context,
      String bookingId,
      Map<String, dynamic> bookingData,
      int rating,
      TextEditingController commentController) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('reviews').doc(bookingId).set({
        'bookingId': bookingId,
        'uid': userId,
        'serviceName': bookingData['serviceName'],
        'rating': rating,
        'comment': commentController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text("Thank you for your review!"),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text("Error submitting review: $e")),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Widget _buildEmptyState(String? filter) {
    String title = filter == null ? "No bookings yet" : "No $filter bookings";
    String subtitle = filter == null
        ? "Book your first car wash service."
        : "All your $filter bookings will appear here.";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF3B82F6).withOpacity(0.15), const Color(0xFF60A5FA).withOpacity(0.05)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_busy_rounded, size: 64, color: Color(0xFF3B82F6)),
          ),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 24, color: Color(0xFF0F172A), fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 15))
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 28),
            SizedBox(width: 12),
            Text("Cancel Booking?", style: TextStyle(fontWeight: FontWeight.w800))
          ],
        ),
        content: const Text(
          "Are you sure you want to cancel this booking? This cannot be undone.",
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No, Keep it", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
                  'status': 'Cancelled',
                  'cancelledAt': FieldValue.serverTimestamp()
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Booking cancelled successfully"),
                    backgroundColor: Color(0xFFEF4444),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error cancelling booking: $e"),
                    backgroundColor: const Color(0xFFEF4444),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: const Color(0xFFEF4444).withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Yes, Cancel", style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.40,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Booking Details",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.5),
                ),
                const SizedBox(height: 24),
                _detailTile("Service Name", data['serviceName']),
                _detailTile("Date", data['date']),
                _detailTile("Time", data['time']),
                _detailTile("Price", "₹${data['price']}"),
                _detailTile("Discount", "${data['discount']}%"),
                _detailTile("Total Amount", "₹${data['totalAmount']}"),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.w600)),
          Text(
            value,
            style: const TextStyle(fontSize: 17, color: Color(0xFF0F172A), fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}