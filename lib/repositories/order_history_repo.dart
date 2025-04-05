import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
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

      print('📡 Response Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is List) {
            final List<dynamic> jsonResponse = decoded['data'];

            // Debug print to check structure
            print('✅ Parsed Data Type: ${jsonResponse.runtimeType}');
            print('📋 Parsed Orders Preview: ${jsonResponse.take(1)}');

            return jsonResponse
                .map((data) => Order.fromJson(data as Map<String, dynamic>))
                .toList();
          } else {
            throw FormatException(
                "Key 'data' not found or not a List in the response JSON.");
          }
        } else {
          throw FormatException(
              "Expected a JSON object but got something else.");
        }
      } else {
        throw HttpException(
          'Server responded with status code ${response.statusCode}',
          uri: Uri.parse('$baseUrl/order/user/$userId'),
        );
      }
    } on FormatException catch (e) {
      print('❌ Format error: $e');
      rethrow;
    } on HttpException catch (e) {
      print('❌ HTTP error: $e');
      rethrow;
    } on SocketException {
      print('❌ Network error: No Internet connection');
      throw Exception('No Internet connection');
    } catch (e, stacktrace) {
      print('❌ Unknown error: $e');
      print('📌 Stacktrace: $stacktrace');
      throw Exception('Unexpected error occurred: $e');
    }
  }
}
