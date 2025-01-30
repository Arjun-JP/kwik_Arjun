class BannerModel {
  final String id;
  final int bannerId;
  final String bannerImage;
  final CategoryRef categoryRef;
  final String? subCategoryRef;
  final int orderId;
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
        bannerId: json['banner_id'] ?? '',
        bannerImage: json['banner_image'] ?? '',
        categoryRef: CategoryRef.fromJson(json['category_ref']),
        subCategoryRef: json['sub_category_ref'],
        orderId: json['order_id'] ?? 0,
        createdTime: DateTime.parse(json['created_time']),
      );
    } catch (e) {
      print("Error parsing BannerModel: $e");
      throw Exception("Error parsing BannerModel");
    }
  }
}

class CategoryRef {
  final String id;
  final String categoryId;
  final String categoryName;
  final String categoryDescription;
  final String categoryImage;
  final DateTime createdTime;
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
      print("Error parsing CategoryRef: $e");
      throw Exception("Error parsing CategoryRef");
    }
  }
}
