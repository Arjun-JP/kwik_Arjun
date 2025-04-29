import 'package:flutter/material.dart';
import 'dart:async';

class MainLoadingIndicator extends StatefulWidget {
  final Duration splashDuration;

  const MainLoadingIndicator({
    Key? key,
    this.splashDuration = const Duration(seconds: 3),
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
      duration: const Duration(milliseconds: 1000),
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

    // After splash duration, navigate to next screen
    Timer(widget.splashDuration, () {
      if (mounted) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (_) => widget.nextScreen),
        // );
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
            FadeTransition(
              opacity: _opacityAnimation,
              child: Image.asset(
                'assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg', // Your logo asset
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 24),
            if (_showLoading)
              FadeTransition(
                opacity: _opacityAnimation,
                child: const Text(
                  'Skip the store, we\'re at your door!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 144, 144, 144), // Blinkit green
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
