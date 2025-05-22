import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/banner_model.dart';

class BannerRepository {
  final String apiUrl = "${dotenv.env['API_URL']!}/banner/allbanners";

  Future<List<BannerModel>> fetchBanners() async {
    final headers = {
      'api_Key': dotenv.env['API_KEY']!,
      'api_Secret': dotenv.env['API_SECRET']!,
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      // Check for successful response
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);

        // Map the JSON response to BannerModel instances
        List<BannerModel> banners = [];

        // Iterate over the body and check for each item
        for (var item in body) {
          try {
            banners.add(BannerModel.fromJson(item));
          } catch (e) {}
        }

        // If no banners were added, throw an error
        if (banners.isEmpty) {
          throw Exception("No banners were parsed successfully");
        }

        return banners;
      } else {
        throw Exception("Failed to load banners: ${response.statusCode}");
      }
    } catch (e) {
      rethrow; // Re-throw the error for further handling
    }
  }
}
