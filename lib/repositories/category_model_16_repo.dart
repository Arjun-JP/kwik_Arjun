import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kwik/models/subcategory_model.dart';

class categoryRepositoryModel16 {
  final String baseUrl =
      "https://kwik-backend.vercel.app"; // Replace with your API

  Future<List<SubCategoryModel>> fetchSubCategories() async {
    try {
      const String apiKey = 'arjun';
      const String apiSecret = 'digi9';

      final headers = {
        'api_Key': apiKey,
        'api_Secret': apiSecret,
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
