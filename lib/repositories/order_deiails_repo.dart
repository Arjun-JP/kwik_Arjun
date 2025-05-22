import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OrderDeiailsRepo {
  static final String _baseUrl = dotenv.env['API_URL']!;

  Future<Map<String, dynamic>> getorderdetails(
      {required String orderID}) async {
    final headers = {
      'api_Key': dotenv.env['API_KEY']!,
      'api_Secret': dotenv.env['API_SECRET']!,
    };

    // Fetch from API
    final response =
        await http.get(Uri.parse('$_baseUrl/order/$orderID'), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data;
    } else {
      throw Exception('Failed to load UI data');
    }
  }
}
