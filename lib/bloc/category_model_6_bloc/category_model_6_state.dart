import 'package:equatable/equatable.dart';
import 'package:kwik/models/subcategory_model.dart';

import '../../models/category_model.dart';

abstract class CategoryState6 extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState6 {}

class CategoryLoading extends CategoryState6 {}

class CategoryLoaded extends CategoryState6 {
  final List<SubCategoryModel> subCategories;

  CategoryLoaded({required this.subCategories});

  @override
  List<Object> get props => [subCategories];
}

class CategoryError extends CategoryState6 {
  final String message;

  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoryState6 {} // State for cache cleared successfully

class CacheClearError extends CategoryState6 {
  final String message;

  CacheClearError(this.message);
}
