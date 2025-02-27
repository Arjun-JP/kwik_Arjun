part of 'categories_page_model8_bloc.dart';

sealed class CategoriesPageModel8State extends Equatable {
  const CategoriesPageModel8State();
  
  @override
  List<Object> get props => [];
}

final class CategoriesPageModel8Initial extends CategoriesPageModel8State {}

class CategoryLoading extends CategoriesPageModel8State {}

class CategoryLoaded extends CategoriesPageModel8State {
  final Category category;
  final List<SubCategoryModel> subCategories;

  CategoryLoaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}

class CategoryError extends CategoriesPageModel8State {
  final String message;

  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoriesPageModel8State {} // State for cache cleared successfully

class CacheClearError extends CategoriesPageModel8State {
  final String message;

  CacheClearError(this.message);
}
