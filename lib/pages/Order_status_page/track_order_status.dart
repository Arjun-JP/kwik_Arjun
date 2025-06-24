import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/network_check.dart';
import 'package:kwik/repositories/track_order_status_repo.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String _deiveryboyname = '';
  String _deiveryboynumber = '';
  bool _isLoading = true;

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

    // Start polling every 10 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkOrderStatus();
    });
  }

  Future<void> _checkOrderStatus() async {
    try {
      final fetchedStatus = await trackRepo.trackorder(orderID: widget.orderID);
      if (mounted) {
        setState(() {
          status = fetchedStatus;
          _orderStatus = status["data"]["order_status"] ?? "Order placed";
          _deiveryboyname = status["data"]["delivery_boy"]["displayName"];
          _deiveryboynumber = status["data"]["delivery_boy"]["phone"];
          _isLoading = false;
        });

        if (_orderStatus == 'Delivered' || _orderStatus == 'Delivery failed') {
          _pollingTimer?.cancel(); // Stop polling
        }
      }
    } catch (e) {
      print("Error while tracking order: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
      case 'Delivery Partner Assigned':
        return [
          'Your order has been assigned.',
          "We've assigned your order to a delivery partner. They’ll be on their way shortly with your items.",
          'assets/images/delivery-team.json'
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
    if (_isLoading) {
      return Scaffold(
          body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Lottie.asset('assets/images/kwik-page-animation.json',
              width: 200, height: 200, fit: BoxFit.cover),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  children: [
                    Text(
                      _getStatusMessage()[0],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    Lottie.asset(
                      height: 250,
                      _getStatusMessage()[2],
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      _getStatusMessage()[1],
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "OrderId #${widget.orderID}",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "OTP CODE - ${status["data"]["otp"] ?? '----'}",
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    _orderStatus == "Delivery Partner Assigned" ||
                            _orderStatus == "Out for delivery"
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: .5,
                                  color:
                                      const Color.fromARGB(255, 255, 139, 49)),
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 251, 241, 233),
                            ),
                            child: Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage(
                                          "assets/images/pizza 1.png",
                                        ),
                                      )),
                                    )),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _deiveryboyname,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Text(
                                        "I'm on the way with your order. Please keep your phone nearby!",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      onPressed: () async {
                                        HapticFeedback.mediumImpact();
                                        final Uri launchUri = Uri(
                                          scheme: 'tel',
                                          path: _deiveryboynumber,
                                        );
                                        if (await canLaunchUrl(launchUri)) {
                                          await launchUrl(launchUri);
                                        } else {
                                          throw 'Could not launch $_deiveryboynumber';
                                        }
                                      },
                                      icon: const Icon(Icons.call_rounded)),
                                )
                              ],
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
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
