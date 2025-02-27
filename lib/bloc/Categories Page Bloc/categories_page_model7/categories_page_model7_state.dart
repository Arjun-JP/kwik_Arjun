part of 'categories_page_model7_bloc.dart';

sealed class CategoriesPageModel7State extends Equatable {
  const CategoriesPageModel7State();
  
  @override
  List<Object> get props => [];
}

final class CategoriesPageModel7Initial extends CategoriesPageModel7State {}
class CategoriesPageModel7Loading extends CategoriesPageModel7State {}

class CategoriesPageModel7Loaded extends CategoriesPageModel7State {
  final List<ProductModel> products;

  CategoriesPageModel7Loaded(this.products);

  @override
  List<Object> get props => [products];
}

class CategoriesPageModel7Error extends CategoriesPageModel7State {
  final String message;

  CategoriesPageModel7Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoriesPageModel7State {} // State for cache cleared successfully

class CacheClearError extends CategoriesPageModel7State {
  final String message;

  CacheClearError(this.message);
}
