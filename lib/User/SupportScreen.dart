//   import 'package:flutter/material.dart';
//   import 'package:url_launcher/url_launcher.dart';
//
// import 'Support_ticket_screen.dart';
//
//   class SupportScreen extends StatelessWidget {
//     const SupportScreen({super.key});
//
//     // 🔹 Launch Phone
//     void _callSupport() {
//       launchUrl(Uri.parse("tel:+917869248648"));
//     }
//
//     // 🔹 Launch WhatsApp
//     void _whatsappSupport() {
//       launchUrl(Uri.parse("https://wa.me/7869248648"));
//     }
//
//     // 🔹 Launch Email
//     void _emailSupport() {
//       launchUrl(Uri.parse("mailto:23020201098@darshan.ac.in"));
//     }
//
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFF8FAFC),
//         body: SafeArea(
//           child: CustomScrollView(
//             slivers: [
//               // 🔵 Modern App Bar
//               SliverAppBar(
//                 expandedHeight: 240,
//                 floating: false,
//                 pinned: true,
//                 elevation: 0,
//                 backgroundColor: const Color(0xFF1E3A8A),
//                 leading: IconButton(
//                   icon: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.arrow_back, color: Colors.white),
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Color(0xFF1E3A8A),
//                           Color(0xFF3B82F6),
//                         ],
//                       ),
//                     ),
//                     child: Stack(
//                       children: [
//                         // Decorative circles
//                         Positioned(
//                           top: -50,
//                           right: -30,
//                           child: Container(
//                             width: 150,
//                             height: 150,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white.withOpacity(0.1),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: -30,
//                           left: -20,
//                           child: Container(
//                             width: 100,
//                             height: 100 ,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white.withOpacity(0.1),
//                             ),
//                           ),
//                         ),
//                         // Content
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: Colors.white.withOpacity(0.3),
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: const Icon(
//                                   Icons.support_agent_rounded,
//                                   color: Colors.white,
//                                   size: 32,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               const Text(
//                                 'Need Help?',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 32,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 "We're here 24/7 to assist you!",
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.white.withOpacity(0.9),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // 🔵 Content
//               SliverToBoxAdapter(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 24),
//
//                     // 🔹 Quick Contact Section
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 width: 4,
//                                 height: 24,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF3B82F6),
//                                   borderRadius: BorderRadius.circular(2),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               const Text(
//                                 "Quick Contact",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF1E293B),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Choose your preferred way to reach us",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // 🔵 Contact Cards
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: _modernContactCard(
//                               icon: Icons.call_rounded,
//                               label: "Call Us",
//                               subtitle: "Instant Support",
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
//                               ),
//                               onTap: _callSupport,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: _modernContactCard(
//                               icon: Icons.chat_bubble_rounded,
//                               label: "WhatsApp",
//                               subtitle: "Quick Chat",
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFF10B981), Color(0xFF059669)],
//                               ),
//                               onTap: _whatsappSupport,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: _modernContactCard(
//                         icon: Icons.email_rounded,
//                         label: "Email Support",
//                         subtitle: "support@carwashapp.com",
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
//                         ),
//                         onTap: _emailSupport,
//                         isFullWidth: true,
//                       ),
//                     ),
//
//                     const SizedBox(height: 32),
//
//                     // 🔹 FAQ Section
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 width: 4,
//                                 height: 24,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF3B82F6),
//                                   borderRadius: BorderRadius.circular(2),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               const Text(
//                                 "FAQs",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF1E293B),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Find quick answers to common questions",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     _modernFaqTile(
//                       icon: Icons.cancel_rounded,
//                       iconColor: const Color(0xFFEF4444),
//                       question: "How do I cancel my booking?",
//                       answer:
//                       "Go to My Bookings → Select your booking → Tap Cancel button. Your booking will be cancelled instantly and status will update automatically.",
//                     ),
//                     _modernFaqTile(
//                       icon: Icons.schedule_rounded,
//                       iconColor: const Color(0xFFF59E0B),
//                       question: "How do I change my time slot?",
//                       answer:
//                       "Cancel your current booking and create a new one with your preferred time slot. Make sure to do this at least 2 hours before the scheduled time.",
//                     ),
//                     _modernFaqTile(
//                       icon: Icons.location_on_rounded,
//                       iconColor: const Color(0xFF3B82F6),
//                       question: "Is doorstep service available?",
//                       answer:
//                       "Yes, doorstep service is available in most urban areas. Check service availability in your location while booking.",
//                     ),
//                     _modernFaqTile(
//                       icon: Icons.payment_rounded,
//                       iconColor: const Color(0xFF10B981),
//                       question: "What payment methods are accepted?",
//                       answer:
//                       "We accept UPI, Credit/Debit Cards, Net Banking, and Cash on Service. Digital payments offer instant confirmation.",
//                     ),
//                     _modernFaqTile(
//                       icon: Icons.access_time_rounded,
//                       iconColor: const Color(0xFF8B5CF6),
//                       question: "How long does a car wash take?",
//                       answer:
//                       "Basic wash takes 20-30 minutes, Premium wash takes 45-60 minutes. Time may vary based on vehicle size and selected service.",
//                     ),
//
//                     const SizedBox(height: 32),
//
//                     // 🔵 Support Ticket Card
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Container(
//                         padding: const EdgeInsets.all(24),
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               Color(0xFF1E3A8A),
//                               Color(0xFF3B82F6),
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFF3B82F6).withOpacity(0.3),
//                               blurRadius: 20,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.headset_mic_rounded,
//                                 color: Colors.white,
//                                 size: 40,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Still Need Help?',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Create a support ticket and our team will get back to you within 24 hours',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.white.withOpacity(0.9),
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton.icon(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => const SupportTicketScreen(),
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(Icons.add_rounded),
//                                 label: const Text(
//                                   'Create Support Ticket',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.white,
//                                   foregroundColor: const Color(0xFF3B82F6),
//                                   padding: const EdgeInsets.symmetric(vertical: 16),
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 32),
//
//                     // 🔹 Working Hours
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: const Color(0xFFE2E8F0),
//                             width: 1,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(12),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFF3B82F6).withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: const Icon(
//                                     Icons.schedule_rounded,
//                                     color: Color(0xFF3B82F6),
//                                     size: 24,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 const Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Working Hours',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: Color(0xFF1E293B),
//                                         ),
//                                       ),
//                                       SizedBox(height: 4),
//                                       Text(
//                                         'Monday - Sunday: 8:00 AM - 8:00 PM',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Color(0xFF64748B),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     // 🔹 Modern Contact Card Widget
//     Widget _modernContactCard({
//       required IconData icon,
//       required String label,
//       required String subtitle,
//       required Gradient gradient,
//       required VoidCallback onTap,
//       bool isFullWidth = false,
//     }) {
//       return GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.all(isFullWidth ? 20 : 16),
//           decoration: BoxDecoration(
//             gradient: gradient,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: isFullWidth
//               ? Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, size: 28, color: Colors.white),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       label,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.white.withOpacity(0.9),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_forward_rounded,
//                 color: Colors.white.withOpacity(0.8),
//                 size: 20,
//               ),
//             ],
//           )
//               : Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, size: 28, color: Colors.white),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 subtitle,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.white.withOpacity(0.9),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     // 🔹 Modern FAQ Tile
//     Widget _modernFaqTile({
//       required IconData icon,
//       required Color iconColor,
//       required String question,
//       required String answer,
//     }) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: const Color(0xFFE2E8F0),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Theme(
//             data: ThemeData(
//               dividerColor: Colors.transparent,
//               splashColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//             ),
//             child: ExpansionTile(
//               leading: Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: iconColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: iconColor,
//                   size: 20,
//                 ),
//               ),
//               title: Text(
//                 question,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//               tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//               childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF8FAFC),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     answer,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFF64748B),
//                       height: 1.5,
//
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Support_ticket_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  // 🔹 Launch Phone
  void _callSupport() {
    launchUrl(Uri.parse("tel:+917869248648"));
  }

  // 🔹 Launch WhatsApp
  void _whatsappSupport() {
    launchUrl(Uri.parse("https://wa.me/7869248648"));
  }

  // 🔹 Launch Email
  void _emailSupport() {
    launchUrl(Uri.parse("mailto:23020201098@darshan.ac.in"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 🔵 Modern App Bar
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              elevation: 0,
              backgroundColor: const Color(0xFF1E3A8A),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isCollapsed = constraints.maxHeight < 160;

                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1E3A8A),
                          Color(0xFF3B82F6),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [

                        // Decorative circles
                        Positioned(
                          top: -50,
                          right: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),


                        // Content
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            isCollapsed ? 60 : 80,
                            24,
                            20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min, // 🔥 IMPORTANT
                            children: [
                              if (!isCollapsed)
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.support_agent_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),

                              const SizedBox(height: 8),

                              const Text(
                                'Need Help?',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 28, // ⬅ slightly reduced
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              if (!isCollapsed)
                                Text(
                                  "We're here 24/7 to assist you!",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 🔵 Content - FIXED: Wrapped in SingleChildScrollView
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // 🔹 Quick Contact Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Quick Contact",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Choose your preferred way to reach us",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔵 Contact Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: _modernContactCard(
                              icon: Icons.call_rounded,
                              label: "Call Us",
                              subtitle: "Instant Support",
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                              ),
                              onTap: _callSupport,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _modernContactCard(
                              icon: Icons.chat_bubble_rounded,
                              label: "WhatsApp",
                              subtitle: "Quick Chat",
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                              ),
                              onTap: _whatsappSupport,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _modernContactCard(
                        icon: Icons.email_rounded,
                        label: "Email Support",
                        subtitle: "support@carwashapp.com",
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                        ),
                        onTap: _emailSupport,
                        isFullWidth: true,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 🔹 Brand Identifier Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B5CF6),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "About Our Service",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Our commitment to excellence",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Brand Card - FIXED: Added text constraints
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.local_car_wash_rounded,
                                color: Color(0xFF8B5CF6),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '2010MOVERLOVED BY JOKALS',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E3A8A),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Professional car care since 2010. Loved by customers for our meticulous attention to detail and premium service quality.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 🔹 FAQ Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "FAQs",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Find quick answers to common questions",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _modernFaqTile(
                      icon: Icons.cancel_rounded,
                      iconColor: const Color(0xFFEF4444),
                      question: "How do I cancel my booking?",
                      answer:
                      "Go to My Bookings → Select your booking → Tap Cancel button. Your booking will be cancelled instantly and status will update automatically.",
                    ),
                    _modernFaqTile(
                      icon: Icons.schedule_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      question: "How do I change my time slot?",
                      answer:
                      "Cancel your current booking and create a new one with your preferred time slot. Make sure to do this at least 2 hours before the scheduled time.",
                    ),
                    _modernFaqTile(
                      icon: Icons.location_on_rounded,
                      iconColor: const Color(0xFF3B82F6),
                      question: "Is doorstep service available?",
                      answer:
                      "Yes, doorstep service is available in most urban areas. Check service availability in your location while booking.",
                    ),
                    _modernFaqTile(
                      icon: Icons.payment_rounded,
                      iconColor: const Color(0xFF10B981),
                      question: "What payment methods are accepted?",
                      answer:
                      "We accept UPI, Credit/Debit Cards, Net Banking, and Cash on Service. Digital payments offer instant confirmation.",
                    ),
                    _modernFaqTile(
                      icon: Icons.access_time_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      question: "How long does a car wash take?",
                      answer:
                      "Basic wash takes 20-30 minutes, Premium wash takes 45-60 minutes. Time may vary based on vehicle size and selected service.",
                    ),

                    const SizedBox(height: 32),

                    // 🔵 Support Ticket Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1E3A8A),
                              Color(0xFF3B82F6),
                            ],
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
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.headset_mic_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Still Need Help?',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create a support ticket and our team will get back to you within 24 hours',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SupportTicketScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add_rounded),
                                label: const Text(
                                  'Create Support Ticket',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF3B82F6),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 🔹 Working Hours
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.schedule_rounded,
                                    color: Color(0xFF3B82F6),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Working Hours',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Monday - Sunday: 8:00 AM - 8:00 PM',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Modern Contact Card Widget
  Widget _modernContactCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isFullWidth ? 20 : 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isFullWidth
            ? Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ],
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Modern FAQ Tile
  Widget _modernFaqTile({
    required IconData icon,
    required Color iconColor,
    required String question,
    required String answer,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            title: Text(
              question,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF1E293B),
              ),
            ),
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  answer,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}