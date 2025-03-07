import 'package:equatable/equatable.dart';

import '../../../models/product_model.dart';

abstract class CategoryModel7State extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryModel7Initial extends CategoryModel7State {}

class CategoryModel7Loading extends CategoryModel7State {}

class CategoryModel7Loaded extends CategoryModel7State {
  final List<ProductModel> products;

  CategoryModel7Loaded(this.products);

  @override
  List<Object> get props => [products];
}

class CategoryModel7Error extends CategoryModel7State {
  final String message;

  CategoryModel7Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoryModel7State {} // State for cache cleared successfully

class CacheClearError extends CategoryModel7State {
  final String message;

  CacheClearError(this.message);
}
