import 'package:kwik/models/order_model.dart';

class AddressModel {
  final Location location;
  final String addressType;
  final String flatNoName;
  final String? floor;
  final String area;
  final String? landmark;
  final String phoneNo;
  final String pincode;

  AddressModel({
    required this.location,
    required this.addressType,
    required this.flatNoName,
    this.floor,
    required this.area,
    this.landmark,
    required this.phoneNo,
    required this.pincode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      location: Location.fromJson(json['Location']),
      addressType: json['address_type'] ?? '',
      flatNoName: json['flat_no_name'] ?? '',
      floor: json['floor'],
      area: json['area'] ?? '',
      landmark: json['landmark'],
      phoneNo: json['phone_no'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Location': location.toJson(),
      'address_type': addressType,
      'flat_no_name': flatNoName,
      'floor': floor,
      'area': area,
      'landmark': landmark,
      'phone_no': phoneNo,
      'pincode': pincode,
    };
  }
}
