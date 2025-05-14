import 'dart:convert';

import 'package:http/http.dart' as http;

class CheckPaymentstatus {
  final String baseUrl = 'https://kwik-backend.vercel.app';
  final headers = {
    'Content-Type': 'application/json',
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };
  // Get order status by order ID
  Future<String?> getOrderStatusByOrderId(String orderId) async {
    try {
      print(orderId);

      final response = await http.post(
        Uri.parse("$baseUrl/payment/checStatus"),
        headers: headers,
        body: jsonEncode({"razorpay_order_id": orderId}),
      );
      print(response.statusCode);
      // print(response.body);
      Map<String, dynamic> orderstatusdata = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return orderstatusdata['paymentStatus'];
      } else {
        throw Exception('Failed to add review');
      }
    } catch (e) {
      print('Error fetching order status: $e');
      return null;
    }
  }
}
