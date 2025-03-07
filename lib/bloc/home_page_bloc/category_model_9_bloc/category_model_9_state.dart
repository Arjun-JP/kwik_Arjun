import 'package:equatable/equatable.dart';

import '../../../models/product_model.dart';
import '../../../models/subcategory_model.dart';

abstract class CategoryModel9State extends Equatable {
  const CategoryModel9State();

  @override
  List<Object> get props => [];
}

class SubCategoriesInitial extends CategoryModel9State {}

class SubCategoriesLoading extends CategoryModel9State {}

class CategoryLoadedState extends CategoryModel9State {
  final List<ProductModel> products;

  const CategoryLoadedState({
    required this.products,
  });

  @override
  List<Object> get props => [
        products,
      ];

  // Method to update selectedCategoryId without modifying data
  CategoryLoadedState copyWith() {
    return CategoryLoadedState(
      products: products,
    );
  }
}

class SubCategoriesError extends CategoryModel9State {
  final String message;

  const SubCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductsLoading extends CategoryModel9State {}

class ProductsLoaded extends CategoryModel9State {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsError extends CategoryModel9State {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared extends CategoryModel9State {}

class CategoryErrorState extends CategoryModel9State {
  final String message;
  CategoryErrorState({required this.message});
}
