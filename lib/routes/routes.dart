import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/pages/Category_page/category_page.dart';
import 'package:kwik/pages/Home_page/home_Page.dart';
import 'package:kwik/pages/LoginPage/login_page.dart';
import 'package:kwik/pages/Offer_Page/offer_page.dart';
import 'package:kwik/pages/OnboardingScreen/onboarding_screen.dart';
import 'package:kwik/pages/OtpVerificationPage/otp_verification_page.dart';
import 'package:kwik/pages/SplashScreen/splash_screen.dart';
import 'package:kwik/pages/cart_page/cart_page.dart';
import 'package:kwik/pages/category_landing_page/category_landing_page.dart';
import 'package:kwik/pages/product_details_page/product_details_page.dart';
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
      path: '/OtpVerificationPage/:verificationId',
      builder: (BuildContext context, GoRouterState state) {
        final verificationId = state.pathParameters['verificationId']!;
        return OtpVerificationPage(verificationId: verificationId);
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
    GoRoute(
      path: '/productdetails',
      builder: (BuildContext context, GoRouterState state) {
        final product =
            state.extra as ProductModel; // Get the product model from extra
        return ProductDetailsPage(product: product);
      },
    ),
    GoRoute(
      path: '/categorylandingpage',
      builder: (BuildContext context, GoRouterState state) {
        final data = state.extra as Map<String, dynamic>;
        final categoryModel = data['category'] as Category;
        final subcategoryIDs =
            data['subcategoryIDs'] as List<String>; // Corrected key name

        return CategoryLandingPage(
          category: categoryModel,
          subcategoryIDs:
              subcategoryIDs, // Ensure parameter name matches in the widget
        );
      },
    )
  ],
);
