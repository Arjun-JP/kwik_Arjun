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
    return ProductModel(
      id: json['_id'] ?? '',
      productName: json['product_name'] ?? '',
      productDescription: json['product_des'] ?? '',
      productImages: List<String>.from(json['product_image'] ?? []),
      brandId:
          json['Brand'] != null ? Brand.fromJson(json['Brand']) : Brand.empty(),
      categoryRef: json['category_ref'] != null
          ? Category.fromJson(json['category_ref'])
          : Category.empty(),
      subCategoryRef: json['sub_category_ref'] != null
          ? (json['sub_category_ref'] as List<dynamic>)
              .map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      variations: (json['variations'] as List<dynamic>?)
              ?.map((e) => VariationModel.fromJson(e))
              .toList() ??
          [],
      warehouseRefs: (json['warehouse_ref'] as List<dynamic>?)
              ?.map((e) => WarehouseModel.fromJson(e))
              .toList() ??
          [],
      sku: json['sku'] ?? '',
      productVideo: json['product_video'] ?? '',
      reviews: (json['review'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e))
              .toList() ??
          [],
      draft: json['draft'] ?? false,
      createdTime: json['created_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product_name': productName,
      'product_des': productDescription,
      'product_image': productImages,
      'Brand': brandId.toJson(),
      'category_ref': categoryRef.toJson(),
      'sub_category_ref': subCategoryRef
          .map((e) => e.toJson())
          .toList(), // Updated to handle list
      'variations': variations.map((e) => e.toJson()).toList(),
      'warehouse_ref': warehouseRefs.map((e) => e.toJson()).toList(),
      'sku': sku,
      'product_video': productVideo,
      'review': reviews.map((e) => e.toJson()).toList(),
      'draft': draft,
      'created_time': createdTime,
    };
  }
}
