part of 'categories_page_model5_bloc.dart';

sealed class CategoriesPageModel5State extends Equatable {
  const CategoriesPageModel5State();
  
  @override
  List<Object> get props => [];
}

final class CategoriesPageModel5Initial extends CategoriesPageModel5State {}
class SubCategoriesLoading extends CategoriesPageModel5State {}

class CategoryLoadedState extends CategoriesPageModel5State {
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

class SubCategoriesError extends CategoriesPageModel5State {
  final String message;

  const SubCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductsLoading extends CategoriesPageModel5State {}

class ProductsLoaded extends CategoriesPageModel5State {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsError extends CategoriesPageModel5State {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared extends CategoriesPageModel5State {}

class CategoryErrorState extends CategoriesPageModel5State {
  final String message;
  const CategoryErrorState({required this.message});
}
