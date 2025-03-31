import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kwik/models/product_model.dart';

class SearchRepo {
  final String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'api_Key': "arjun",
    'api_Secret': "digi9",
  };
  Future<Map<String, dynamic>> searchProducts(
      String query, String userId, int page, int size) async {
    final response = await http.get(
        Uri.parse(
            "$baseUrl/search/product?q=a&userId=67821e97640fb7573f33cba5&page=1&size=20"),
        headers: headers);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['allProducts'];
      List<Map<String, dynamic>> searchHistory =
          jsonDecode(response.body)['searchHistory'];
      return {
        "products": data.map((json) => ProductModel.fromJson(json)).toList(),
        "searchHistory": searchHistory.map((e) => e["query"]).toList()
      };
    } else {
      throw Exception("Failed to load products");
    }
  }

  Future<Map<String, dynamic>> getInitialProducts() async {
    final response = await http.get(
      Uri.parse(
          "$baseUrl/product/get/recommendedProductsByUserOrder/s5ZdLnYhnVfAramtr7knGduOI872"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      // Ensure 'allProducts' key exists before parsing
      if (decodedData.containsKey('allProducts')) {
        List<dynamic> data = decodedData['allProducts'];

        List<dynamic> searchHistory = decodedData['searchHistory'];
        print(searchHistory);
        print("repo");
        return {
          "products": data.map((json) => ProductModel.fromJson(json)).toList(),
          "searchHistory": searchHistory.map((e) => e["query"]).toList()
        };
      } else {
        throw Exception("Key 'allProducts' not found in response");
      }
    } else {
      throw Exception("Failed to load initial products");
    }
  }
}
