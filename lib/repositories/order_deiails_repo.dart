import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class OrderDeiailsRepo {
  static const String _baseUrl = 'https://kwik-backend.vercel.app';

  Future<Map<String, dynamic>> getorderdetails(
      {required String orderID}) async {
    const String apiKey = 'arjun';
    const String apiSecret = 'digi9';
    final headers = {
      'api_Key': apiKey,
      'api_Secret': apiSecret,
    };

    // Fetch from API
    final response =
        await http.get(Uri.parse('$_baseUrl/order/$orderID'), headers: headers);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load UI data');
    }
  }
}
