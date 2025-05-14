import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Order_management.dart/order_management_bloc.dart';
import 'package:kwik/bloc/Order_management.dart/order_management_state.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_event.dart';
// import 'package:lottie/lottie.dart';

class OrderProcessingPage extends StatelessWidget {
  const OrderProcessingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrderManagementBloc, OrderManagementState>(
          builder: (context, createorderstate) {
        if (createorderstate is OrderPlacing) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/kwiklogo.png",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 30),

                // Order Confirmation Text
                Text(
                  'Order Processing',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 30),

                // Appreciation Message
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Thank you for choosing Kwik! Your trust is valuable to us. '
                    'We\'re processing your order',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (createorderstate is OrderPlaced) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      "assets/images/kwiklogo.png",
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
                    //         'Order ID: ${createorderstate.orderResponse['_id'] ?? "126354"}',
                    //         style: const TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 8),
                    //       Text(
                    //         'Total Amount: ₹ ${createorderstate.orderResponse['total_amount'] ?? "3654"}',
                    //         style: const TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 8),
                    //       Text(
                    //         'Total Saved: ₹ ${createorderstate.orderResponse['total_saved']}??"44',
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

                    const Spacer(),

                    // Action Buttons
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();

                              context
                                  .read<NavbarBloc>()
                                  .add(const UpdateNavBarIndex(0));
                              context.go('/orders');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFC5B00),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              'Track Order',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
            ),
          );
        }
        if (createorderstate is PlaceorderOrderError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    Image.asset(
                      "assets/images/kwiklogo.png",
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 30),

                    // Order Confirmation Text
                    Text(
                      'Oh no! So sorry to hear your order didn\'t go through',
                      textAlign: TextAlign.center,
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
        return const SizedBox();
      }),
    );
  }
}
