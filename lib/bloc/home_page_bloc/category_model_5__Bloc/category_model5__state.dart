import 'package:equatable/equatable.dart';

import '../../../models/product_model.dart';
import '../../../models/subcategory_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class SubCategoriesInitial extends CategoryState {}

class SubCategoriesLoading extends CategoryState {}

class CategoryLoadedState extends CategoryState {
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

class SubCategoriesError extends CategoryState {
  final String message;

  const SubCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductsLoading extends CategoryState {}

class ProductsLoaded extends CategoryState {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsError extends CategoryState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared extends CategoryState {}

class CategoryErrorState extends CategoryState {
  final String message;
  const CategoryErrorState({required this.message});
}
