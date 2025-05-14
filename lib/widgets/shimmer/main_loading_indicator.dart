import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart'; // Import go_router

class MainLoadingIndicator extends StatefulWidget {
  final Duration splashDuration;
  final String nextRoute; // Add nextRoute

  const MainLoadingIndicator({
    Key? key,
    this.splashDuration = const Duration(seconds: 3),
    this.nextRoute = '/home', // Default route
  }) : super(key: key);

  @override
  _MainLoadingIndicatorState createState() => _MainLoadingIndicatorState();
}

class _MainLoadingIndicatorState extends State<MainLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  bool _showLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Start with logo visible
    _controller.forward();

    // After splash duration, navigate to next screen using go_router
    Timer(widget.splashDuration, () {
      if (mounted) {
        context.go(widget.nextRoute); // Use context.go
      }
    });

    // Show loading text after 500ms
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _showLoading = true);
      }
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/kwik-page-animation.json',
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),

            // if (_showLoading)
            //   FadeTransition(
            //     opacity: _opacityAnimation,
            //     child: const Text(
            //       'Skip the store, we\'re at your door!',
            //       style: TextStyle(
            //         fontSize: 16,
            //         color: Color.fromARGB(255, 144, 144, 144),
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
