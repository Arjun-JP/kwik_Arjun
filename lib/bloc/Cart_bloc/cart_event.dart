import 'package:equatable/equatable.dart';
import 'package:kwik/models/cart_model.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final String userId;
  final String productRef;
  final String variantId;
  final String pincode;
  final CartProduct cartProduct;

  AddToCart({
    required this.cartProduct,
    required this.userId,
    required this.productRef,
    required this.variantId,
    required this.pincode,
  });

  @override
  List<Object> get props =>
      [userId, productRef, variantId, pincode, cartProduct];
}

class IncreaseCartQuantity extends CartEvent {
  final String userId;
  final String productRef;
  final String variantId;
  final String pincode;

  IncreaseCartQuantity({
    required this.userId,
    required this.productRef,
    required this.variantId,
    required this.pincode,
  });

  @override
  List<Object> get props => [userId, productRef, variantId, pincode];
}

class DecreaseCartQuantity extends CartEvent {
  final String userId;
  final String productRef;
  final String variantId;
  final String pincode;

  DecreaseCartQuantity({
    required this.userId,
    required this.productRef,
    required this.variantId,
    required this.pincode,
  });

  @override
  List<Object> get props => [userId, productRef, variantId, pincode];
}

class SyncCartWithServer extends CartEvent {
  final String userId;

  SyncCartWithServer({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ClearCartCache extends CartEvent {
  ClearCartCache();
}
