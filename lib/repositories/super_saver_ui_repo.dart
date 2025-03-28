import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class SuperSaverRepository {
  static const String _baseUrl = 'https://kwik-backend.vercel.app';
  static const String _cacheKey = 'Super_saver_ui_cache';

  Future<Map<String, dynamic>> fetchUiData({bool forceRefresh = false}) async {
    const String apiKey = 'arjun';
    const String apiSecret = 'digi9';
    final headers = {
      'api_Key': apiKey,
      'api_Secret': apiSecret,
    };

    // Open Hive Box
    var box = await Hive.openBox('Supersaver_ui_cache_box');

    // Return cached data if it exists and no force refresh
    if (!forceRefresh && box.containsKey(_cacheKey)) {
      return json.decode(box.get(_cacheKey));
    }

    // Fetch from API
    final response = await http.get(Uri.parse('$_baseUrl/superSaver/getui'),
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
    var box = await Hive.openBox('Supersaver_ui_cache_box');
    await box.delete(_cacheKey);
  }
}
