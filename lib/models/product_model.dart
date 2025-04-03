import 'package:hive/hive.dart';
import 'package:kwik/models/brand_model.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/models/review_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/models/variation_model.dart';
import 'package:kwik/models/warehouse_model.dart';

part 'product_model.g.dart'; // Ensure the generated file is included

@HiveType(typeId: 2) // Ensure unique typeId
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final String productDescription;

  @HiveField(3)
  final List<String> productImages;

  @HiveField(4)
  final Brand brandId;

  @HiveField(5)
  final Category categoryRef;

  @HiveField(6)
  final List<SubCategoryModel> subCategoryRef;

  @HiveField(7)
  final List<VariationModel> variations;

  @HiveField(8)
  final List<WarehouseModel> warehouseRefs;

  @HiveField(9)
  final String sku;

  @HiveField(10)
  final String productVideo;

  @HiveField(11)
  final List<ReviewModel> reviews;

  @HiveField(12)
  final bool draft;

  @HiveField(13)
  final String createdTime;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productImages,
    required this.brandId,
    required this.categoryRef,
    required this.subCategoryRef,
    required this.variations,
    required this.warehouseRefs,
    required this.sku,
    required this.productVideo,
    required this.reviews,
    required this.draft,
    required this.createdTime,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    try {
      return ProductModel(
        id: json['_id'] ?? '',
        productName: json['product_name'] ?? '',
        productDescription: json['product_des'] ?? '',
        productImages: List<String>.from(json['product_image'] ?? []),
        brandId: _parseBrand(json['Brand']),
        categoryRef: _parseCategory(json['category_ref']),
        subCategoryRef: _parseSubCategories(json['sub_category_ref']),
        variations: _parseVariations(json['variations']),
        warehouseRefs: _parseWarehouses(json['warehouse_ref']),
        sku: json['sku'] ?? '',
        productVideo: json['product_video'] ?? '',
        reviews: _parseReviews(json['review']),
        draft: json['draft'] ?? false,
        createdTime: json['created_time'] ?? '',
      );
    } catch (e) {
      print('Error parsing ProductModel: $e');
      return ProductModel(
        id: '',
        productName: '',
        productDescription: '',
        productImages: [],
        brandId: Brand.empty(),
        categoryRef: Category.empty(),
        subCategoryRef: [],
        variations: [],
        warehouseRefs: [],
        sku: '',
        productVideo: '',
        reviews: [],
        draft: false,
        createdTime: '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        '_id': id,
        'product_name': productName,
        'product_des': productDescription,
        'product_image': productImages,
        'Brand': brandId.toJson(),
        'category_ref': categoryRef.toJson(),
        'sub_category_ref': subCategoryRef.map((e) => e.toJson()).toList(),
        'variations': variations.map((e) => e.toJson()).toList(),
        'warehouse_ref': warehouseRefs.map((e) => e.toJson()).toList(),
        'sku': sku,
        'product_video': productVideo,
        'review': reviews.map((e) => e.toJson()).toList(),
        'draft': draft,
        'created_time': createdTime,
      };
    } catch (e) {
      print('Error converting ProductModel to JSON: $e');
      return {};
    }
  }

  static Brand _parseBrand(dynamic brandJson) {
    try {
      return brandJson != null ? Brand.fromJson(brandJson) : Brand.empty();
    } catch (e) {
      print('Error parsing Brand: $e');
      return Brand.empty();
    }
  }

  static Category _parseCategory(dynamic categoryJson) {
    try {
      return categoryJson != null
          ? Category.fromJson(categoryJson)
          : Category.empty();
    } catch (e) {
      print('Error parsing Category: $e');
      return Category.empty();
    }
  }

  static List<SubCategoryModel> _parseSubCategories(dynamic subCategoryJson) {
    try {
      return subCategoryJson != null
          ? (subCategoryJson as List<dynamic>)
              .map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [];
    } catch (e) {
      print('Error parsing SubCategory: $e');
      return [];
    }
  }

  static List<VariationModel> _parseVariations(dynamic variationsJson) {
    try {
      return (variationsJson as List<dynamic>?)
              ?.map((e) => VariationModel.fromJson(e))
              .toList() ??
          [];
    } catch (e) {
      print('Error parsing Variations: $e');
      return [];
    }
  }

  static List<WarehouseModel> _parseWarehouses(dynamic warehousesJson) {
    try {
      return (warehousesJson as List<dynamic>?)
              ?.map((e) => WarehouseModel.fromJson(e))
              .toList() ??
          [];
    } catch (e) {
      print('Error parsing Warehouses: $e');
      return [];
    }
  }

  static List<ReviewModel> _parseReviews(dynamic reviewsJson) {
    try {
      return (reviewsJson as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e))
              .toList() ??
          [];
    } catch (e) {
      print('Error parsing Reviews: $e');
      return [];
    }
  }
}
