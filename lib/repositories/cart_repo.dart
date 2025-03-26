import 'dart:convert';
import 'package:http/http.dart' as http;

class CartRepository {
  final String baseUrl = "https://kwik-backend.vercel.app/users";

  final headers = {
    'Content-Type': 'application/json',
    "api_Key": "arjun",
    "api_Secret": "digi9",
  };

  Future<String> addToCart({
    required String userId,
    required String productRef,
    required String variant,
    required String pincode,
  }) async {
    final url = Uri.parse("$baseUrl/addtocart");

    final Map<String, dynamic> body = {
      "userId": userId,
      "product_ref": productRef,
      "variant": variant,
      "pincode": pincode,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        return "Product added to cart";
      } else {
        throw Exception("Failed to add product to cart: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error adding to cart");
    }
  }

  Future<String> increaseQuantity({
    required String userId,
    required String productRef,
    required String pincode,
    required String variantId,
  }) async {
    final url = Uri.parse("$baseUrl/increseqty");

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "userId": userId,
          "product_ref": productRef,
          "variant": variantId,
          "quantity": 1,
          "pincode": pincode,
        }),
      );

      if (response.statusCode == 201) {
        return "Quantity increased";
      } else {
        throw Exception("Failed to increase quantity: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error increasing quantity");
    }
  }

  Future<String> decreaseQuantity({
    required String userId,
    required String productRef,
    required String variantId,
    required String pincode,
  }) async {
    final url = Uri.parse("$baseUrl/decreseqty");

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "userId": userId,
          "product_ref": productRef,
          "variant": variantId,
          "quantity": 1,
          "pincode": pincode,
        }),
      );

      if (response.statusCode == 201) {
        return "Quantity decreased";
      } else {
        throw Exception("Failed to decrease quantity: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error decreasing quantity");
    }
  }

  /// 📌 **Fetch User's Cart**
  Future<dynamic> getUserCart({required String userId}) async {
    final url = Uri.parse("$baseUrl/getUserCart/$userId");

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // Return cart data as JSON
      } else {
        throw Exception("Failed to fetch cart: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error fetching cart");
    }
  }
}
