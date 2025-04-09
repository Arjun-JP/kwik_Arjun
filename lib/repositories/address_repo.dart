import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kwik/models/address_model.dart';

class AddressRepository {
  String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'Content-Type': 'application/json',
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };

  Future<List<AddressModel>> getAddressesFromServer() async {
    final url = Uri.parse('$baseUrl/address/get');

    try {
      final response = await http.get(url, headers: headers);
      Map<String, dynamic> body = json.decode(response.body);

      if (body.containsKey("data") && body["data"] is List) {
        List<dynamic> data = body["data"];
        return data.map((json) => AddressModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Error fetching addresses: $e");
    }
  }

  Future<void> addAddress(AddressModel address, userID) async {
    final url = Uri.parse('$baseUrl/users/addAddress/$userID');
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(address.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add address');
      }
    } catch (e) {
      throw Exception("Error adding address: $e");
    }
  }

  Future<void> editAddress(AddressModel address) async {
    final url = Uri.parse('$baseUrl/address/edit');
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(address.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to edit address');
      }
    } catch (e) {
      throw Exception("Error editing address: $e");
    }
  }

  Future<void> deleteAddress(String addressId) async {
    final url = Uri.parse('$baseUrl/address/delete/$addressId');
    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to delete address');
      }
    } catch (e) {
      throw Exception("Error deleting address: $e");
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    final url = Uri.parse('$baseUrl/address/setDefault');
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({"addressId": addressId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to set default address');
      }
    } catch (e) {
      throw Exception("Error setting default address: $e");
    }
  }

  Future<String> getWarehouseRef(String pincode) async {
    final url = Uri.parse('$baseUrl/warehouse/get/warehouseStatus/$pincode');

    try {
      final response = await http.get(url, headers: headers);
      Map<String, dynamic> body = json.decode(response.body);

      if (body.containsKey("warehouseRef")) {
        return body["warehouseRef"];
      } else {
        throw Exception('No warehouse found for this pincode');
      }
    } catch (e) {
      throw Exception('Error fetching warehouse reference: $e');
    }
  }
}
