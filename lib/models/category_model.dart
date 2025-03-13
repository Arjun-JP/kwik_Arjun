import 'package:hive/hive.dart';
part 'category_model.g.dart'; // The generated file from build_runner

@HiveType(typeId: 11) // Unique typeId for Category model
class Category {
  @HiveField(0)
  final String catref;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final String color;

  @HiveField(6)
  final bool? visibility; // Optional field

  @HiveField(7)
  final String? createdTime; // Optional field

  @HiveField(8)
  final String bannerImage; // New field for banner image

  @HiveField(9)
  final bool isDeleted; // New field for deletion status

  @HiveField(10)
  final List<dynamic>? selectedSubCategoryRef;

  @HiveField(11)
  final bool? islandingPage;

  Category({
    required this.catref,
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.color,
    required this.bannerImage,
    required this.isDeleted,
    this.selectedSubCategoryRef,
    this.islandingPage,
    this.visibility,
    this.createdTime,
  });

  // Factory method to create a category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      catref: json['_id'] ?? "", // Handle null value
      id: json['category_id'] ?? "1", // Default value for category_id
      name: json['category_name'] ?? "name", // Default value for name
      description:
          json['category_des'] ?? "des", // Default value for description
      imageUrl: json['category_image'] ?? "image", // Default value for imageUrl
      color: json['color'] ?? "FFFFFF", // Default value for color
      visibility: json['visibility'] ?? true, // Handle null visibility
      createdTime: json['created_time'] ??
          DateTime.now().toString(), // Handle null createdTime
      bannerImage:
          json['category_banner_image'] ?? "", // Handle null banner image
      isDeleted: json['isDeleted'] ?? false,
      selectedSubCategoryRef: json["selected_sub_category_ref"] ?? [],
      islandingPage: json["is_landingPage"] ?? false, // Handle null isDeleted
    );
  }

  // Convert Category object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': catref,
      'category_id': id,
      'category_name': name,
      'category_des': description,
      'category_image': imageUrl,
      'color': color,
      'visibility': visibility,
      'created_time': createdTime,
      'banner_image': bannerImage,
      'is_deleted': isDeleted,
      'selected_sub_category_ref': selectedSubCategoryRef
    };
  }

  // Empty method to return a Category with default values
  static Category empty() {
    return Category(
      catref: '',
      id: '',
      name: '',
      description: '',
      imageUrl: '',
      color: 'FFFFFF',
      bannerImage: '',
      isDeleted: false,
      visibility: true,
      selectedSubCategoryRef: [],
      createdTime: DateTime.now().toString(),
    );
  }
}
