import 'package:equatable/equatable.dart';
import 'package:kwik/models/product_model.dart';

abstract class RecommendedProductsState extends Equatable {
  const RecommendedProductsState();

  @override
  List<Object> get props => [];
}

class RecommendedProductInitial extends RecommendedProductsState {}

class RecommendedProductLoading extends RecommendedProductsState {}

class RecommendedProductLoaded extends RecommendedProductsState {
  final List<ProductModel> products;

  const RecommendedProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class RecommendedProductError extends RecommendedProductsState {
  final String message;

  const RecommendedProductError({required this.message});

  @override
  List<Object> get props => [message];
}
