import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class RecommendedProductRepo {
  final String baseUrl = "https://kwik-backend.vercel.app";

  Future<List<ProductModel>> getProductsBySubCategory(String categoryId) async {
    const String apiKey = 'arjun';
    const String apiSecret = 'digi9';
    final headers = {
      'api_Key': apiKey,
      'api_Secret': apiSecret,
    };

    final response = await http.get(
        Uri.parse(
            '$baseUrl/product/get/recommendedProducts/s5ZdLnYhnVfAramtr7knGduOI872?categoryId=$categoryId'),
        headers: headers);
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
