import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeUiRepository {
  // Define the base URL directly within the repository
  static const String _baseUrl = 'http://localhost:3000';

  Future<Map<String, dynamic>> fetchUiData() async {
    const String apiKey = 'arjun';
    const String apiSecret = 'digi9';

    final headers = {
      'api_Key': apiKey,
      'api_Secret': apiSecret,
    };

    final response =
        await http.get(Uri.parse('$_baseUrl/ui/getui'), headers: headers);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to load UI data');
    }
  }
}
