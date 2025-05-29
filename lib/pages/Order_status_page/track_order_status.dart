import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/network_check.dart';
import 'package:kwik/repositories/track_order_status_repo.dart';
import 'package:lottie/lottie.dart';

class OrderStatusPage extends StatefulWidget {
  final String orderID;

  const OrderStatusPage({super.key, required this.orderID});

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  final TrackorderRepo trackRepo = TrackorderRepo();

  String _orderStatus = 'Order placed';
  Timer? _pollingTimer;
  Map<String, dynamic> status = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NetworkUtils.checkConnection(context);
    });
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    // Immediately check status once
    _checkOrderStatus();

    // Start polling every 30 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkOrderStatus();
    });
  }

  Future<void> _checkOrderStatus() async {
    try {
      status = await trackRepo.trackorder(orderID: widget.orderID);

      if (mounted) {
        setState(() {
          _orderStatus = status["data"][
              "order_status"]; // Assume status is a string like "confirmed", "delivered", etc.
        });

        if (status == 'Delivered' || status == 'Delivery failed') {
          _pollingTimer?.cancel(); // Stop polling
        }
      }
    } catch (e) {
      print("Error while tracking order: $e");
    }
  }

//  enum: ["Packing", "Out for delivery", "Delivered", "Delivery failed", "Order placed"],
  List<String> _getStatusMessage() {
    switch (_orderStatus) {
      case 'Packing':
        return [
          'Your Order is Being Packed',
          'We’re carefully packing your items to get them ready for dispatch. Hang tight—it’s almost on the way!',
          'assets/images/worker-packing-the-goods.json'
        ];
      case 'Out for delivery':
        return [
          'Your order is on the way!',
          'Your order is on the move and will reach you shortly. Please keep your phone nearby for any delivery updates',
          'assets/images/deliveryman-riding-scooter.json'
        ];
      case 'Delivered':
        return [
          'Your order has been delivered.',
          "Your order has been successfully delivered. We hope you enjoy your purchase!",
          'assets/images/delivery-service.json'
        ];

      case 'Delivery failed':
        return [
          'Delivery Attempt Unsuccessful',
          'We couldn’t deliver your order. Please check your details or contact support for assistance.',
          'assets/images/delivery-team.json'
        ];
      case 'Order placed':
        return [
          'Order Placed Successfully',
          'We’ve received your order and will start processing it shortly. Sit back and relax while we get things ready!',
          'assets/images/delivery-service-review.json'
        ];
      default:
        return [
          'Processing your order...',
          'Hang tight! We\'re getting everything ready to fulfill your order',
          'assets/images/delivery-team.json'
        ];
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              _getStatusMessage()[0],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Lottie.asset(
              _getStatusMessage()[2],
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              _getStatusMessage()[1],
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "OrderId #${widget.orderID}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "OTP CODE - ${status["data"]["otp"]}",
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w800, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.push('/help');
                    },
                    child: const Text("Contact Us"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.push('/home');
                    },
                    child: const Text("Order Again"),
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
