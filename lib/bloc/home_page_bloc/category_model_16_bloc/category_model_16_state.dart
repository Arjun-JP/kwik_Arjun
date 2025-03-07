import 'package:equatable/equatable.dart';
import 'package:kwik/models/subcategory_model.dart';

import '../../../models/category_model.dart';

abstract class CategoryModel16State extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryModel16State {}

class CategoryLoading extends CategoryModel16State {}

class CategoryLoaded extends CategoryModel16State {
  final Category category;
  final List<SubCategoryModel> subCategories;

  CategoryLoaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}

class CategoryError extends CategoryModel16State {
  final String message;

  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoryModel16State {} // State for cache cleared successfully

class CacheClearError extends CategoryModel16State {
  final String message;

  CacheClearError(this.message);
}
