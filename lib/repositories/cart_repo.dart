import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:kwik/models/wishlist_model.dart';
import 'package:kwik/widgets/custom_snackbar.dart';

class CartRepository {
  final String baseUrl = "https://kwik-backend.vercel.app/users";

  final headers = {
    'Content-Type': 'application/json',
    "api_Key": "arjun",
    "api_Secret": "digi9",
  };
  final user = FirebaseAuth.instance.currentUser;
  Future<bool> addToCart({
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
    print(body);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        return true;
      } else {
        print("safsssssssssss");
        CustomSnackBars.showLimitedQuantityWarning();
        return false;
      }
    } catch (e) {
      throw Exception("Error adding to cart");
    }
  }

  Future<void> addToCartfromwishlist({
    required String userId,
    required String wishlistitemid,
    required String pincode,
  }) async {
    final url = Uri.parse("$baseUrl/move/whislistToCart");

    final Map<String, dynamic> body = {
      "whishlist_itemId": wishlistitemid,
      "user_ref": userId,
      "pincode": pincode
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "api_Key": "arjun",
          "api_Secret": "digi9",
        },
        body: jsonEncode(body),
      );
      print(body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print("Product added to cart from wish list");
      } else {
        print("sudghfvauygrsfbvu");
        CustomSnackBars.showLimitedQuantityWarning();
        throw Exception("Failed to add product to cart: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error adding to cart");
    }
  }

  Future<void> removeProductfromwishlist({
    required String userId,
    required String wishlistitemid,
  }) async {
    final url = Uri.parse("$baseUrl/remove/whislist");

    final Map<String, dynamic> body = {
      "whishlist_itemId": wishlistitemid,
      "user_ref": userId,
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception("Failed to add product to cart: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error adding to cart");
    }
  }

  Future<bool> increaseQuantity({
    required String userId,
    required String productRef,
    required String pincode,
    required String variantId,
  }) async {
    print({
      "userId": userId,
      "product_ref": productRef,
      "variant": variantId,
      "quantity": 1,
      "pincode": pincode,
    });
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
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        // print(response.statusCode);
        return true;
      } else {
        print("1231234");
        CustomSnackBars.showLimitedQuantityWarning();
        return false;
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
          // print(Map<String, dynamic>.from(item));
          return Map<String, dynamic>.from(item);
        }).toList();

        return {
          "cartproducts": validatedList,
          "charges": charges,
          "wishlist": validatedwishList,
          "instock": true
        };
      } else {
        throw Exception("Failed to fetch cart: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching cart: $e");
    }
  }

  Future<Map<String, dynamic>> addtowishlist({
    required String userId,
    required String productRef,
    required String varient,
  }) async {
    final url = Uri.parse("$baseUrl/add/whislist");
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "userId": userId, // Changed from user!.uid to userId parameter
          "product_ref": productRef,
          "variant": varient
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // Check response status code
      if (response.statusCode != 200) {
        throw Exception("Failed to add to wishlist: ${response.statusCode}");
      }

      // Validate response structure
      if (!data.containsKey("cartProducts") ||
          !data.containsKey("charges") ||
          !data.containsKey("whishlist")) {
        throw Exception("Unexpected response format");
      }

      final cartProductList = data["cartProducts"];
      final wishlist = data["whishlist"];
      final charges = data["charges"];

      // Validate cart products
      if (cartProductList is! List) {
        throw Exception("'cartProducts' is not a List");
      }

      final validatedList = cartProductList.map((item) {
        if (item is! Map<String, dynamic>) {
          throw Exception("Unexpected item format in cartProducts");
        }
        return Map<String, dynamic>.from(item);
      }).toList();

      // Parse wishlist
      if (wishlist is! List) {
        throw Exception("'whishlist' is not a List");
      }

      final parsedWishlist = wishlist.map((wishlistItem) {
        if (wishlistItem is! Map<String, dynamic>) {
          throw Exception("Unexpected item format in wishlist");
        }
        return WishlistItem.fromJson(Map<String, dynamic>.from(wishlistItem));
      }).toList();

      return {
        "cartproducts": validatedList,
        "charges": charges,
        "wishlist": parsedWishlist
      };
    } catch (e) {
      throw Exception("Error adding to wishlist: $e");
    }
  }

  Future<Map<String, dynamic>> applycoupon({
    required String couponcode,
  }) async {
    final url = Uri.parse("$baseUrl/coupon/apply/validate");

    final Map<String, dynamic> body = {"user_id": user!.uid};
    print(body);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      print(response.statusCode);
      print(response.body);
      Map<String, dynamic> coupondata = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("apply Coupon done");
        return coupondata;
      } else {
        print("apply Coupon failed");
        CustomSnackBars.showLimitedQuantityWarning();
        return coupondata;
      }
    } catch (e) {
      throw Exception("Error adding to cart");
    }
  }
}
