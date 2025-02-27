part of 'categories_page_model4_bloc.dart';

sealed class CategoriesPageModel4State extends Equatable {
  const CategoriesPageModel4State();

  @override
  List<Object> get props => [];
}

final class CategoriesPageModel4Initial extends CategoriesPageModel4State {}

class CategoriesPageModel4Loading extends CategoriesPageModel4State {}

class CategoriesPageModel4Loaded extends CategoriesPageModel4State {
  final List<ProductModel> products;

  CategoriesPageModel4Loaded(this.products);

  @override
  List<Object> get props => [products];
}

class CategoriesPageModel4Error extends CategoriesPageModel4State {
  final String message;

  CategoriesPageModel4Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoriesPageModel4State {} // State for cache cleared successfully

class CacheClearError extends CategoriesPageModel4State {
  final String message;

  CacheClearError(this.message);
}
