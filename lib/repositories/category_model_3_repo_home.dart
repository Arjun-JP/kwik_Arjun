import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:kwik/models/subcategory_model.dart';

import '../models/category_model.dart';

class CategoryRepositoryModel3Home {
  final String baseUrl = dotenv.env['API_URL']!; // Replace with your API

  Future<Category> fetchCategoryDetails(String categoryId) async {
    try {
      final headers = {
        'api_Key': dotenv.env['API_KEY']!,
        'api_Secret': dotenv.env['API_SECRET']!,
      };

      final response = await http
          .get(Uri.parse('$baseUrl/category/$categoryId'), headers: headers);

      if (response.statusCode == 200) {
        var category = Category.fromJson(jsonDecode(response.body));
        return category;
      } else {
        throw Exception("Failed to fetch category details");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<SubCategoryModel>> fetchSubCategories(String categoryId) async {
    try {
      final headers = {
        'api_Key': dotenv.env['API_KEY']!,
        'api_Secret': dotenv.env['API_SECRET']!,
      };
      final response = await http.get(
          Uri.parse('$baseUrl/subcategory/allsubcategories'),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> subCategoryData = json.decode(response.body);

        // Map the list of subcategories to SubCategoryModel objects
        return subCategoryData
            .map(
                (subcategoryJson) => SubCategoryModel.fromJson(subcategoryJson))
            .toList();
      } else {
        throw Exception("Failed to load subcategories");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
