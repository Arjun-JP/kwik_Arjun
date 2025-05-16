import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:kwik/models/product_model.dart';

class UpdateUeserRepo {
  final String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'api_Key': "arjun",
    'api_Secret': "digi9",
  };
  final user = FirebaseAuth.instance.currentUser;

  Future<void> updateuserinmogo(
      {required String name, required String email}) async {
    final response = await http.put(Uri.parse("$baseUrl/users/${user!.uid}"),
        headers: headers,
        body: jsonEncode({"displayName": name, "email": email}));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
    } else {
      throw Exception("Failed to load initial products");
    }
  }
}
