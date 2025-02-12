import 'package:hive/hive.dart';

part 'brand_model.g.dart'; // The generated file from build_runner

@HiveType(typeId: 10) // Ensure this typeId is unique in your app
class Brand {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String brandName;

  @HiveField(2)
  final String brandImage;

  @HiveField(3)
  final String brandDescription;

  @HiveField(4)
  final String brandUrl;

  @HiveField(5)
  final String createdTime;

  Brand({
    required this.id,
    required this.brandName,
    required this.brandImage,
    required this.brandDescription,
    required this.brandUrl,
    required this.createdTime,
  });

  // Factory method to create a Brand from JSON
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['_id'] ?? '',
      brandName: json['brand_name'] ?? '',
      brandImage: json['brand_image'] ?? '',
      brandDescription: json['brand_des'] ?? '',
      brandUrl: json['brand_url'] ?? '',
      createdTime: json['created_time'] ?? '',
    );
  }

  // Method to convert Brand instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'brand_name': brandName,
      'brand_image': brandImage,
      'brand_des': brandDescription,
      'brand_url': brandUrl,
      'created_time': createdTime,
    };
  }

  // Empty method to return a Brand with default values
  static Brand empty() {
    return Brand(
      id: '',
      brandName: '',
      brandImage: '',
      brandDescription: '',
      brandUrl: '',
      createdTime: DateTime.now().toString(),
    );
  }
}
