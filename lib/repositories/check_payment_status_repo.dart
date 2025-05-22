import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CheckPaymentstatus {
  final String baseUrl = dotenv.env['API_URL']!;
  final headers = {
    'Content-Type': 'application/json',
    'api_Key': dotenv.env['API_KEY']!,
    'api_Secret': dotenv.env['API_SECRET']!,
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
