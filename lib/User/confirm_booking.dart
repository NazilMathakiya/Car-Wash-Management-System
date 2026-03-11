import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'booking.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final String serviceName;
  final String selectedDate;
  final String selectedTime;
  final int price;

  const ConfirmBookingScreen({
    super.key,
    required this.serviceName,
    required this.selectedDate,
    required this.selectedTime,
    required this.price,
  });

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    int discount = (widget.price * 0.10).toInt();
    int totalAmount = widget.price - discount;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Confirm Booking', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Review your booking details', style: TextStyle(fontSize: 14, color: Colors.white70)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                    child: const Icon(Icons.event_available_rounded, color: Colors.white, size: 26),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.description_outlined, color: Color(0xFF3B82F6), size: 24),
                              ),
                              const SizedBox(width: 12),
                              const Text('Service Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildDetailRow(icon: Icons.car_crash_rounded, label: 'Service', value: widget.serviceName, color: const Color(0xFF3B82F6)),
                          const SizedBox(height: 16),
                          _buildDetailRow(icon: Icons.calendar_today_rounded, label: 'Date', value: widget.selectedDate, color: const Color(0xFF10B981)),
                          const SizedBox(height: 16),
                          _buildDetailRow(icon: Icons.access_time_rounded, label: 'Time', value: widget.selectedTime, color: const Color(0xFF8B5CF6)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF10B981), size: 24),
                              ),
                              const SizedBox(width: 12),
                              const Text('Price Breakdown', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildPriceRow(label: 'Service Cost', value: '₹${widget.price}', isSubtotal: true),
                          const SizedBox(height: 12),
                          _buildPriceRow(label: 'Discount (10%)', value: '-₹${(widget.price * 0.10).toInt()}', isDiscount: true),
                          const SizedBox(height: 16),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Colors.grey.withOpacity(0.1), Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.1)]),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.payments_rounded, color: Colors.white, size: 24),
                                    SizedBox(width: 10),
                                    Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                  ],
                                ),
                                Text('₹$totalAmount', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFCD34D), width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFFD97706), size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text('Please arrive 5 minutes before your scheduled time', style: TextStyle(fontSize: 13, color: Colors.grey[800])),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _confirmBooking(context, totalAmount, (widget.price * 0.10).toInt()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      disabledBackgroundColor: const Color(0xFF94A3B8),
                    ),
                    child: isLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 24),
                        SizedBox(width: 12),
                        Text('Confirm Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value, required Color color}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow({required String label, required String value, bool isSubtotal = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15, color: isDiscount ? const Color(0xFF10B981) : Colors.grey[700], fontWeight: isSubtotal ? FontWeight.w500 : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDiscount ? const Color(0xFF10B981) : const Color(0xFF1E293B))),
      ],
    );
  }

  Future<void> _confirmBooking(BuildContext context, int totalAmount, int discount) async {
    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance.collection("bookings").add({
        "uid": user.uid,
        "serviceName": widget.serviceName,
        "date": widget.selectedDate,
        "time": widget.selectedTime,
        "price": widget.price,
        "discount": discount,
        "totalAmount": totalAmount,
        "status": "Pending",
        "timestamp": Timestamp.now(),
      });

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.7),
        builder: (context) => const UltimateCelebrationOverlay(),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => UltimateCelebrationDialog(
          onViewBookings: () {
            // Close the dialog first
            Navigator.pop(context);
            // Pop back to home screen
            Navigator.of(context).popUntil((route) => route.isFirst);
            // Navigate to booking screen with navigation enabled
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [const Icon(Icons.error_outline, color: Colors.white), const SizedBox(width: 12), Expanded(child: Text("Booking failed: ${e.toString()}"))]),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
    setState(() => isLoading = false);
  }
}

// Ultimate Celebration Overlay
class UltimateCelebrationOverlay extends StatefulWidget {
  const UltimateCelebrationOverlay({super.key});

  @override
  State<UltimateCelebrationOverlay> createState() => _UltimateCelebrationOverlayState();
}

class _UltimateCelebrationOverlayState extends State<UltimateCelebrationOverlay> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(duration: const Duration(milliseconds: 1400), vsync: this);
    _pulseController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.3).chain(CurveTween(curve: Curves.easeOutBack)), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)), weight: 40),
    ]).animate(_mainController);

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _mainController, curve: const Interval(0.3, 0.8, curve: Curves.easeInOut)));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _mainController.forward();
    _pulseController.repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _pulseController]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 200 * _pulseAnimation.value,
                height: 200 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF10B981).withOpacity(0.0),
                      const Color(0xFF10B981).withOpacity(0.3 * _scaleAnimation.value),
                    ],
                  ),
                ),
              ),
              // Main circle
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF10B981).withOpacity(0.6), blurRadius: 40, spreadRadius: 10),
                    ],
                  ),
                  child: CustomPaint(
                    size: const Size(90, 90),
                    painter: CheckMarkPainter(progress: _checkAnimation.value, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Check Mark Painter
class CheckMarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  CheckMarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 8..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final path = Path();
    final p1 = Offset(size.width * 0.2, size.height * 0.5);
    final p2 = Offset(size.width * 0.4, size.height * 0.7);
    final p3 = Offset(size.width * 0.8, size.height * 0.3);

    if (progress < 0.5) {
      final currentProgress = progress * 2;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p1.dx + (p2.dx - p1.dx) * currentProgress, p1.dy + (p2.dy - p1.dy) * currentProgress);
    } else {
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      final secondProgress = (progress - 0.5) * 2;
      path.lineTo(p2.dx + (p3.dx - p2.dx) * secondProgress, p2.dy + (p3.dy - p2.dy) * secondProgress);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CheckMarkPainter oldDelegate) => oldDelegate.progress != progress;
}

// Ultimate Celebration Dialog
class UltimateCelebrationDialog extends StatefulWidget {
  final VoidCallback onViewBookings;

  const UltimateCelebrationDialog({
    super.key,
    required this.onViewBookings,
  });

  @override
  State<UltimateCelebrationDialog> createState() => _UltimateCelebrationDialogState();
}

class _UltimateCelebrationDialogState extends State<UltimateCelebrationDialog> with TickerProviderStateMixin {
  late AnimationController _dialogController;
  late AnimationController _effectsController;
  late Animation<double> _dialogAnimation;
  final List<CelebrationParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _dialogController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _effectsController = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);
    _dialogAnimation = CurvedAnimation(parent: _dialogController, curve: Curves.easeOutBack);

    _generateParticles();
    _dialogController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _effectsController.forward();
    });
  }

  void _generateParticles() {
    final random = Random();

    // Confetti burst (center)
    for (int i = 0; i < 50; i++) {
      final angle = (i / 50) * 2 * pi;
      _particles.add(CelebrationParticle(
        type: ParticleType.confetti,
        startX: 0.5,
        startY: 0.5,
        angle: angle,
        speed: 0.7 + random.nextDouble() * 0.5,
        color: _getRandomColor(random),
        size: random.nextDouble() * 6 + 4,
        shape: random.nextInt(3),
        rotation: random.nextDouble() * 2 * pi,
      ));
    }

    // Stars from top
    for (int i = 0; i < 30; i++) {
      _particles.add(CelebrationParticle(
        type: ParticleType.star,
        startX: random.nextDouble(),
        startY: -0.1,
        angle: pi / 2 + (random.nextDouble() - 0.5) * 0.5,
        speed: 0.3 + random.nextDouble() * 0.4,
        color: _getRandomColor(random),
        size: random.nextDouble() * 8 + 6,
        shape: 0,
        rotation: random.nextDouble() * 2 * pi,
      ));
    }

    // Sparkles
    for (int i = 0; i < 40; i++) {
      _particles.add(CelebrationParticle(
        type: ParticleType.sparkle,
        startX: random.nextDouble(),
        startY: random.nextDouble(),
        angle: random.nextDouble() * 2 * pi,
        speed: 0.2 + random.nextDouble() * 0.3,
        color: Colors.white,
        size: random.nextDouble() * 4 + 2,
        shape: 0,
        rotation: 0,
      ));
    }
  }

  Color _getRandomColor(Random random) {
    final colors = [
      const Color(0xFF10B981), const Color(0xFF3B82F6), const Color(0xFFF59E0B),
      const Color(0xFFEF4444), const Color(0xFF8B5CF6), const Color(0xFFEC4899),
      const Color(0xFFFFD700), const Color(0xFF4ECDC4), const Color(0xFFFF6B6B),
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _dialogController.dispose();
    _effectsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...List.generate(_particles.length, (index) {
          return AnimatedParticle(particle: _particles[index], animation: _effectsController);
        }),
        Center(
          child: ScaleTransition(
            scale: _dialogAnimation,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 20, spreadRadius: 5)],
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 64),
                  ),
                  const SizedBox(height: 24),
                  const Text('Booking Confirmed!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 12),
                  Text('Your booking has been successfully confirmed', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onViewBookings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('View Bookings', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum ParticleType { confetti, star, sparkle }

class CelebrationParticle {
  final ParticleType type;
  final double startX, startY, angle, speed, size, rotation;
  final Color color;
  final int shape;

  CelebrationParticle({
    required this.type,
    required this.startX,
    required this.startY,
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
    required this.shape,
    required this.rotation,
  });
}

class AnimatedParticle extends StatelessWidget {
  final CelebrationParticle particle;
  final Animation<double> animation;

  const AnimatedParticle({super.key, required this.particle, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final screenSize = MediaQuery.of(context).size;
        double progress = animation.value;
        double x = particle.startX, y = particle.startY, opacity = 1.0, scale = 1.0, currentRotation = particle.rotation;

        switch (particle.type) {
          case ParticleType.confetti:
            progress = Curves.easeOut.transform(progress);
            final distance = progress * particle.speed * 300;
            x = particle.startX + cos(particle.angle) * distance / screenSize.width;
            y = particle.startY + sin(particle.angle) * distance / screenSize.height + (progress * progress * 0.3);
            currentRotation = particle.rotation + progress * 4 * pi;
            opacity = progress < 0.7 ? 1.0 : (1.0 - (progress - 0.7) / 0.3);
            scale = 1.0 - (progress * 0.3);
            break;

          case ParticleType.star:
            progress = Curves.easeInOut.transform(progress);
            final distance = progress * particle.speed * 400;
            x = particle.startX + cos(particle.angle) * (progress * 0.1);
            y = particle.startY + sin(particle.angle) * distance / screenSize.height;
            currentRotation = progress * 2 * pi;
            opacity = progress < 0.5 ? progress * 2 : 2 * (1 - progress);
            scale = progress < 0.5 ? 1.0 + progress : 1.5 - progress;
            break;

          case ParticleType.sparkle:
            progress = Curves.easeInOut.transform(progress);
            opacity = sin(progress * pi);
            scale = 1.0 + sin(progress * pi) * 0.5;
            break;
        }

        return Positioned(
          left: x * screenSize.width - particle.size / 2,
          top: y * screenSize.height - particle.size / 2,
          child: Transform.rotate(
            angle: currentRotation,
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: _buildParticle(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticle() {
    if (particle.type == ParticleType.star) {
      return CustomPaint(size: Size(particle.size, particle.size), painter: StarPainter(color: particle.color));
    } else if (particle.type == ParticleType.sparkle) {
      return CustomPaint(size: Size(particle.size, particle.size), painter: SparklePainter(color: particle.color));
    } else {
      switch (particle.shape) {
        case 0:
          return Container(
            width: particle.size,
            height: particle.size,
            decoration: BoxDecoration(color: particle.color, borderRadius: BorderRadius.circular(2)),
          );
        case 1:
          return Container(
            width: particle.size,
            height: particle.size,
            decoration: BoxDecoration(color: particle.color, shape: BoxShape.circle),
          );
        case 2:
          return Container(
            width: particle.size * 1.5,
            height: particle.size * 0.7,
            decoration: BoxDecoration(color: particle.color, borderRadius: BorderRadius.circular(2)),
          );
        default:
          return Container(width: particle.size, height: particle.size, decoration: BoxDecoration(color: particle.color, shape: BoxShape.circle));
      }
    }
  }
}

class StarPainter extends CustomPainter {
  final Color color;
  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = size.width / 4;

    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 2 * pi / 5) - pi / 2;
      final innerAngle = outerAngle + pi / 5;

      if (i == 0) {
        path.moveTo(center.dx + outerRadius * cos(outerAngle), center.dy + outerRadius * sin(outerAngle));
      } else {
        path.lineTo(center.dx + outerRadius * cos(outerAngle), center.dy + outerRadius * sin(outerAngle));
      }
      path.lineTo(center.dx + innerRadius * cos(innerAngle), center.dy + innerRadius * sin(innerAngle));
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SparklePainter extends CustomPainter {
  final Color color;

  SparklePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);

    // Draw 4 pointed sparkle
    final path = Path();
    path.moveTo(center.dx, 0);
    path.lineTo(center.dx + size.width * 0.1, center.dy - size.height * 0.1);
    path.lineTo(size.width, center.dy);
    path.lineTo(center.dx + size.width * 0.1, center.dy + size.height * 0.1);
    path.lineTo(center.dx, size.height);
    path.lineTo(center.dx - size.width * 0.1, center.dy + size.height * 0.1);
    path.lineTo(0, center.dy);
    path.lineTo(center.dx - size.width * 0.1, center.dy - size.height * 0.1);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}