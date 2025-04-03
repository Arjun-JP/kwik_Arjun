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

      Map<String, dynamic> bodydata = json.decode(response.body);
      print("1111");
      if (bodydata.containsKey("data") && bodydata["data"] is List) {
        print("2222");
        List<dynamic> data = bodydata["data"];
        print("33333");
        try {
          print(data.first);
          List<ProductModel> asd =
              data.map((json) => ProductModel.fromJson(json)).toList();
        } catch (e) {
          print(e);
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
