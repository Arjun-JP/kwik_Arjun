import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class RecommendedProductRepo {
  final String baseUrl = dotenv.env['API_URL']!;
  final user = FirebaseAuth.instance.currentUser;
  Future<List<ProductModel>> getProductsBySubCategory(String categoryId) async {
    final headers = {
      'api_Key': dotenv.env['API_KEY']!,
      'api_Secret': dotenv.env['API_SECRET']!,
    };

    final response = await http.get(
        Uri.parse(
            '$baseUrl/product/get/recommendedProducts/${user!.uid}?categoryId=$categoryId'),
        headers: headers);
    // print(user!.uid ?? "null");
    // print(categoryId);
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> bodydata = json.decode(response.body);

      if (bodydata.containsKey("randomTenProducts") &&
          bodydata["randomTenProducts"] is List) {
        List<dynamic> data = bodydata["randomTenProducts"];

        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        return []; // Return an empty list if "data" is missing or not a list.
      }
    } else {
      throw Exception("Failed to load products");
    }
  }
}
