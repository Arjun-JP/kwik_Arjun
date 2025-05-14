import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class OrderManagementRepository {
  OrderManagementRepository();
  final String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'Content-Type': 'application/json',
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };
  final user = FirebaseAuth.instance.currentUser;
  Future<Map<String, dynamic>> placeOrder(
      {required Map<String, dynamic> orderJson // 'instant' or 'slot'

      }) async {
    print("passed json $orderJson");
    final response = await http.post(
      Uri.parse("$baseUrl/order"),
      headers: {
        'Content-Type': 'application/json',
        'api_Key': 'arjun',
        'api_Secret': 'digi9',
      },
      body: jsonEncode(orderJson), // <<<< pass orderJson directly
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to place order');
    }
  }

  Future<Map<String, dynamic>> getOrderStatus(String orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/$orderId/status'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get order status');
    }
  }

  Future<List<dynamic>> getLiveOrders(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/live?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['orders'];
    } else {
      throw Exception('Failed to get live orders');
    }
  }

  Future<bool> updateDeliveryType({
    required String orderId,
    required String newDeliveryType,
    String? newDeliverySlot,
  }) async {
    final payload = {
      'delivery_type': newDeliveryType,
      if (newDeliverySlot != null) 'delivery_slot': newDeliverySlot,
    };

    final response = await http.patch(
      Uri.parse('$baseUrl/orders/$orderId/delivery'),
      body: json.encode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> createOrderOnlinepayment(
      {required Map<String, dynamic> orderJson, required String uid}) async {
    print("passed json $orderJson");
    final responseplaceorder = await http.post(
      Uri.parse("$baseUrl/order"),
      headers: {
        'Content-Type': 'application/json',
        'api_Key': 'arjun',
        'api_Secret': 'digi9',
      },
      body: jsonEncode(orderJson), // <<<< pass orderJson directly
    );
    // print(responseplaceorder.body);
    print(responseplaceorder.statusCode);
    Map<String, dynamic> orderdata = jsonDecode(responseplaceorder.body);
    print(orderdata["data"]["total_amount"]);
    print(orderdata["data"]["_id"]);
    print(orderdata["razorpayOrderId"]);
    if (responseplaceorder.statusCode == 201) {
      return orderdata;
    } else {
      throw Exception('Failed to place online order');
    }
  }
}
