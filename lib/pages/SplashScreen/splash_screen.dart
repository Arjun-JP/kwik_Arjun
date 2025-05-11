import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/widgets/location_permission_bottom_sheet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = '';

  @override
  void initState() {
    // Simulate a 3-second loading period
    _checkAuthState();
    super.initState();
  }

  Future<void> _checkAuthState() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    // Use auth state changes instead of currentUser
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        if (user != null) {
          // User is signed in
          GoRouter.of(context).go('/home');
        } else {
          // User is signed out
          GoRouter.of(context).go('/loginPage');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;

    Future<void> toOnboardScreen() async {
      context.go('/onboardingScreen');

      await showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: const LocationPermissionBottomSheet(),
            ),
          );
        },
      );
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
                begin: deviceheight * 0.1474, end: 300), //deviceheight*0.1474
            curve: Curves.fastEaseInToSlowEaseOut,
            duration: const Duration(seconds: 3),
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
