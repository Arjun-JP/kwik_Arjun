import 'package:flutter/material.dart';
import 'package:kwik/main.dart';

class CustomSnackBars {
  static void showTopSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.orange,
  }) {
    // Get the MediaQuery data including the padding
    final mediaQuery = MediaQuery.of(rootScaffoldMessengerKey.currentContext!);
    final paddingTop = mediaQuery.padding.top;

    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          top: 40 + paddingTop, // Add the top padding here
          left: 10,
          right: 10,
          bottom: mediaQuery.size.height - 200,
        ),
        duration: duration,
        content: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Image.asset(
                  width: 50,
                  height: 50,
                  'assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg'),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () {
                  rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showLimitedQuantityWarning() {
    showTopSnackBar(
        message: "Sorry, we have a limited quantity available for this item.",
        backgroundColor: const Color.fromARGB(255, 248, 109, 101));
  }

  static void showOutOfStock() {
    showTopSnackBar(
      message: "Sorry, This product is out of stock",
      backgroundColor: const Color.fromARGB(255, 255, 53, 39),
    );
  }
}
