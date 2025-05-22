import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kwik/models/subcategory_model.dart';

class categoryRepositoryModel16 {
  final String baseUrl = dotenv.env['API_URL']!; // Replace with your API

  Future<List<SubCategoryModel>> fetchSubCategories() async {
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
