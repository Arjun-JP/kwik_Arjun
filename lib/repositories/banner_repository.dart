import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/banner_model.dart';

class BannerRepository {
  final String apiUrl = "https://kwik-backend.vercel.app/banner/allbanners";

  Future<List<BannerModel>> fetchBanners() async {
    const String apiKey = 'arjun';
    const String apiSecret = 'digi9';

    final headers = {
      'api_Key': apiKey,
      'api_Secret': apiSecret,
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
