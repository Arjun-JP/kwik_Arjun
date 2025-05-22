import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kwik/models/product_model.dart';

class BrandProductRepository {
  BrandProductRepository();
  String baseUrl = dotenv.env['API_URL']!;

  final headers = {
    'Content-Type':
        'application/json', // Add this to specify the content type as JSON
     'api_Key': dotenv.env['API_KEY']!,
    'api_Secret': dotenv.env['API_SECRET']!,
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
