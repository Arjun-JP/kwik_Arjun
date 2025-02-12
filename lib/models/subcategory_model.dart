import 'package:hive/hive.dart';
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
  final String createdTime;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdTime,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['sub_category_name'] ?? '',
      description: json['sub_category_des'] ?? '',
      imageUrl: json['sub_category_image'] ?? '',
      createdTime: json['sub_created_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sub_category_name': name,
      'sub_category_des': description,
      'sub_category_image': imageUrl,
      'sub_created_time': createdTime,
    };
  }

  static SubCategoryModel empty() {
    return SubCategoryModel(
      id: '',
      name: '',
      description: '',
      imageUrl: '',
      createdTime: '',
    );
  }
}
