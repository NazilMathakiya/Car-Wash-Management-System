import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:car/AdminJ/managebooking.dart';
import 'package:car/AdminJ/manageservice.dart';
import 'package:car/AdminJ/manageuser.dart';
import 'package:car/AdminJ/profile.dart';
import 'package:car/AdminJ/admin_ratings.dart';
import 'package:car/AdminJ/dashboard_settings_screen.dart'; // 🔥 ADD THIS
import 'Notification Add Screen..dart';
import 'admin_support_tickets.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // 🔥 LIVE COUNTS
  int totalServices = 0;
  int totalBookings = 0;
  int totalUsers = 0;
  int totalRatings = 0;
  bool isLoading = true;

  // 🔥 CARD VISIBILITY SETTINGS
  bool showServiceCard = true;
  bool showBookingCard = true;
  bool showUserCard = true;
  bool showRatingCard = true;

  // Admin Info from Firebase
  String adminName = "Admin";
  String adminEmail = "";
  bool isLoadingAdmin = true;

  // 🔥 COLORS - Deep Blue Gradient
  static const deepBlue1 = Color(0xFF0D47A1);
  static const deepBlue2 = Color(0xFF1976D2);
  static const deepBlue3 = Color(0xFF2196F3);
  static const lightBlue = Color(0xFF42A5F5);
  static const bgLight = Color(0xFFF5F7FA);
  static const bgWhite = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF212121);
  static const textGray = Color(0xFF757575);
  static const lightGrayBg = Color(0xFFE3F2FD);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    fetchAdminInfo();
    fetchDashboardSettings(); // 🔥 NEW: Fetch settings
    fetchDashboardCounts();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 🔥 NEW: FETCH DASHBOARD CARD SETTINGS FROM FIREBASE
  Future<void> fetchDashboardSettings() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection("admin_settings")
          .doc("dashboard_cards")
          .get();

      if (doc.exists) {
        setState(() {
          showServiceCard = doc.data()?['showServiceCard'] ?? true;
          showBookingCard = doc.data()?['showBookingCard'] ?? true;
          showUserCard = doc.data()?['showUserCard'] ?? true;
          showRatingCard = doc.data()?['showRatingCard'] ?? true;
        });
      }
    } catch (e) {
      print("Error fetching dashboard settings: $e");
    }
  }

  /// 🔥 FETCH ADMIN INFO FROM FIREBASE AUTH
  Future<void> fetchAdminInfo() async {
    try {
      var user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var doc = await FirebaseFirestore.instance
            .collection("admins")
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            adminName = doc.data()?['name'] ?? user.displayName ?? "Admin";
            adminEmail = doc.data()?['email'] ?? user.email ?? "";
            isLoadingAdmin = false;
          });
        } else {
          setState(() {
            adminName = user.displayName ?? "Admin";
            adminEmail = user.email ?? "";
            isLoadingAdmin = false;
          });
        }
      } else {
        setState(() {
          adminName = "Admin";
          adminEmail = "";
          isLoadingAdmin = false;
        });
      }
    } catch (e) {
      print("Error fetching admin info: $e");
      setState(() {
        isLoadingAdmin = false;
      });
    }
  }

  /// 🔥 FETCH REAL-TIME COUNTS FROM FIRESTORE
  Future<void> fetchDashboardCounts() async {
    try {
      var serviceSnap = await FirebaseFirestore.instance.collection("services").get();
      var bookingSnap = await FirebaseFirestore.instance.collection("bookings").get();
      var userSnap = await FirebaseFirestore.instance.collection("users").get();
      var ratingSnap = await FirebaseFirestore.instance.collection("rating").get();

      setState(() {
        totalServices = serviceSnap.docs.length;
        totalBookings = bookingSnap.docs.length;
        totalUsers = userSnap.docs.length;
        totalRatings = ratingSnap.docs.length;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching counts: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgLight,
      body: RefreshIndicator(
        color: deepBlue2,
        backgroundColor: bgWhite,
        onRefresh: () async {
          await fetchAdminInfo();
          await fetchDashboardSettings();
          await fetchDashboardCounts();
        },
        child: CustomScrollView(
          slivers: [
            _buildStickyAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  _buildAdminInfoCard(screenWidth),
                  SizedBox(height: screenHeight * 0.025),
                  _buildStatisticsCards(screenWidth, screenHeight),
                  SizedBox(height: screenHeight * 0.025),
                  _buildManageServiceGrid(screenWidth, screenHeight),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 STICKY APP BAR - WITH SETTINGS BUTTON
  Widget _buildStickyAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      backgroundColor: deepBlue1,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [deepBlue1, deepBlue2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App Logo/Title
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Flexible(
                        child: Text(
                          "CLEAN GO",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // 🔥 SETTINGS AND PROFILE BUTTONS
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Settings Button
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DashboardSettingsScreen(),
                          ),
                        );
                        // Refresh dashboard after settings change
                        fetchDashboardSettings();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.settings_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Profile Avatar
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: lightBlue.withOpacity(0.2),
                          child: const Icon(
                            Icons.person_rounded,
                            color: deepBlue1,
                            size: 22,
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
      ),
    );
  }

  /// 🔥 ADMIN INFO CARD - RESPONSIVE
  Widget _buildAdminInfoCard(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.045),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [deepBlue2, deepBlue3],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: deepBlue2.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: isLoadingAdmin
            ? const SizedBox(
          height: 80,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    "Admin Dashboard",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  color: Colors.white70,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    adminName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: Colors.white70,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    adminEmail.isNotEmpty ? adminEmail : "admin@cleango.com",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 STATISTICS CARDS - FULLY RESPONSIVE (WITH VISIBILITY CONTROL)
  Widget _buildStatisticsCards(double screenWidth, double screenHeight) {
    if (isLoading) {
      return SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: deepBlue2),
        ),
      );
    }

    // 🔥 Build list of visible cards only
    List<Widget> visibleCards = [];

    if (showServiceCard) {
      visibleCards.add(
        _buildModernStatsCard(
          count: totalServices,
          title: "Total Service",
          percentage: "+12%",
          icon: Icons.directions_car_rounded,
          iconColor: lightBlue,
          screenWidth: screenWidth,
        ),
      );
    }

    if (showBookingCard) {
      visibleCards.add(
        _buildModernStatsCard(
          count: totalBookings,
          title: "Total Booking",
          percentage: "+8%",
          icon: Icons.check_box_rounded,
          iconColor: lightBlue,
          screenWidth: screenWidth,
        ),
      );
    }

    if (showUserCard) {
      visibleCards.add(
        _buildModernStatsCard(
          count: totalUsers,
          title: "Total User",
          percentage: "+23%",
          icon: Icons.people_rounded,
          iconColor: lightBlue,
          screenWidth: screenWidth,
        ),
      );
    }

    if (showRatingCard) {
      visibleCards.add(
        _buildModernStatsCard(
          count: totalRatings,
          title: "Rating",
          percentage: "+5%",
          icon: Icons.star_rounded,
          iconColor: deepBlue2,
          screenWidth: screenWidth,
        ),
      );
    }

    // 🔥 If no cards are visible, show a message
    if (visibleCards.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 20),
        child: const Center(
          child: Text(
            "No statistics cards enabled",
            style: TextStyle(
              fontSize: 14,
              color: textGray,
            ),
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 12) / 2;
            final cardHeight = cardWidth * 1.1;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: visibleCards.map((card) {
                return SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: card,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  /// 🔥 MODERN STATS CARD - FULLY RESPONSIVE
  Widget _buildModernStatsCard({
    required int count,
    required String title,
    required String percentage,
    required IconData icon,
    required Color iconColor,
    required double screenWidth,
  }) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.035),
      decoration: BoxDecoration(
        color: bgWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -15,
            right: -15,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: lightGrayBg,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.025),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: screenWidth * 0.055,
                ),
              ),
              const Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "$count",
                  style: TextStyle(
                    fontSize: screenWidth * 0.085,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.005),
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.032,
                  fontWeight: FontWeight.w500,
                  color: textGray,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: screenWidth * 0.015),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.018,
                  vertical: screenWidth * 0.01,
                ),
                decoration: BoxDecoration(
                  color: lightGrayBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: lightBlue,
                      size: screenWidth * 0.03,
                    ),
                    SizedBox(width: screenWidth * 0.008),
                    Text(
                      percentage,
                      style: TextStyle(
                        fontSize: screenWidth * 0.028,
                        fontWeight: FontWeight.w600,
                        color: lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 MANAGE SERVICE GRID - FULLY RESPONSIVE
  Widget _buildManageServiceGrid(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Manage Services",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: textDark,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: screenHeight * 0.018),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 28) / 3;
              final cardHeight = cardWidth * 1.15;

              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildManageCard(
                      title: "Manage\nService",
                      icon: Icons.build_rounded,
                      color: deepBlue2,
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ManageServicesPage()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildManageCard(
                      title: "Manage\nBooking",
                      icon: Icons.calendar_today_rounded,
                      color: const Color(0xFF9C27B0),
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ManageBookingScreen()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildManageCard(
                      title: "Manage\nUsers",
                      icon: Icons.people_alt_rounded,
                      color: const Color(0xFF00BCD4),
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ManageUserPage()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildManageCard(
                      title: "View\nRatings",
                      icon: Icons.star_rate_rounded,
                      color: const Color(0xFFFF9800),
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminRatingsPage()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildManageCard(
                      title: "Support\nTickets",
                      icon: Icons.support_agent_rounded,
                      color: const Color(0xFF4CAF50),
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ManageTicketsScreen()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildManageCard(
                      title: "Send\nNotification",
                      icon: Icons.notifications_active_rounded,
                      color: const Color(0xFFE91E63),
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminNotificationList()),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildManageCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: screenWidth * 0.09,
            ),
            SizedBox(height: screenWidth * 0.025),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w600,
                  color: color,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}