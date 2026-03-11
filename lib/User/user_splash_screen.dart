import 'package:car/User/userlogin.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    // Scale animation for logo with bounce effect
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );

    // Start animations with delays
    _fadeController.forward();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _scaleController.forward();
      }
    });

    // Navigate to Login Screen after 3.5 seconds
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF8FAFC),
              Color(0xFFEFF6FF),
              Color(0xFFDBEAFE),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Geometric pattern background
            Positioned.fill(
              child: CustomPaint(
                painter: GeometricPatternPainter(),
              ),
            ),

            // Floating bubbles
            ...List.generate(6, (index) => FloatingBubble(index: index)),

            // Falling droplets
            ...List.generate(4, (index) => FallingDroplet(index: index)),

            // Main content - Only Centered Logo
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      'asset/image/logo.png',
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback icon if image not found
                        return Container(
                          width: 300,
                          height: 300,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.water_drop_rounded,
                            size: 150,
                            color: Colors.white,
                          ),
                        );
                      },
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
}

// Enhanced Floating Bubble Widget
class FloatingBubble extends StatefulWidget {
  final int index;

  const FloatingBubble({Key? key, required this.index}) : super(key: key);

  @override
  State<FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<FloatingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isInitialized = false;

  final List<double> sizes = [70, 110, 55, 90, 65, 85];
  final List<Alignment> positions = [
    const Alignment(-0.85, -0.7),
    const Alignment(0.75, 0.15),
    const Alignment(0.35, -0.75),
    const Alignment(-0.65, 0.65),
    const Alignment(0.55, 0.45),
    const Alignment(-0.3, -0.3),
  ];
  final List<int> durations = [5500, 7500, 6500, 8500, 7000, 6000];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: durations[widget.index]),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 35).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
    _isInitialized = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const SizedBox.shrink();

    final screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: screenSize.width * ((positions[widget.index].x + 1) / 2) - (sizes[widget.index] / 2),
          top: screenSize.height * ((positions[widget.index].y + 1) / 2) - _animation.value - (sizes[widget.index] / 2),
          child: Opacity(
            opacity: 0.5,
            child: Container(
              width: sizes[widget.index],
              height: sizes[widget.index],
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF60A5FA).withOpacity(0.4),
                    const Color(0xFF3B82F6).withOpacity(0.15),
                    const Color(0xFF3B82F6).withOpacity(0.05),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Enhanced Falling Droplet Widget
class FallingDroplet extends StatefulWidget {
  final int index;

  const FallingDroplet({Key? key, required this.index}) : super(key: key);

  @override
  State<FallingDroplet> createState() => _FallingDropletState();
}

class _FallingDropletState extends State<FallingDroplet>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  bool _isInitialized = false;

  final List<double> positions = [0.12, 0.38, 0.68, 0.85];
  final List<int> delays = [0, 800, 1600, 2400];
  final List<int> durations = [3200, 3800, 3500, 4000];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: delays[widget.index]), () {
      if (mounted) {
        _controller = AnimationController(
          duration: Duration(milliseconds: durations[widget.index]),
          vsync: this,
        );

        _animation = CurvedAnimation(
          parent: _controller!,
          curve: Curves.easeIn,
        );

        _controller!.repeat();
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _animation == null) {
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animation!,
      builder: (context, child) {
        return Positioned(
          left: screenSize.width * positions[widget.index],
          top: screenSize.height * _animation!.value,
          child: Opacity(
            opacity: _animation!.value < 0.08 || _animation!.value > 0.92
                ? 0
                : 0.6,
            child: Transform.rotate(
              angle: -0.785398, // -45 degrees
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment(-0.3, -0.3),
                    colors: [
                      Color(0xFF60A5FA),
                      Color(0xFF3B82F6),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Enhanced Geometric Pattern Painter
class GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.025)
      ..style = PaintingStyle.fill;

    const patternSize = 90.0;
    final rows = (size.height / patternSize).ceil() + 1;
    final cols = (size.width / patternSize).ceil() + 1;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = col * patternSize;
        final y = row * patternSize;

        // Diamond pattern
        final path = Path()
          ..moveTo(x, y + patternSize * 0.5)
          ..lineTo(x + patternSize * 0.5, y)
          ..lineTo(x + patternSize, y + patternSize * 0.5)
          ..lineTo(x + patternSize * 0.5, y + patternSize)
          ..close();

        canvas.drawPath(path, paint);

        // Add subtle dots at intersections
        if (row % 2 == 0 && col % 2 == 0) {
          final dotPaint = Paint()
            ..color = const Color(0xFF3B82F6).withOpacity(0.05)
            ..style = PaintingStyle.fill;

          canvas.drawCircle(
            Offset(x + patternSize * 0.5, y + patternSize * 0.5),
            2,
            dotPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}