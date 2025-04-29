import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  final String orderId;

  const PaymentPage({Key? key, required this.amount, required this.orderId})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  PaymentStatus _paymentStatus = PaymentStatus.pending;
  String _paymentId = '';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _paymentStatus = PaymentStatus.success;
      _paymentId = response.paymentId ?? '';
    });
    // Call your backend to verify payment
    _verifyPayment(response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _paymentStatus = PaymentStatus.failed;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet: ${response.walletName}')),
    );
  }

  Future<void> _verifyPayment(String paymentId) async {
    // Implement payment verification with your backend
    // await ApiService.verifyPayment(paymentId);
  }

  void _openCheckout() {
    setState(() {
      _paymentStatus = PaymentStatus.processing;
    });

    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': widget.amount * 100, // in paise
      'name': 'Your App Name',
      'description': 'Order #${widget.orderId}',
      'prefill': {'contact': '9123456789', 'email': 'customer@example.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPaymentStatus(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _paymentStatus == PaymentStatus.pending
                  ? _openCheckout
                  : null,
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatus() {
    switch (_paymentStatus) {
      case PaymentStatus.success:
        return Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            Text(
              'Payment Successful',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text('Payment ID: $_paymentId'),
          ],
        );
      case PaymentStatus.failed:
        return Column(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 60),
            const SizedBox(height: 10),
            Text(
              'Payment Failed',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
      case PaymentStatus.processing:
        return Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(
              'Processing Payment...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
      default:
        return Column(
          children: [
            Text(
              'Amount to Pay: ₹${widget.amount}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text('Order ID: ${widget.orderId}'),
          ],
        );
    }
  }
}

enum PaymentStatus { pending, processing, success, failed }
