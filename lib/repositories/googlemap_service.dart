// lib/core/services/google_maps_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kwik/models/googlemap_place_model.dart';

class GoogleMapsService {
  GoogleMapsService();

  Future<List<GoogleMapPlace>> searchPlaces(String query) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=(regions)&components=country:IN&key=AIzaSyAPLvvnotvyrbkQVynYChnZhyrgSWAjO1k');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if 'predictions' exists and is a List
      if (data['predictions'] != null && data['predictions'] is List) {
        // Parse each item in predictions to GoogleMapPlace
        return (data['predictions'] as List)
            .map((placeJson) => GoogleMapPlace.fromJson(placeJson))
            .toList();
      } else {
        throw Exception('Invalid response format: missing predictions array');
      }
    } else {
      throw Exception(
          'Failed to load places. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyAPLvvnotvyrbkQVynYChnZhyrgSWAjO1k',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['result'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
