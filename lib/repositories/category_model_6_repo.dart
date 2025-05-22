import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/subcategory_model.dart';

class CategoryModel6Repo {
  String baseUrl = dotenv.env['API_URL']!;

  final headers = {
    'Content-Type': 'application/json',
    'api_Key': dotenv.env['API_KEY']!,
    'api_Secret': dotenv.env['API_SECRET']!,
  };

  /// Fetch all subcategories (GET request)
  Future<List<SubCategoryModel>> fetchAllSubCategories() async {
    final url = Uri.parse('$baseUrl/subcategory/allsubcategories');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> subCategoryData = json.decode(response.body);

        return subCategoryData
            .map(
                (subcategoryJson) => SubCategoryModel.fromJson(subcategoryJson))
            .toList();
      } else {
        throw Exception('Failed to load all subcategories');
      }
    } catch (e) {
      throw Exception('Error fetching all subcategories: $e');
    }
  }
}
