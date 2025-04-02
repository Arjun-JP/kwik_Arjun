import 'package:hive/hive.dart';

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

  @HiveField(6)
  final String color;

  Brand({
    required this.id,
    required this.brandName,
    required this.brandImage,
    required this.brandDescription,
    required this.brandUrl,
    required this.createdTime,
    required this.color,
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
      color: json['color'] ?? '',
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
      'color': color,
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
      color: '',
    );
  }
}

class BrandAdapter extends TypeAdapter<Brand> {
  @override
  final int typeId = 10;

  @override
  Brand read(BinaryReader reader) {
    return Brand(
      id: reader.readString(),
      brandName: reader.readString(),
      brandImage: reader.readString(),
      brandDescription: reader.readString(),
      brandUrl: reader.readString(),
      createdTime: reader.readString(),
      color: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Brand obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.brandName);
    writer.writeString(obj.brandImage);
    writer.writeString(obj.brandDescription);
    writer.writeString(obj.brandUrl);
    writer.writeString(obj.createdTime);
    writer.writeString(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
