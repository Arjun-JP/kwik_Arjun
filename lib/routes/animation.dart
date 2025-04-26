import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessTransitionPage extends CustomTransitionPage<void> {
  SuccessTransitionPage({required Widget child})
      : super(
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Stack(
              children: [
                // Background fade (using a Container as the child)
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
                    ),
                  ),
                  child: Container(
                    // Added a Container as the child
                    color: Colors
                        .transparent, // You can set a background color if needed
                  ),
                ),

                // Checkmark animation
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.2,
                  left: 0,
                  right: 0,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve:
                            const Interval(0.2, 0.5, curve: Curves.elasticOut),
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80,
                    ),
                  ),
                ),

                // Success message
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.12,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
                      ),
                    ),
                    child: const Text(
                      'Address Added Successfully!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Content slide up
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve:
                          const Interval(0.4, 1.0, curve: Curves.easeOutQuart),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
                      ),
                    ),
                    child: child,
                  ),
                ),
              ],
            );
          },
        );
}
