import 'package:equatable/equatable.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/wishlist_model.dart';

abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartUpdated extends CartState {
  final bool message;
  final List<CartProduct> cartItems;
  final Map<String, dynamic> charges;
  final List<WishlistItem> wishlist;
  final double appliedcouponsmount;
  final String couponcode;
  CartUpdated({
    required this.wishlist,
    required this.message,
    required this.cartItems,
    required this.charges,
    required this.appliedcouponsmount,
    required this.couponcode,
  });

  CartUpdated copyWith({
    bool? message,
    List<CartProduct>? cartItems,
    Map<String, dynamic>? charges,
    List<WishlistItem>? wishlist,
  }) {
    return CartUpdated(
        wishlist: wishlist ?? this.wishlist,
        message: message ?? this.message,
        cartItems: cartItems ?? this.cartItems,
        charges: charges ?? this.charges,
        appliedcouponsmount: appliedcouponsmount ?? this.appliedcouponsmount,
        couponcode: couponcode ?? this.couponcode);
  }

  @override
  List<Object> get props => [
        message,
        cartItems,
        wishlist,
        charges
      ]; // Make sure to include charges here
}

class CartSynced extends CartState {
  final bool isSynced;
  final List<Map<String, dynamic>> cartItems;

  CartSynced({required this.isSynced, required this.cartItems});

  CartSynced copyWith({
    bool? isSynced,
    List<Map<String, dynamic>>? cartItems,
  }) {
    return CartSynced(
      isSynced: isSynced ?? this.isSynced,
      cartItems: cartItems ?? this.cartItems,
    );
  }

  @override
  List<Object> get props => [isSynced, cartItems];
}

class CartCleared extends CartState {
  final String message;

  CartCleared({required this.message});

  CartCleared copyWith({
    String? message,
  }) {
    return CartCleared(
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [message];
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});

  CartError copyWith({
    String? message,
  }) {
    return CartError(
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [message];
}
