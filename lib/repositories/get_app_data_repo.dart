import 'dart:convert';
import 'package:http/http.dart' as http;

class GetAppDataRepo {
  final String baseUrl =
      "https://kwik-backend.vercel.app/applicationManagement/settings"; // Replace with your API URL

  Future<Map<String, dynamic>> getappdata() async {
    const String apiKey = 'arjun';
    const String apiSecret = 'digi9';

    final headers = {
      'api_Key': apiKey,
      'api_Secret': apiSecret,
    };
    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
