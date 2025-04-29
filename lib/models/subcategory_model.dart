import 'package:hive/hive.dart';
import 'category_model.dart'; // Import CategoryModel

part 'subcategory_model.g.dart';

@HiveType(typeId: 55) // Unique typeId for the SubCategoryModel
class SubCategoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final DateTime createdTime;

  @HiveField(5)
  final Category categoryRef; // Category reference as an object

  @HiveField(6)
  final bool isDeleted;

  @HiveField(7) // New field added here
  final String offerPercentage;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdTime,
    required this.categoryRef,
    required this.isDeleted,
    required this.offerPercentage, // Added to constructor
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['sub_category_name'] ?? '',
      description: json['sub_category_des'] ?? '',
      imageUrl: json['sub_category_image'] ?? '',
      createdTime:
          DateTime.tryParse(json['sub_created_time'] ?? '') ?? DateTime.now(),
      categoryRef: json['category_ref'] != null
          ? Category.fromJson(json['category_ref'])
          : Category.empty(),
      isDeleted: json['isDeleted'] ?? false,
      offerPercentage: json['offer_percentage']?.toString() ??
          '0', // Handle null and convert to string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sub_category_name': name,
      'sub_category_des': description,
      'sub_category_image': imageUrl,
      'sub_created_time': createdTime.toIso8601String(),
      'category_ref': categoryRef.toJson(),
      'isDeleted': isDeleted,
      'offer_percentage': offerPercentage, // Added to JSON serialization
    };
  }

  static SubCategoryModel empty() {
    return SubCategoryModel(
      id: '',
      name: '',
      description: '',
      imageUrl: '',
      createdTime: DateTime.now(),
      categoryRef: Category.empty(),
      isDeleted: false,
      offerPercentage: '0', // Default value for empty
    );
  }
}
