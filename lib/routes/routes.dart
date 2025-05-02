import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/pages/Category_page/category_page.dart';
import 'package:kwik/pages/Error_pages/network_error_page.dart';
import 'package:kwik/pages/FAQ_page/faq_questions.dart';
import 'package:kwik/pages/Home_page/home_page.dart';
import 'package:kwik/pages/LoginPage/login_page.dart';
import 'package:kwik/pages/No_service_page/no_service_page.dart';
import 'package:kwik/pages/Offer_Page/offer_page.dart';
import 'package:kwik/pages/OnboardingScreen/onboarding_screen.dart';
import 'package:kwik/pages/Order_status_page/order_placed_page.dart';
import 'package:kwik/pages/OtpVerificationPage/otp_verification_page.dart';
import 'package:kwik/pages/PrivacyPolicy_Page/PrivacyPolicyPage.dart';
import 'package:kwik/pages/Search%20page/search_page.dart';
import 'package:kwik/pages/SplashScreen/splash_screen.dart';
import 'package:kwik/pages/Terms_and_condition/Terms_and_condition.dart';
import 'package:kwik/pages/all_subcategory/all_suubcategory.dart';
import 'package:kwik/pages/brand_page/brand_page.dart';
import 'package:kwik/pages/cart_page/cart_page.dart';
import 'package:kwik/pages/category_landing_page/category_landing_page.dart';
import 'package:kwik/pages/help_support/help_and_support.dart';
import 'package:kwik/pages/Order_details_page/order_details_page.dart';
import 'package:kwik/pages/order_list_page.dart/order_list.dart.dart';
import 'package:kwik/pages/product_details_page/product_details_page.dart';
import 'package:kwik/pages/profile/profile_page.dart';
import 'package:kwik/pages/subcategory_products/subcategory_products.dart'; // Import Firebase Auth

final GoRouter router = GoRouter(
  // * The initialRoute is set to splashScreen.
  initialLocation: '/splashScreen',
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
      path: '/__/auth/callback',
      redirect: (context, state) {
        // Extract verificationId from the callback URL
        final uri = Uri.parse(state.uri.toString());
        final verificationId = uri.queryParameters['verificationId'] ?? '';

        if (verificationId.isNotEmpty) {
          return '/OtpVerificationPage/$verificationId';
        }
        return '/loginPage'; // Fallback if no verificationId
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
      path: '/searchpage',
      builder: (BuildContext context, GoRouterState state) {
        return const SearchPage();
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
      path: '/homeWA',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(), // Replace with your actual home page widget
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            // You can choose from various transition animations here
            // For example: FadeTransition, SlideTransition, ScaleTransition, etc.

            // Example: Fade in animation
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
          transitionDuration:
              const Duration(milliseconds: 300), // Adjust duration as needed
        );
      },
    ),
    GoRoute(
      path: '/productdetails',
      builder: (BuildContext context, GoRouterState state) {
        final extraData = state.extra as Map<String, dynamic>?;

        if (extraData == null ||
            !extraData.containsKey('product') ||
            !extraData.containsKey('subcategoryref') ||
            !extraData.containsKey('buttonbg') ||
            !extraData.containsKey('buttontext')) {
          throw Exception("Missing required parameters");
        }

        final product = extraData['product'] as ProductModel;
        final subcategoryref = extraData['subcategoryref'] as String;
        final buttonbg = extraData['buttonbg'] as Color;
        final buttontext = extraData['buttontext'] as Color;

        return ProductDetailsPage(
          product: product,
          subcategoryref: subcategoryref,
          buttonbg: buttonbg,
          buttontext: buttontext,
        );
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
    ),
    GoRoute(
      path: '/allsubcategorypage',
      builder: (context, state) {
        final categoryrId = state.uri.queryParameters['categoryId'] ?? '';
        final selectedsubcategory =
            state.uri.queryParameters['selectedsubcategory'];

        return AllSubcategory(
          categoryrId: categoryrId,
          selectedsubcategory:
              selectedsubcategory, // Explicitly assign as a named argument
        );
      },
    ),
    GoRoute(
      path: '/brand',
      builder: (context, state) {
        final brandid = state.uri.queryParameters['brandid'] ?? '';
        final brandname = state.uri.queryParameters['brandname'] ?? '';
        final branddes = state.uri.queryParameters['branddes'] ?? '';
        final brandimageurl = state.uri.queryParameters['brandimageurl'] ?? '';
        final websiteurl = state.uri.queryParameters['websiteurl'] ?? '';
        final color = state.uri.queryParameters['color'] ??
            '000000'; // Default to black if missing

        return BrandPage(
          brandid: brandid,
          brandname: brandname,
          branddes: branddes,
          brandimageurl: brandimageurl,
          websiteurl: websiteurl,
          color: color, // Pass as string
        );
      },
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => OrderListingPage(),
    ),
    GoRoute(
      path: '/faq', // The path for the FAQ page
      builder: (BuildContext context, GoRouterState state) {
        return const FAQPage(); // Return the FAQPage widget
      },
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) {
        final text = state.extra as Map<String, String>;
        return PrivacyPolicyPage(
          privacyText: text['privacyText'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/terms',
      name: 'terms',
      builder: (context, state) {
        final data = state.extra as Map<String, String>;
        return TermsAndConditionPage(terms: data['terms'] ?? '');
      },
    ),
    GoRoute(
      path: '/help',
      name: 'help',
      builder: (context, state) => const HelpAndSupportPage(),
    ),
    GoRoute(
      path: '/order/:orderId',
      name: 'orderDetails',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return OrderDetailsPage(orderID: orderId);
      },
    ),
    GoRoute(
      path: '/network-error',
      builder: (context, state) => const NetworkErrorPage(),
    ),
    GoRoute(
      path: '/subcategory-products',
      builder: (context, state) {
        final subcategoryId = state.uri.queryParameters['subcategoryid'] ?? '';
        final subcatName = state.uri.queryParameters['subcatname'] ?? '';

        return SubcategoryProductsPage(
          subcategoryid: subcategoryId,
          subcatname: subcatName,
        );
      },
    ),
    GoRoute(
      path: '/no-service',
      builder: (context, state) => const NoServicePage(),
    ),
    GoRoute(
      path: '/order-success', // Define the path for your order success page
      builder: (BuildContext context, GoRouterState state) {
        return const OrderSuccessPage();
      },
    ),
  ],
);
