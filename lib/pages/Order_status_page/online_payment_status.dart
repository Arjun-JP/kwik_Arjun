import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/repositories/check_payment_status_repo.dart';
import 'package:lottie/lottie.dart';

class PaymentStatusCheckPage extends StatefulWidget {
  final String orderId;

  const PaymentStatusCheckPage({super.key, required this.orderId});

  @override
  State<PaymentStatusCheckPage> createState() => _PaymentStatusCheckPageState();
}

class _PaymentStatusCheckPageState extends State<PaymentStatusCheckPage> {
  final CheckPaymentstatus _paymentRepo = CheckPaymentstatus();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final status = await _paymentRepo.getOrderStatusByOrderId(widget.orderId);
      if (status == null) return;

      if (status.toLowerCase() == 'paid') {
        _stopPolling();
        if (context.mounted) {
          context.go('/order-success');
        }
      } else if (status.toLowerCase() == 'failed') {
        _stopPolling();
        if (context.mounted) {
          context.go('/network_error');
        }
      }
      // if status is "active", do nothing and keep polling
    });
  }

  void _stopPolling() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable back navigation
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Lottie.asset(
                  'assets/images/kwik-page-animation.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: Text(
                  '💳 Processing your payment...Please don’t close the app — we’re almost done!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
