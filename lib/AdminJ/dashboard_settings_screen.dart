import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardSettingsScreen extends StatefulWidget {
  const DashboardSettingsScreen({super.key});

  @override
  State<DashboardSettingsScreen> createState() => _DashboardSettingsScreenState();
}

class _DashboardSettingsScreenState extends State<DashboardSettingsScreen> {
  // Card visibility settings
  bool showServiceCard = true;
  bool showBookingCard = true;
  bool showUserCard = true;
  bool showRatingCard = true;
  bool isLoading = true;
  bool isSaving = false;

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
    fetchSettings();
  }

  /// Fetch current settings from Firebase
  Future<void> fetchSettings() async {
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
          isLoading = false;
        });
      } else {
        // Create default settings if document doesn't exist
        await saveSettings();
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching settings: $e");
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error loading settings: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Save settings to Firebase
  Future<void> saveSettings() async {
    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection("admin_settings")
          .doc("dashboard_cards")
          .set({
        'showServiceCard': showServiceCard,
        'showBookingCard': showBookingCard,
        'showUserCard': showUserCard,
        'showRatingCard': showRatingCard,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Settings saved successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("Error saving settings: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving settings: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: const Text(
          "Dashboard Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [deepBlue1, deepBlue2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: deepBlue2),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [deepBlue2, lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: deepBlue2.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.dashboard_customize_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Card Visibility",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Toggle cards on/off",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings Cards
            _buildSettingCard(
              title: "Total Service Card",
              subtitle: "Show service statistics on dashboard",
              icon: Icons.directions_car_rounded,
              iconColor: lightBlue,
              value: showServiceCard,
              onChanged: (val) {
                setState(() => showServiceCard = val);
              },
            ),
            const SizedBox(height: 12),

            _buildSettingCard(
              title: "Total Booking Card",
              subtitle: "Show booking statistics on dashboard",
              icon: Icons.check_box_rounded,
              iconColor: lightBlue,
              value: showBookingCard,
              onChanged: (val) {
                setState(() => showBookingCard = val);
              },
            ),
            const SizedBox(height: 12),

            _buildSettingCard(
              title: "Total User Card",
              subtitle: "Show user statistics on dashboard",
              icon: Icons.people_rounded,
              iconColor: lightBlue,
              value: showUserCard,
              onChanged: (val) {
                setState(() => showUserCard = val);
              },
            ),
            const SizedBox(height: 12),

            _buildSettingCard(
              title: "Rating Card",
              subtitle: "Show rating statistics on dashboard",
              icon: Icons.star_rounded,
              iconColor: const Color(0xFFFF9800),
              value: showRatingCard,
              onChanged: (val) {
                setState(() => showRatingCard = val);
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: deepBlue2,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: deepBlue2.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_rounded, size: 22),
                    SizedBox(width: 10),
                    Text(
                      "Save Settings",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: textGray,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: deepBlue2,
                  activeTrackColor: lightBlue.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}