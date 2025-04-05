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
      String query, String userId) async {
    final response = await http.get(
        Uri.parse("$baseUrl/product/search/product/user/$userId?query=$query"),
        headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      print(response.body);
      // Ensure 'allProducts' key exists before parsing
      if (decodedData.containsKey('data')) {
        List<dynamic> data = decodedData['data'];
        print(data);
        // List<dynamic> searchHistory = decodedData['searchHistory'];

        return {
          "products": data.map((json) => ProductModel.fromJson(json)).toList(),
          "searchHistory": []
        };
      } else {
        throw Exception("Key 'allProducts' not found in response");
      }
    } else {
      throw Exception("Failed to load initial products");
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
