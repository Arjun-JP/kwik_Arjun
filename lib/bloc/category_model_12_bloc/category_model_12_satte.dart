import 'package:equatable/equatable.dart';

import '../../models/product_model.dart';
import '../../models/subcategory_model.dart';

abstract class CategoryModel12State extends Equatable {
  const CategoryModel12State();

  @override
  List<Object> get props => [];
}

class SubCategoriesInitial extends CategoryModel12State {}

class SubCategoriesLoading extends CategoryModel12State {}

class CategoryLoadedState extends CategoryModel12State {
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

class SubCategoriesError extends CategoryModel12State {
  final String message;

  const SubCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductsLoading extends CategoryModel12State {}

class ProductsLoaded extends CategoryModel12State {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsError extends CategoryModel12State {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheClearedCM12 extends CategoryModel12State {}

class CategoryErrorState extends CategoryModel12State {
  final String message;
  CategoryErrorState({required this.message});
}
