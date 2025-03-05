part of 'cart_similar_products_bloc.dart';

sealed class CartSimilarProductsState extends Equatable {
  const CartSimilarProductsState();
  
  @override
  List<Object> get props => [];
}

final class CartSimilarProductsInitial extends CartSimilarProductsState {}
class CartSimilarProductsLoading extends CartSimilarProductsState {}

class CartSimilarProductsLoaded extends CartSimilarProductsState {
  final List<ProductModel> products;

  CartSimilarProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class CartSimilarProductsError extends CartSimilarProductsState {
  final String message;

  CartSimilarProductsError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CartSimilarProductsState {} // State for cache cleared successfully

class CacheClearError extends CartSimilarProductsState {
  final String message;

  CacheClearError(this.message);
}
