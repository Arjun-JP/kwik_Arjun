import 'package:hive/hive.dart';

part 'banner_model.g.dart'; // This will be generated automatically by Hive

// BannerModel class with Hive annotations
@HiveType(typeId: 0)
class BannerModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int bannerId;

  @HiveField(2)
  final String bannerImage;

  @HiveField(3)
  final CategoryRef categoryRef;

  @HiveField(4)
  final String? subCategoryRef;

  @HiveField(5)
  final int orderId;

  @HiveField(6)
  final DateTime createdTime;

  BannerModel({
    required this.id,
    required this.bannerId,
    required this.bannerImage,
    required this.categoryRef,
    this.subCategoryRef,
    required this.orderId,
    required this.createdTime,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    try {
      return BannerModel(
        id: json['_id'] ?? '',
        bannerId: json['banner_id'] ?? 0,
        bannerImage: json['banner_image'] ?? '',
        categoryRef: CategoryRef.fromJson(json['category_ref']),
        subCategoryRef: json['sub_category_ref'],
        orderId: json['order_id'] ?? 0,
        createdTime: DateTime.parse(json['created_time']),
      );
    } catch (e) {
      throw Exception("Error parsing BannerModel");
    }
  }
}

// CategoryRef class with Hive annotations
@HiveType(typeId: 1)
class CategoryRef {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final String categoryName;

  @HiveField(3)
  final String categoryDescription;

  @HiveField(4)
  final String categoryImage;

  @HiveField(5)
  final DateTime createdTime;

  @HiveField(6)
  final String color;

  CategoryRef({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImage,
    required this.createdTime,
    required this.color,
  });

  factory CategoryRef.fromJson(Map<String, dynamic> json) {
    try {
      return CategoryRef(
        id: json['_id'] ?? '',
        categoryId: json['category_id'] ?? '',
        categoryName: json['category_name'] ?? '',
        categoryDescription: json['category_des'] ?? '',
        categoryImage: json['category_image'] ?? '',
        createdTime: DateTime.parse(json['created_time']),
        color: json['color'] ?? '',
      );
    } catch (e) {
      throw Exception("Error parsing CategoryRef");
    }
  }
}
