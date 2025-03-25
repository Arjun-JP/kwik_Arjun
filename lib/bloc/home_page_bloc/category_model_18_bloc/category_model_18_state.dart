import 'package:equatable/equatable.dart';

import '../../../models/product_model.dart';
import '../../../models/subcategory_model.dart';

abstract class CategoryModel18State extends Equatable {
  const CategoryModel18State();

  @override
  List<Object> get props => [];
}

class SubCategoriesInitial extends CategoryModel18State {}

class SubCategoriesLoading extends CategoryModel18State {}

class CategoryLoadedState extends CategoryModel18State {
  final List<SubCategoryModel> subCategories;
  final List<ProductModel> products;
  final String selectedCategoryId;

  const CategoryLoadedState({
    required this.subCategories,
    required this.products,
    required this.selectedCategoryId,
  });

  @override
  List<Object> get props => [subCategories, products, selectedCategoryId];

  // Method to update selectedCategoryId without modifying data
  CategoryLoadedState copyWith({String? selectedCategoryId}) {
    return CategoryLoadedState(
      subCategories: subCategories,
      products: products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class SubCategoriesError extends CategoryModel18State {
  final String message;

  const SubCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductsLoading extends CategoryModel18State {}

class ProductsLoaded extends CategoryModel18State {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsError extends CategoryModel18State {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared extends CategoryModel18State {}

class CategoryErrorState extends CategoryModel18State {
  final String message;
  const CategoryErrorState({required this.message});
}
