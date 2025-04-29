import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kwik/models/address_model.dart';
import 'package:kwik/models/warehouse_model.dart';

class AddressRepository {
  String baseUrl = "https://kwik-backend.vercel.app";

  final headers = {
    'Content-Type': 'application/json',
    'api_Key': 'arjun',
    'api_Secret': 'digi9',
  };

  Future<List<AddressModel>> getAddressesFromServer() async {
    final url = Uri.parse('$baseUrl/users/s5ZdLnYhnVfAramtr7knGduOI872');

    try {
      final response = await http.get(url, headers: headers);
      print(response.body);
      final Map<String, dynamic> body = json.decode(response.body);

      // Check if the response contains the user data and addresses
      if (body.containsKey("user") && body["user"] is Map) {
        final Map<String, dynamic> userData = body["user"];

        // Check if Address array exists in user data
        if (userData.containsKey("Address") && userData["Address"] is List) {
          List<dynamic> addressesJson = userData["Address"];
          print(addressesJson);
          // Parse each address JSON to AddressModel
          return addressesJson.map((addressJson) {
            return AddressModel.fromJson(addressJson);
          }).toList();
        }
      }

      // Return empty list if no addresses found
      return [];
    } catch (e) {
      throw Exception("Error fetching addresses: $e");
    }
  }

  Future<void> addAddress(AddressModel address, String userID) async {
    final url = Uri.parse('$baseUrl/users/addAddress/$userID');
    try {
      // Create the request body with the Address nested object
      final requestBody = {
        "Address": {
          "Location": {
            "lat": address.location.lat,
            "lang": address.location.lang,
          },
          "address_type": address.addressType,
          "flat_no_name": address.flatNoName,
          "floor": address.floor,
          "area": address.area,
          "landmark": address.landmark,
          "phone_no": address.phoneNo,
          "pincode": address.pincode,
        }
      };

      final response = await http.put(
        // Changed from post to put
        url,
        headers: headers,
        body: json.encode(requestBody),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to add address. Status code: ${response.statusCode}');
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

  Future<WarehouseModel> getwarehousedetails(
      String pincode, String destinationLat, String destinationLon) async {
    final url = Uri.parse('$baseUrl/warehouse/warehouseServiceStatus');
    print("api called inside api call repo");
    print(destinationLat);
    print(destinationLon);
    print(pincode);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          "pincode": pincode,
          "destinationLat": destinationLat,
          "destinationLon": destinationLon
        }),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Add comprehensive null checks
        if (responseData == null) {
          throw Exception('Error: Empty response data');
        }
        if (responseData['warehouse'] == null) {
          throw Exception('Error: Missing "warehouse" in response');
        }

        final warehouseData = responseData['warehouse'];
        print('Warehouse Data: $warehouseData'); // Debug print

        if (warehouseData['warehouse_location'] == null) {
          throw Exception(
              'Error: Missing "warehouse_location" in warehouse data');
        }

        return WarehouseModel.fromJson(warehouseData);
      } else {
        throw Exception(
            'Failed to get warehouse details: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error getting warehouse details: $e");
    }
  }
}
