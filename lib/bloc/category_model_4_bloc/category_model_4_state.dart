import 'package:equatable/equatable.dart';

import '../../models/product_model.dart';

abstract class CategoryModel4State extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryModel4Initial extends CategoryModel4State {}

class CategoryModel4Loading extends CategoryModel4State {}

class CategoryModel4Loaded extends CategoryModel4State {
  final List<ProductModel> products;

  CategoryModel4Loaded(this.products);

  @override
  List<Object> get props => [products];
}

class CategoryModel4Error extends CategoryModel4State {
  final String message;

  CategoryModel4Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoryModel4State {} // State for cache cleared successfully

class CacheClearError extends CategoryModel4State {
  final String message;

  CacheClearError(this.message);
}
