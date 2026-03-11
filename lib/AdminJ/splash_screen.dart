import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart'; // <-- Your Admin Login Screen File

class AdminSplashScreen extends StatefulWidget {
  const AdminSplashScreen({super.key});

  @override
  State<AdminSplashScreen> createState() => _AdminSplashScreenState();
}

class _AdminSplashScreenState extends State<AdminSplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _logoSlideController;
  late AnimationController _logoScaleController;
  late AnimationController _fadeController;
  late AnimationController _textSlideController;
  late AnimationController _zoomController;

  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();

    // Logo Slide Animation (Top to Center)
    _logoSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoSlideController,
      curve: Curves.easeOutBack,
    ));

    // Logo Scale Animation (After reaching center)
    _logoScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _logoScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoScaleController,
      curve: Curves.easeInOut,
    ));

    // Fade Animation for Text
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Text Slide Animation
    _textSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textSlideController,
      curve: Curves.easeOut,
    ));

    // Zoom Animation (Final zoom before navigation)
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _zoomAnimation = Tween<double>(
      begin: 1.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _zoomController,
      curve: Curves.easeInCubic,
    ));

    // Start animations sequence
    _logoSlideController.forward();

    Future.delayed(const Duration(milliseconds: 1200), () {
      _fadeController.forward();
      _textSlideController.forward();
    });

    // Start zoom animation before navigation
    Future.delayed(const Duration(milliseconds: 3200), () {
      _zoomController.forward();
    });

    // Navigate to login after zoom completes
    Timer(const Duration(milliseconds: 3800), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _logoSlideController.dispose();
    _logoScaleController.dispose();
    _fadeController.dispose();
    _textSlideController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade500,
              Colors.purple.shade500,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),

            // Main Content
            Center(
              child: ScaleTransition(
                scale: _zoomAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo Container (Top to Center)
                    SlideTransition(
                      position: _logoSlideAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.water_drop_rounded,
                              size: 80,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // App Title with Fade Animation
                    SlideTransition(
                      position: _textSlideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          "Car Wash",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SlideTransition(
                      position: _textSlideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          "Management",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Tagline with Slide Animation
                    SlideTransition(
                      position: _textSlideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "✨ Shine Like New ✨",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading Indicator at Bottom
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.5,
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