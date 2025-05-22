import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  String baseUrl = dotenv.env['API_URL']!;

  final headers = {
    'Content-Type': 'application/json',
    'api_Key': dotenv.env['API_KEY']!,
    'api_Secret': dotenv.env['API_SECRET']!,
  };

  Future<bool> addusertoMogoDB(
      {required String phone,
      required String uid,
      required String fcmToen}) async {
    final url = Uri.parse('$baseUrl/users/create');
    try {
      // Create the request body with the Address nested object
      final requestBody = {
        "phone": phone,
        "displayName": "User",
        "UID": uid,
        "isWarehouse": false,
        "is_deliveryboy": false,
        "isUser": true,
        "fcm_token": fcmToen
      };

      final response = await http.post(
        // Changed from post to put
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode != 201) {
        print("failed mogo user creation");
        return false;
      } else {
        return true;
      }
    } catch (e) {
      throw Exception("Error adding address: $e");
    }
  }

  Future<void> updateFcmToentoModoDB(
      {required String firebaseId, required String newFcmToken}) async {
    final url = Uri.parse('$baseUrl/users/updateFcmToken');
    try {
      // Create the request body with the Address nested object
      final requestBody = {
        "firebaseId": firebaseId,
        "newFcmToken": newFcmToken
      };

      final response = await http.put(
        // Changed from post to put
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode != 201) {
        print("faild to mogo user FCM updated ");
        throw Exception(
            'Failed to add User to Mogodb . Status code: ${response.statusCode}');
      } else {}
    } catch (e) {
      throw Exception("Error adding address: $e");
    }
  }
}
