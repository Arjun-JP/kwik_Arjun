import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kwik/models/product_model.dart';

class BrandProductRepository {
  BrandProductRepository();
  String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'Content-Type':
        'application/json', // Add this to specify the content type as JSON
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };

  Future<List<ProductModel>> fetchProductsByBrand(String brandId) async {
    final url = Uri.parse('$baseUrl/product/get/productsByBrand/$brandId');

    try {
      final response = await http.get(url, headers: headers);
      print(response.statusCode);
      print("Response body: ${response.body}");

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData.containsKey('data') && jsonData['data'] is List) {
        print("inside");
        final List<dynamic> dataList = jsonData['data'];
        print("got data");

        print(dataList.map((json) => ProductModel.fromJson(json)).toList());

        return dataList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch brand products');
      }
    } catch (e) {
      throw Exception('Error fetching brand products: $e');
    }
  }
}
