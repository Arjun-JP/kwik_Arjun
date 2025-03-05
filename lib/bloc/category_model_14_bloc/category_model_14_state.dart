import 'package:equatable/equatable.dart';

import '../../models/product_model.dart';
import '../../models/subcategory_model.dart';

abstract class CategoryModel14State extends Equatable {
  const CategoryModel14State();

  @override
  List<Object> get props => [];
}

class SubCategoriesInitial extends CategoryModel14State {}

class SubCategoriesLoading extends CategoryModel14State {}

class CategoryLoadedState extends CategoryModel14State {
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

class SubCategoriesError extends CategoryModel14State {
  final String message;

  const SubCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductsLoading extends CategoryModel14State {}

class ProductsLoaded extends CategoryModel14State {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsError extends CategoryModel14State {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheClearedCM14 extends CategoryModel14State {}

class CategoryErrorState extends CategoryModel14State {
  final String message;
  const CategoryErrorState({required this.message});
}
