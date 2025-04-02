import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kwik/widgets/shimmer/product_model1_list.dart';

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
    print("Api called");
    final url = Uri.parse("$baseUrl/addtocart");

    final Map<String, dynamic> body = {
      "userId": userId,
      "product_ref": productRef,
      "variant": variant,
      "pincode": pincode,
    };
    print("Api called$body");
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        return "Product added to cart";
      } else {
        throw Exception("Failed to add product to cart: ${response.body}");
      }
    } catch (e) {
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
      throw Exception("Error decreasing quantity");
    }
  }

  /// 📌 **Fetch User's Cart**
  Future<List<Map<String, dynamic>>> getUserCart(
      {required String userId}) async {
    final url = Uri.parse("$baseUrl/getUserCart/$userId");
    try {
      print("Fetching cart for user: $userId");
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is! Map || !data.containsKey("cartProducts")) {
          throw Exception(
              "Unexpected response format: Missing 'cartProducts' key");
        }

        final cartproductlist = data["cartProducts"];

        if (cartproductlist is List) {
          // Ensure each item is a Map<String, dynamic>
          return cartproductlist
              .whereType<Map<String, dynamic>>() // ✅ Filter valid items
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        } else {
          throw Exception(
              "Unexpected response format: 'cartProducts' is not a List");
        }
      } else {
        throw Exception("Failed to fetch cart: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching cart: $e");
    }
  }
}
