import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/main.dart';
import 'package:kwik/pages/OnboardingScreen/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height; //678

    void toOnboardScreen() {
      context.go('/onboardingScreen');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: TweenAnimationBuilder(
            onEnd: () {
              toOnboardScreen();
            },
            tween: Tween<double>(
                begin: deviceheight * 0.1474, end: 500), //deviceheight*0.1474
            curve: Curves.bounceInOut,
            duration: Duration(seconds: 3),
            builder: (context, value, child) => Image.asset(
              "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
              height: value,
              width: value,
            ),
          ),
        ),
      ),
    );
  }
}
