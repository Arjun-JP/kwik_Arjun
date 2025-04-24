import 'package:kwik/models/product_model.dart';

class WishlistItem {
  final ProductModel productRef;
  final String variantId;
  final String id;

  WishlistItem({
    required this.productRef,
    required this.variantId,
    required this.id,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productRef: ProductModel.fromJson(json['product_ref']),
      variantId: json['variant_id'],
      id: json['_id'],
    );
  }
}
