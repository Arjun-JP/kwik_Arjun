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
      print(response.statusCode);
      print(response.body);
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
  Future<Map<String, dynamic>> getUserCart({required String userId}) async {
    final url = Uri.parse("$baseUrl/getUserCart/$userId");
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Check if the response has the expected structure
        if (!data.containsKey("cartProducts")) {
          throw Exception(
              "Unexpected response format: Missing 'cartProducts' key");
        }

        if (!data.containsKey("charges")) {
          throw Exception("Unexpected response format: Missing 'charges' key");
        }
        if (!data.containsKey("whishlist")) {
          throw Exception(
              "Unexpected response format: Missing 'whishlist' key");
        }

        final cartProductList = data["cartProducts"];
        final charges = data["charges"];
        final wishlist = data["whishlist"];

        // print("charges while syncing cart $charges");
        if (cartProductList is! List) {
          throw Exception(
              "Unexpected response format: 'cartProducts' is not a List");
        }
        // print("charges while syncing cart $charges");
        if (wishlist is! List) {
          throw Exception(
              "Unexpected response format: 'wishlist' is not a List");
        }

        // Validate and convert each item in the list
        final validatedList = cartProductList.map((item) {
          if (item is! Map<String, dynamic>) {
            throw Exception("Unexpected item format in cartProducts");
          }
          return Map<String, dynamic>.from(item);
        }).toList();
        // Validate and convert each item in the list
        final validatedwishList = wishlist.map((item) {
          if (item is! Map<String, dynamic>) {
            throw Exception("Unexpected item format in wishlist");
          }
          print(Map<String, dynamic>.from(item));
          return Map<String, dynamic>.from(item);
        }).toList();

        return {
          "cartproducts": validatedList,
          "charges": charges,
          "wishlist": validatedwishList
        };
      } else {
        throw Exception("Failed to fetch cart: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching cart: $e");
    }
  }

  /// 📌 **Fetch User's Cart**
  Future<Map<String, dynamic>> addtowishlist(
      {required String userId,
      required String productRef,
      required String varient}) async {
    final url = Uri.parse("$baseUrl/users/add/whislist");
    try {
      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "userId": "s5ZdLnYhnVfAramtr7knGduOI872",
            "product_ref": productRef,
            "variant": varient
          }));
      print("add to wish list api called");
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Check if the response has the expected structure
        if (!data.containsKey("cartProducts")) {
          throw Exception(
              "Unexpected response format: Missing 'cartProducts' key");
        }

        if (!data.containsKey("charges")) {
          throw Exception("Unexpected response format: Missing 'charges' key");
        }

        final cartProductList = data["cartProducts"];
        final wishlist = data["whishlist"];
        final charges = data["charges"];
        // print("charges while syncing cart $charges");
        if (cartProductList is! List) {
          throw Exception(
              "Unexpected response format: 'cartProducts' is not a List");
        }

        // Validate and convert each item in the list
        final validatedList = cartProductList.map((item) {
          if (item is! Map<String, dynamic>) {
            throw Exception("Unexpected item format in cartProducts");
          }
          return Map<String, dynamic>.from(item);
        }).toList();

        return {
          "cartproducts": validatedList,
          "charges": charges,
          "wishlist": wishlist
        };
      } else {
        throw Exception("Failed to fetch cart: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching cart: $e");
    }
  }
}
