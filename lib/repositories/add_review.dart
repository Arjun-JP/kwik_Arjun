import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ReviewRepository {
  final String baseUrl = dotenv.env['API_URL']!;

  final headers = {
    'Content-Type': 'application/json',
    'api_Key': dotenv.env['API_KEY']!,
    'api_Secret': dotenv.env['API_SECRET']!,
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
