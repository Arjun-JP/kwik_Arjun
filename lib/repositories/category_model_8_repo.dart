import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kwik/models/subcategory_model.dart';
import '../models/category_model.dart';

class Categorymodel8Repository {
  final String baseUrl =
      "https://kwik-backend.vercel.app/subcategory/allsubcategories"; // Replace with your API URL

  Future<List<SubCategoryModel>> fetchCategories() async {
    const String apiKey = 'arjun';
    const String apiSecret = 'digi9';

    final headers = {
      'api_Key': apiKey,
      'api_Secret': apiSecret,
    };
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => SubCategoryModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
