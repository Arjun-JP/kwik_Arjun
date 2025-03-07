import 'package:equatable/equatable.dart';

import '../../../models/product_model.dart';
import '../../../models/subcategory_model.dart';

abstract class CategoryModel15State extends Equatable {
  const CategoryModel15State();

  @override
  List<Object> get props => [];
}

class SubCategoriesInitial extends CategoryModel15State {}

class SubCategoriesLoading extends CategoryModel15State {}

class CategoryLoadedState extends CategoryModel15State {
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

class SubCategoriesError extends CategoryModel15State {
  final String message;

  const SubCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductsLoading extends CategoryModel15State {}

class ProductsLoaded extends CategoryModel15State {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsError extends CategoryModel15State {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheClearedCM15 extends CategoryModel15State {}

class CategoryErrorState extends CategoryModel15State {
  final String message;
  CategoryErrorState({required this.message});
}
