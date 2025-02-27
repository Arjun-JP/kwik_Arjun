part of 'categories_page_model9_bloc.dart';

sealed class CategoriesPageModel9State extends Equatable {
  const CategoriesPageModel9State();
  
  @override
  List<Object> get props => [];
}

final class CategoriesPageModel9Initial extends CategoriesPageModel9State {}
class CategoriesPageModel9Loading extends CategoriesPageModel9State {}

class CategoriesPageModel9Loaded extends CategoriesPageModel9State {
  final List<ProductModel> products;

  CategoriesPageModel9Loaded(this.products);

  @override
  List<Object> get props => [products];
}

class CategoriesPageModel9Error extends CategoriesPageModel9State {
  final String message;

  CategoriesPageModel9Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoriesPageModel9State {} // State for cache cleared successfully

class CacheClearError extends CategoriesPageModel9State {
  final String message;

  CacheClearError(this.message);
}
