import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/pages/SplashScreen/splash_screen.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/splashScreen',
    builder: (BuildContext context, GoRouterState state) {
      return const SplashScreen();
    },
  ),
]);
