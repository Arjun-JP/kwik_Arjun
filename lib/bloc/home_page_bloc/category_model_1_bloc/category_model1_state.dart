import 'package:equatable/equatable.dart';
import 'package:kwik/models/subcategory_model.dart';

import '../../../models/category_model.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final Category category;
  final List<SubCategoryModel> subCategories;

  CategoryLoaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoryState {} // State for cache cleared successfully

class CacheClearError extends CategoryState {
  final String message;

  CacheClearError(this.message);
}
