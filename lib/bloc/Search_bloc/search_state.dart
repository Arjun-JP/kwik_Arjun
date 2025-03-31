import 'package:equatable/equatable.dart';
import 'package:kwik/models/product_model.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductInitial extends SearchState {}

class ProductLoading extends SearchState {}

class ProductLoaded extends SearchState {
  final List<String> searchHistory;
  final List<ProductModel> products;
  ProductLoaded({required this.products, required this.searchHistory});
}

class ProductError extends SearchState {}
