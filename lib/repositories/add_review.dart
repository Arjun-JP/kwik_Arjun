import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ReviewRepository {
  final String baseUrl = 'https://kwik-backend.vercel.app';
  final headers = {
    'Content-Type': 'application/json',
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };
  final user = FirebaseAuth.instance.currentUser;
  Future<void> addReview({
    required List<Map<String, dynamic>> review,
  }) async {
    print(review);
    for (int i = 0; i < review.length; i++) {
      final response = await http.post(
        Uri.parse("$baseUrl/product/addReview/${review[i]['id']}"),
        headers: headers,
        body: jsonEncode({
          "user_ref": user!.uid,
          "comment": review[i]['comment'],
          "rating": review[i]['rating']
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode != 200) {
        throw Exception('Failed to add review');
      }
    }

    print(review);
  }
}
