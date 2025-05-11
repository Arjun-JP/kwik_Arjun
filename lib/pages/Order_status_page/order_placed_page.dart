import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_event.dart';
// import 'package:lottie/lottie.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            Image.asset(
              "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 30),

            // Order Confirmation Text
            Text(
              'Order Placed Successfully!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
            ),

            const SizedBox(height: 20),

            // Order Details
            // Container(
            //   padding: const EdgeInsets.all(15),
            //   decoration: BoxDecoration(
            //     // color: Colors.grey[100],
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Column(
            //     spacing: 15,
            //     children: [
            //       Text(
            //         'Order ID: $orderId',
            //         style: const TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
            //         style: const TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 30),

            // Appreciation Message
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Thank you for choosing Kwik! Your trust is valuable to us. '
                'We\'re processing your order and will notify you once it\'s on its way.',
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
                          .add(const UpdateNavBarIndex(0));
                      context.go('/homeWA');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Order Again',
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
    );
  }
}
