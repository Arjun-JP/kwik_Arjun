import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/subcategory_model.dart';

class CategoryLandingPageRepo {
  String baseUrl = dotenv.env['API_URL']!;

  final headers = {
    'Content-Type':
        'application/json', // Add this to specify the content type as JSON
    'api_Key': dotenv.env['API_KEY']!,
    'api_Secret': dotenv.env['API_SECRET']!,
  };

  /// Fetch all subcategories of a given category ID (GET request)
  Future<List<SubCategoryModel>> fetchSubCategories(String categoryId) async {
    final url = Uri.parse('$baseUrl/subcategory/allsubcategories');

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
      String categoryID, List<String> subCategoryIds) async {
    final url = Uri.parse('$baseUrl/product/allproducts');

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> bodydata = json.decode(response.body);

        if (bodydata.isNotEmpty) {
          return bodydata.map((json) => ProductModel.fromJson(json)).toList();
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
