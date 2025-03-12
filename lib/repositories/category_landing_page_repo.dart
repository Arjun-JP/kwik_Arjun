import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/subcategory_model.dart';

class CategoryLandingPageRepo {
  String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'Content-Type':
        'application/json', // Add this to specify the content type as JSON
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };

  /// Fetch all subcategories of a given category ID (GET request)
  Future<List<SubCategoryModel>> fetchSubCategories(String categoryId) async {
    final url = Uri.parse('$baseUrl/subcategory/allsubcategories/$categoryId');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> subCategoryData = json.decode(response.body);

        // Map the list of subcategories to SubCategoryModel objects
        return subCategoryData
            .map(
                (subcategoryJson) => SubCategoryModel.fromJson(subcategoryJson))
            .toList();
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      throw Exception('Error fetching subcategories: $e');
    }
  }

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
