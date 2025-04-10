import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kwik/models/product_model.dart';

class SubcategProductRepository {
  SubcategProductRepository();
  String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'Content-Type':
        'application/json', // Add this to specify the content type as JSON
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };
  Future<List<ProductModel>> fetchProductsBySubcategory(
      String subcategoryId) async {
    final url = Uri.parse('$baseUrl/product/subcategory/$subcategoryId');

    try {
      final response = await http.get(url, headers: headers);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> bodyData = json.decode(response.body);

        if (bodyData.containsKey("data") && bodyData["data"] is List) {
          final List<dynamic> data = bodyData["data"];

          try {
            final List<ProductModel> products =
                data.map((item) => ProductModel.fromJson(item)).toList();
            return products;
          } catch (e) {
            print("❌ Error parsing product data: $e");
            return [];
          }
        } else {
          print("⚠️ 'data' key not found or is not a list.");
          return [];
        }
      } else {
        throw Exception(
            "Failed to load products. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception while fetching products: $e");
      return [];
    }
  }
}
