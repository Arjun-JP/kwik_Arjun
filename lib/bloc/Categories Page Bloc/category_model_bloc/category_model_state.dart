import 'package:equatable/equatable.dart';
import 'package:kwik/models/subcategory_model.dart';

import '../../../models/category_model.dart';

abstract class CategoryModelState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryModelState {}

class CategoryLoading extends CategoryModelState {}

class CategoryLoaded extends CategoryModelState {
  final List<Category> category;
  final List<SubCategoryModel> subCategories;

  CategoryLoaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}

class CategoryError extends CategoryModelState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoryModelState {} // State for cache cleared successfully

class CacheClearError extends CategoryModelState {
  final String message;

  CacheClearError(this.message);
}
