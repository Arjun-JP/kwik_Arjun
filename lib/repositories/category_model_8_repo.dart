import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kwik/models/subcategory_model.dart';
import '../models/category_model.dart';

class Categorymodel8Repository {
  final String baseUrl =
      "${dotenv.env['API_URL']!}/subcategory/allsubcategories"; // Replace with your API URL

  Future<List<SubCategoryModel>> fetchCategories() async {
    final headers = {
      'api_Key': dotenv.env['API_KEY']!,
      'api_Secret': dotenv.env['API_SECRET']!,
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
