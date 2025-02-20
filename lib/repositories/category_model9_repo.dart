import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/subcategory_model.dart';

class Categorymodel9Repository {
  String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'Content-Type':
        'application/json', // Add this to specify the content type as JSON
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };

  /// Fetch all products for the selected subcategories (POST request)
  Future<List<ProductModel>> fetchProductsFromSubCategories(
      List<String> subCategoryIds) async {
    final url = Uri.parse('$baseUrl/product/products-by-subcategories');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({"subCategoryIds": subCategoryIds}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> bodydata = json.decode(response.body);

        if (bodydata.containsKey("data") && bodydata["data"] is List) {
          List<dynamic> data = bodydata["data"];

          return data.map((json) => ProductModel.fromJson(json)).toList();
        } else {
          return []; // Return an empty list if "data" is missing or not a list.
        }
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
