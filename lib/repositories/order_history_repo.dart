import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kwik/bloc/order_bloc/order_event.dart';
import '../models/order_model.dart';

class OrderRepository {
  final String baseUrl = "https://kwik-backend.vercel.app";
  final headers = {
    'Content-Type': 'application/json',
    "api_Key": "arjun",
    "api_Secret": "digi9",
  };

  Future<List<Order>> fetchOrders(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/order/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is List) {
            final List<dynamic> jsonResponse = decoded['data'];

            return jsonResponse
                .map((data) => Order.fromJson(data as Map<String, dynamic>))
                .toList();
          } else {
            throw const FormatException(
                "Key 'data' not found or not a List in the response JSON.");
          }
        } else {
          throw const FormatException(
              "Expected a JSON object but got something else.");
        }
      } else {
        throw HttpException(
          'Server responded with status code ${response.statusCode}',
          uri: Uri.parse('$baseUrl/order/user/$userId'),
        );
      }
    } on FormatException catch (e) {
      rethrow;
    } on HttpException catch (e) {
      rethrow;
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e, stacktrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  Future<bool> orderagain(
      {required String userId, required String orderID}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/users/orderAgain'),
          headers: headers,
          body: jsonEncode({"orderId": orderID, "userId": userId}));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw HttpException(
          'Server responded with status code ${response.statusCode}',
          uri: Uri.parse('$baseUrl/order/user/$userId'),
        );
      }
    } on FormatException catch (e) {
      rethrow;
    } on HttpException catch (e) {
      rethrow;
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e, stacktrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }
}
