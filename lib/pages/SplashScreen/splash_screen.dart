import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/force_update_bloc/force_update_bloc.dart';
import 'package:kwik/bloc/force_update_bloc/force_update_event.dart';
import 'package:kwik/widgets/location_permission_bottom_sheet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String version = '';
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  @override
  void initState() {
    // Simulate a 3-second loading period
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

    // Show loading text after 500ms
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {}
    });
    _checkAuthState();
    super.initState();
  }

  Future<void> _checkAuthState() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    // Use auth state changes instead of currentUser
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (mounted) {
        await Future.delayed(const Duration(seconds: 3), () {});
        if (user != null) {
          GoRouter.of(context).go('/home');
        } else {
          GoRouter.of(context).go('/onboardingScreen');
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
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/kwiklogo.png', // Replace with your logo asset path
                // width: 120,
                // height: 120,
              ),
              // FadeTransition(
              //   opacity: _opacityAnimation,
              //   child: const Text(
              //     'Skip the store, we\'re at your door!',
              //     style: TextStyle(
              //       fontSize: 16,
              //       color: Color.fromARGB(255, 144, 144, 144),
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
