import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeUiRepository {
  // Define the base URL directly within the repository
  static const String _baseUrl = 'https://kwik-backend.vercel.app';

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
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load UI data');
    }
  }
}
