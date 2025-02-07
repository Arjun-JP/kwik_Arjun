import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/pages/Category_page/category_page.dart';
import 'package:kwik/pages/Home_page/home_Page.dart';
import 'package:kwik/pages/LoginPage/login_page.dart';
import 'package:kwik/pages/Offer_Page/offer_page.dart';
import 'package:kwik/pages/OnboardingScreen/onboarding_screen.dart';
import 'package:kwik/pages/SplashScreen/splash_screen.dart';
import 'package:kwik/pages/cart_page/cart_page.dart';
import 'package:kwik/pages/profile/profile_page.dart';

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
      path: '/category',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(
          child: CategoryPage(), // Replace with your actual home page widget
        );
      },
    ),
    GoRoute(
      path: '/offer',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(
          child: OfferPage(), // Replace with your actual home page widget
        );
      },
    ),
    GoRoute(
      path: '/cart',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(
          child: CartPage(), // Replace with your actual home page widget
        );
      },
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(
          child: ProfilePage(), // Replace with your actual home page widget
        );
      },
    ),
    GoRoute(
      path: '/loginPage',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(
          child: HomePage(), // Replace with your actual home page widget
        );
      },
    ),
  ],
);
