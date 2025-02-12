import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/subcategory_model.dart';

class CategoryModel6Repo {
  String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'Content-Type': 'application/json',
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };

  /// Fetch all subcategories (GET request)
  Future<List<SubCategoryModel>> fetchAllSubCategories() async {
    final url = Uri.parse('$baseUrl/subcategory/allsubcategories');
    print("Fetching all subcategories from: \$url");
    try {
      final response = await http.get(url, headers: headers);
      print("Response status: \${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> subCategoryData = json.decode(response.body);
        print("Subcategory data fetched successfully");
        return subCategoryData
            .map(
                (subcategoryJson) => SubCategoryModel.fromJson(subcategoryJson))
            .toList();
      } else {
        throw Exception('Failed to load all subcategories');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching all subcategories: $e');
    }
  }
}
