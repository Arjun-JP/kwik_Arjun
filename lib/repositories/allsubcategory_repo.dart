import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/subcategory_model.dart';

class AllsubcategoryRepo {
  final String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'Content-Type': 'application/json',
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };

  Future<List<SubCategoryModel>> fetchSubCategories(String categoryId) async {
    final url = Uri.parse('$baseUrl/subcategory/allsubcategories/$categoryId');
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((json) => SubCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      throw Exception('Error fetching subcategories: $e');
    }
  }

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
          return (bodydata["data"] as List)
              .map((json) => ProductModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
