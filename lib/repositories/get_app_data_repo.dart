import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GetAppDataRepo {
  final String baseUrl =
      "${dotenv.env['API_URL']!}/applicationManagement/settings"; // Replace with your API URL

  Future<Map<String, dynamic>> getappdata() async {
    final headers = {
      'api_Key': dotenv.env['API_KEY']!,
      'api_Secret': dotenv.env['API_SECRET']!,
    };
    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    print(response.statusCode);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
