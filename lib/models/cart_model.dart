import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/variation_model.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 39)
class CartProduct {
  @HiveField(0)
  final String productRef;

  @HiveField(1)
  final VariationModel variant;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final String pincode;

  @HiveField(4)
  final double sellingPrice;

  @HiveField(5)
  final double mrp;

  @HiveField(6)
  final double buyingPrice;

  @HiveField(7)
  final bool inStock;

  @HiveField(8)
  final bool variationVisibility;

  @HiveField(9)
  final double finalPrice;

  @HiveField(10)
  final DateTime cartAddedDate;

  CartProduct({
    required this.productRef,
    required this.variant,
    required this.quantity,
    required this.pincode,
    required this.sellingPrice,
    required this.mrp,
    required this.buyingPrice,
    required this.inStock,
    required this.variationVisibility,
    required this.finalPrice,
    required this.cartAddedDate,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      productRef: json['product_ref'],
      variant: VariationModel.fromJson(json['variant']),
      quantity: json['quantity'],
      pincode: json['pincode'],
      sellingPrice: json['selling_price'].toDouble(),
      mrp: json['mrp'].toDouble(),
      buyingPrice: json['buying_price'].toDouble(),
      inStock: json['inStock'],
      variationVisibility: json['variation_visibility'],
      finalPrice: json['final_price'].toDouble(),
      cartAddedDate: DateTime.parse(json['cart_added_date']),
    );
  }

  CartProduct copyWith({
    String? productRef,
    VariationModel? variant,
    int? quantity,
    String? pincode,
    double? sellingPrice,
    double? mrp,
    double? buyingPrice,
    bool? inStock,
    bool? variationVisibility,
    double? finalPrice,
    DateTime? cartAddedDate,
  }) {
    return CartProduct(
      productRef: productRef ?? this.productRef,
      variant: variant ?? this.variant,
      quantity: quantity ?? this.quantity,
      pincode: pincode ?? this.pincode,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      mrp: mrp ?? this.mrp,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      inStock: inStock ?? this.inStock,
      variationVisibility: variationVisibility ?? this.variationVisibility,
      finalPrice: finalPrice ?? this.finalPrice,
      cartAddedDate: cartAddedDate ?? this.cartAddedDate,
    );
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'product_ref': productRef,
        'variant': variant.toJson(),
        'quantity': quantity,
        'pincode': pincode,
        'selling_price': sellingPrice,
        'mrp': mrp,
        'buying_price': buyingPrice,
        'inStock': inStock,
        'variation_visibility': variationVisibility,
        'final_price': finalPrice,
        'cart_added_date': cartAddedDate.toIso8601String(),
      };
    } catch (e) {
      return {}; // or handle the error appropriately
    }
  }
}
