import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/pages/Home_page/home_Page.dart';
import 'package:kwik/pages/LoginPage/login_page.dart';
import 'package:kwik/pages/OnboardingScreen/onboarding_screen.dart';
import 'package:kwik/pages/SplashScreen/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splashScreen', // Set the home page as the default page
  routes: [
    GoRoute(
      path: '/splashScreen',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/onboardingScreen',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: '/loginPage',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/home', // Define the home page route
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage(); // Replace with your actual home page widget
      },
    ),
  ],
);
