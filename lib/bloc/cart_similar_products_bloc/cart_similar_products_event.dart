part of 'cart_similar_products_bloc.dart';

sealed class CartSimilarProductsEvent extends Equatable {
  const CartSimilarProductsEvent();

  @override
  List<Object> get props => [];
}
class FetchSubCategoryProducts extends CartSimilarProductsEvent {
  final String subCategoryId;

  FetchSubCategoryProducts({required this.subCategoryId});

  @override
  List<Object> get props => [subCategoryId];
}

class Clearsubcatproduct7Cache extends CartSimilarProductsEvent {}