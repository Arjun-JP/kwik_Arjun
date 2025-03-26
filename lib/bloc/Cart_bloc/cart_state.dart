import 'package:equatable/equatable.dart';
import 'package:kwik/models/cart_model.dart';

abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartUpdated extends CartState {
  final String message;
  final List<CartProduct> cartItems;

  CartUpdated({required this.message, required this.cartItems});

  @override
  List<Object> get props => [message, cartItems];
}

class CartSynced extends CartState {
  final bool isSynced;
  final List<Map<String, dynamic>> cartItems;

  CartSynced({required this.isSynced, required this.cartItems});

  @override
  List<Object> get props => [isSynced, cartItems];
}

class CartCleared extends CartState {
  final String message;

  CartCleared({required this.message});

  @override
  List<Object> get props => [message];
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});

  @override
  List<Object> get props => [message];
}
