import 'package:flutter/material.dart';
import 'dart:async';
import 'package:frontend_canteen/screens/loginselection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SDCanteen',
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 🎬 Animation controller for total duration
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // 🎞️ Fade in quickly, fade out slowly and smoothly
    _animation = TweenSequence([
      // Fade In (fast)
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 30, // faster (shorter portion of total time)
      ),
      // Fade Out (slow)
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 70, // slower fade-out
      ),
    ]).animate(_controller);

    _controller.forward();

    // ⏰ Navigate after 4 seconds (total animation length)
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RoleSelectionPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7E9),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/images/sdc.png',
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }
}
