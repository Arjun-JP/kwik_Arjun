import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class CategoryModel10Repo {
  final String baseUrl = "https://kwik-backend.vercel.app";

  Future<List<ProductModel>> getProductsBySubCategory(
      String subCategoryId) async {
    const String apiKey = 'arjun';
    const String apiSecret = 'digi9';
    final headers = {
      'api_Key': apiKey,
      'api_Secret': apiSecret,
    };

    final response = await http.get(
        Uri.parse('$baseUrl/product/subcategory/$subCategoryId'),
        headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> bodydata = json.decode(response.body);
      print(bodydata);
      if (bodydata.containsKey("data") && bodydata["data"] is List) {
        List<dynamic> data = bodydata["data"];
        print(1111);
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        return []; // Return an empty list if "data" is missing or not a list.
      }
    } else {
      throw Exception("Failed to load products");
    }
  }
}
