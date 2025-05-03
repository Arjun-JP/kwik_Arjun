import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_event.dart';
// import 'package:lottie/lottie.dart';

class OrderErrorPage extends StatelessWidget {
  const OrderErrorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              // Lottie.asset(
              //   'assets/images/orderplaced.lottie',
              //   height: 200,
              //   repeat: false,
              // ),
              const SizedBox(height: 150),
              Image.asset(
                "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 30),

              // Order Confirmation Text
              Text(
                'Oh no! So sorry to hear your order didn\'t go through',textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 173, 52, 52),
                    ),
              ),

              const SizedBox(height: 20),


              const SizedBox(height: 30),

              // Appreciation Message
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'We encountered an issue processing your Kwik order. Please double-check your payment details and try again. If the problem persists, our support team is here to help!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),

              Spacer(),

              // Action Buttons
              Row(
                children: [
                  // Expanded(
                  //   child: OutlinedButton(
                  //     onPressed: () {
                  //       // Navigate to home
                  //       Navigator.of(context)
                  //           .popUntil((route) => route.isFirst);
                  //     },
                  //     style: OutlinedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(vertical: 15),
                  //       side: const BorderSide(color: Colors.green),
                  //     ),
                  //     child: const Text(
                  //       'Back to Home',
                  //       style: TextStyle(
                  //         color: Colors.green,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();

                        context
                            .read<NavbarBloc>()
                            .add(const UpdateNavBarIndex(3));
                        context.go('/cart');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
