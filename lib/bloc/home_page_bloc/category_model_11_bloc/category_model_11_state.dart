import 'package:equatable/equatable.dart';
import 'package:kwik/models/subcategory_model.dart';

import '../../../models/category_model.dart';

abstract class CategoryModel11State extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryModel11Initial extends CategoryModel11State {}

class CategoryModel11Loading extends CategoryModel11State {}

class CategoryModel11Loaded extends CategoryModel11State {
  final Category category;
  final List<SubCategoryModel> subCategories;

  CategoryModel11Loaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}

class CategoryModel11Error extends CategoryModel11State {
  final String message;

  CategoryModel11Error(this.message);

  @override
  List<Object> get props => [message];
}

class ClearCacheredCM11
    extends CategoryModel11State {} // State for cache cleared successfully

class CacheClearErrorCM11 extends CategoryModel11State {
  final String message;

  CacheClearErrorCM11(this.message);
}
