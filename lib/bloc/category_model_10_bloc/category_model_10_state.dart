import 'package:equatable/equatable.dart';

import '../../models/product_model.dart';

abstract class CategoryModel10State extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryModel10Initial extends CategoryModel10State {}

class CategoryModel10Loading extends CategoryModel10State {}

class CategoryModel10Loaded extends CategoryModel10State {
  final List<ProductModel> products;

  CategoryModel10Loaded(this.products);

  @override
  List<Object> get props => [products];
}

class CategoryModel10Error extends CategoryModel10State {
  final String message;

  CategoryModel10Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoryModel10State {} // State for cache cleared successfully

class CacheClearError extends CategoryModel10State {
  final String message;

  CacheClearError(this.message);
}
