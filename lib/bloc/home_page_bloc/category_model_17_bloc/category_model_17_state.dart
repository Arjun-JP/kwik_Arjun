import 'package:equatable/equatable.dart';
import 'package:kwik/models/subcategory_model.dart';

import '../../../models/category_model.dart';

abstract class CategoryModel17State extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryModel17State {}

class CategoryLoading extends CategoryModel17State {}

class CategoryLoaded extends CategoryModel17State {
  final Category category;
  final List<SubCategoryModel> subCategories;

  CategoryLoaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}

class CategoryError extends CategoryModel17State {
  final String message;

  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoryModel17State {} // State for cache cleared successfully

class CacheClearError extends CategoryModel17State {
  final String message;

  CacheClearError(this.message);
}
