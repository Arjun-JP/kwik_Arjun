import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class TrackorderRepo {
  final String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'api_Key': "arjun",
    'api_Secret': "digi9",
  };
  final user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> trackorder({
    required String orderID,
  }) async {
    final response = await http.get(
      Uri.parse("$baseUrl/order/$orderID"),
      headers: headers,
    );
    print(response.body);
    print(response.statusCode);
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    }
    return data;
  }
}
