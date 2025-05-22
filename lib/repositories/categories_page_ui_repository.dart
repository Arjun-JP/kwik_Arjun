import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class CategoriesPageUiRepository {
  static final String _baseUrl = dotenv.env['API_URL']!;
  static const String _cacheKey = 'cat_ui_cache';

  Future<Map<String, dynamic>> fetchUiData({bool forceRefresh = false}) async {
    final headers = {
      'api_Key': dotenv.env['API_KEY']!,
      'api_Secret': dotenv.env['API_SECRET']!,
    };

    // Open Hive Box
    var box = await Hive.openBox('cat_ui_cache_box');

    // Return cached data if it exists and no force refresh
    if (!forceRefresh && box.containsKey(_cacheKey)) {
      return json.decode(box.get(_cacheKey));
    }

    // Fetch from API
    final response = await http.get(Uri.parse('$_baseUrl/categoryui/getui'),
        headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Cache the data
      await box.put(_cacheKey, json.encode(data));

      return data;
    } else {
      throw Exception('Failed to load UI data');
    }
  }

  // Function to clear cache
  Future<void> clearCache() async {
    var box = await Hive.openBox('cat_ui_cache_box');
    await box.delete(_cacheKey);
  }
}
