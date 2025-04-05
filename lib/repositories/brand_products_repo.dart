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

      Map<String, dynamic> bodydata = json.decode(response.body);

      if (bodydata.containsKey("data") && bodydata["data"] is List) {
        List<dynamic> data = bodydata["data"];

        try {
          List<ProductModel> asd =
              data.map((json) => ProductModel.fromJson(json)).toList();
        } catch (e) {
          print("error in brand products $e");
        }
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error fetching brand products: $e');
    }
  }
}
