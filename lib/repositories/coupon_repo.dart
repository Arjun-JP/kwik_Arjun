import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/coupon_model.dart';

class CouponRepository {
  CouponRepository();
  final String baseUrl = dotenv.env['API_URL']!;
  final headers = {
    'Content-Type': 'application/json',
    'api_Key': dotenv.env['API_KEY']!,
    'api_Secret': dotenv.env['API_SECRET']!,
  };
  final user = FirebaseAuth.instance.currentUser;
  Future<List<CouponModel>> getAllCoupons() async {
    final response = await http
        .get(Uri.parse('$baseUrl/coupon/get/userCoupons/${user!.uid}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> couponList = data['data'];
      return couponList.map((e) => CouponModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load coupons');
    }
  }

  Future<Map<String, dynamic>> applycoupon({
    required String couponcode,
  }) async {
    final url = Uri.parse("$baseUrl/coupon/apply/validate");

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "user_id": user!.uid,
          "coupon_code": couponcode,
        }),
      );
      print(couponcode);
      print(user!.uid);
      print(response.statusCode);
      print(response.body);
      Map<String, dynamic> coupondata = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("object");
        return coupondata;
      } else {
        return coupondata;
      }
    } catch (e) {
      throw Exception("Error adding to cart");
    }
  }
}
