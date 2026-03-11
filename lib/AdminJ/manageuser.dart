import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'UserDeatil.dart';

class ManageUserPage extends StatefulWidget {
  const ManageUserPage({super.key});

  @override
  State<ManageUserPage> createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  // Deep Blue Theme Colors
  static const deepBlue1 = Color(0xFF0D47A1);
  static const deepBlue2 = Color(0xFF1976D2);
  static const lightBlue = Color(0xFF42A5F5);
  static const bgLight = Color(0xFFF5F7FA);
  static const bgWhite = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF212121);
  static const textGray = Color(0xFF757575);
  static const lightGrayBg = Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: _buildModernAppBar(context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: deepBlue2),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index].data() as Map<String, dynamic>;
              String name = userData["name"] ?? "User";
              String email = userData["email"] ?? "No Email";
              String userId = users[index].id;

              return _buildModernUserCard(context, name, email, userId, index);
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: deepBlue2,
      elevation: 0,
      toolbarHeight: 70,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Row(
        children: [
          Icon(Icons.people_rounded, color: Colors.white, size: 28),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Manage Users",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "All registered users",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernUserCard(BuildContext context, String name, String email, String userId, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailPage(
              userId: userId,
              userName: name,
              userEmail: email,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: bgWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Modern Avatar
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightBlue, deepBlue2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: lightBlue.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : "?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 14,
                          color: lightBlue,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            email,
                            style: const TextStyle(
                              fontSize: 13,
                              color: textGray,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: lightGrayBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_user_rounded,
                            size: 14,
                            color: lightBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Active User",
                            style: TextStyle(
                              fontSize: 11,
                              color: lightBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Delete Button
              GestureDetector(
                onTap: () {
                  _confirmDelete(context, userId, name);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.shade200, width: 1),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red.shade600,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: lightGrayBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline_rounded,
              size: 80,
              color: lightBlue,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Users Found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Users will appear here once registered",
            style: TextStyle(
              fontSize: 15,
              color: textGray,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String userId, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.warning_rounded, color: Colors.red.shade600, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Delete User?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to delete '$userName'? This action cannot be undone and will remove all user data.",
          style: const TextStyle(color: textGray, fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: textGray, fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              await FirebaseFirestore.instance.collection("users").doc(userId).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("User '$userName' deleted successfully"),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// ENHANCED USER DETAIL PAGE
// ============================================
//
// class UserDetailPage extends StatelessWidget {
//   final String userId;
//   final String userName;
//   final String userEmail;
//
//   const UserDetailPage({
//     super.key,
//     required this.userId,
//     required this.userName,
//     required this.userEmail,
//   });
//
//   // Deep Blue Theme Colors
//   static const deepBlue1 = Color(0xFF0D47A1);
//   static const deepBlue2 = Color(0xFF1976D2);
//   static const lightBlue = Color(0xFF42A5F5);
//   static const bgLight = Color(0xFFF5F7FA);
//   static const bgWhite = Color(0xFFFFFFFF);
//   static const textDark = Color(0xFF212121);
//   static const textGray = Color(0xFF757575);
//   static const lightGrayBg = Color(0xFFE3F2FD);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgLight,
//       body: CustomScrollView(
//         slivers: [
//           _buildStickyAppBar(context),
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 _buildUserInfoCard(),
//                 const SizedBox(height: 20),
//                 _buildStatsSection(),
//                 const SizedBox(height: 20),
//                 _buildBookingsSection(),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStickyAppBar(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: 80,
//       pinned: true,
//       backgroundColor: deepBlue2,
//       elevation: 0,
//       leading: IconButton(
//         icon: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
//         ),
//         onPressed: () => Navigator.pop(context),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [deepBlue1, deepBlue2],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(70, 20, 20, 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   const Text(
//                     "User Details",
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     userName,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserInfoCard() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: bgWhite,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Large Avatar
//           Container(
//             width: 110,
//             height: 110,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [lightBlue, deepBlue2],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                   color: lightBlue.withOpacity(0.5),
//                   blurRadius: 25,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Text(
//                 userName.isNotEmpty ? userName[0].toUpperCase() : "?",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 52,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           // User Name
//           Text(
//             userName,
//             style: const TextStyle(
//               fontSize: 26,
//               fontWeight: FontWeight.bold,
//               color: textDark,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 12),
//
//           // Email Badge
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: lightGrayBg,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.email_outlined, size: 18, color: lightBlue),
//                 const SizedBox(width: 8),
//                 Flexible(
//                   child: Text(
//                     userEmail,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: lightBlue,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // User ID
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: bgLight,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: Colors.grey.shade200, width: 1),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.fingerprint_rounded, size: 18, color: textGray),
//                 const SizedBox(width: 10),
//                 const Text(
//                   "User ID: ",
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: textGray,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     userId,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: textGray,
//                       fontFamily: 'monospace',
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatsSection() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("bookings")
//           .where("uid", isEqualTo: userId)
//           .snapshots(),
//       builder: (context, bookingSnapshot) {
//         int totalBookings = 0;
//         int pendingBookings = 0;
//         int completedBookings = 0;
//         int cancelledBookings = 0;
//         double totalSpent = 0;
//
//         if (bookingSnapshot.hasData) {
//           totalBookings = bookingSnapshot.data!.docs.length;
//
//           for (var doc in bookingSnapshot.data!.docs) {
//             var data = doc.data() as Map<String, dynamic>;
//             String status = (data['status'] ?? 'Pending').toLowerCase();
//
//             if (status == 'pending') pendingBookings++;
//             if (status == 'completed') completedBookings++;
//             if (status == 'cancelled') cancelledBookings++;
//
//             if (status != 'cancelled') {
//               totalSpent += double.tryParse(data['totalAmount']?.toString() ?? '0') ?? 0;
//             }
//           }
//         }
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Statistics Overview",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: textDark,
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Stats Grid
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 14,
//                 crossAxisSpacing: 14,
//                 childAspectRatio: 1.1,
//                 children: [
//                   _buildStatCard(
//                     icon: Icons.receipt_long_rounded,
//                     label: "Total Bookings",
//                     value: totalBookings.toString(),
//                     color: lightBlue,
//                   ),
//                   _buildStatCard(
//                     icon: Icons.schedule_rounded,
//                     label: "Pending",
//                     value: pendingBookings.toString(),
//                     color: Colors.orange,
//                   ),
//                   _buildStatCard(
//                     icon: Icons.check_circle_rounded,
//                     label: "Completed",
//                     value: completedBookings.toString(),
//                     color: Colors.green,
//                   ),
//                   _buildStatCard(
//                     icon: Icons.cancel_rounded,
//                     label: "Cancelled",
//                     value: cancelledBookings.toString(),
//                     color: Colors.red,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 14),
//
//               // Total Spent Card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [deepBlue2, deepBlue1],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: deepBlue2.withOpacity(0.4),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 32),
//                         SizedBox(width: 14),
//                         Text(
//                           "Total Spent",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       "₹${totalSpent.toStringAsFixed(0)}",
//                       style: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildStatCard({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: bgWhite,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Icon(icon, color: color, size: 28),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 12,
//               color: textGray,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBookingsSection() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("bookings")
//           .where("uid", isEqualTo: userId)
//           .orderBy("timestamp", descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: Padding(
//               padding: EdgeInsets.all(40),
//               child: CircularProgressIndicator(color: deepBlue2),
//             ),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Padding(
//             padding: const EdgeInsets.all(40),
//             child: Center(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(30),
//                     decoration: BoxDecoration(
//                       color: lightGrayBg,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.event_busy_rounded,
//                       size: 60,
//                       color: lightBlue,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "No Bookings Yet",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: textDark,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     "User hasn't made any bookings",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: textGray,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Booking History",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: textDark,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
//                     decoration: BoxDecoration(
//                       color: lightGrayBg,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       "${snapshot.data!.docs.length} bookings",
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                         color: lightBlue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
//                   return _buildBookingCard(data);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildBookingCard(Map<String, dynamic> data) {
//     String status = data['status'] ?? 'Pending';
//     Color statusColor;
//     IconData statusIcon;
//
//     switch (status.toLowerCase()) {
//       case 'completed':
//         statusColor = Colors.green;
//         statusIcon = Icons.check_circle_rounded;
//         break;
//       case 'cancelled':
//         statusColor = Colors.red;
//         statusIcon = Icons.cancel_rounded;
//         break;
//       default:
//         statusColor = Colors.orange;
//         statusIcon = Icons.schedule_rounded;
//     }
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: bgWhite,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Header with Status
//           Container(
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.1),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Icon(Icons.local_car_wash_rounded, color: statusColor, size: 22),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         data['serviceName'] ?? 'Service',
//                         style: const TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: textDark,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "${data['date']} • ${data['time']}",
//                         style: const TextStyle(
//                           fontSize: 13,
//                           color: textGray,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(statusIcon, size: 16, color: statusColor),
//                       const SizedBox(width: 6),
//                       Text(
//                         status,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: statusColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Booking Details
//           Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               children: [
//                 _buildDetailRow("Price", "₹${data['price']}", Icons.currency_rupee_rounded),
//                 const SizedBox(height: 10),
//                 _buildDetailRow("Discount", "${data['discount']}%", Icons.discount_rounded),
//                 const SizedBox(height: 14),
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [lightBlue, deepBlue2],
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Total Amount",
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         "₹${data['totalAmount']}",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: lightBlue),
//         const SizedBox(width: 10),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: textGray,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const Spacer(),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: textDark,
//           ),
//         ),
//       ],
//     );
//   }
// }