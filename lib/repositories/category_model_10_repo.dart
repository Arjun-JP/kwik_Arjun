import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class CategoryModel10Repo {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<List<ProductModel>> getProductsBySubCategory(
      String subCategoryId) async {
    final headers = {
      'api_Key': dotenv.env['API_KEY']!,
      'api_Secret': dotenv.env['API_SECRET']!,
    };

    final response = await http.get(
        Uri.parse('$baseUrl/product/subcategory/$subCategoryId'),
        headers: headers);

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
  }
}
