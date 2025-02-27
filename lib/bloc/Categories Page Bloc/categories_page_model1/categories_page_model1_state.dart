part of 'categories_page_model1_bloc.dart';

sealed class CategoriesPageModel1State extends Equatable {
  const CategoriesPageModel1State();
  
  @override
  List<Object> get props => [];
}

class CategoriesPageModel1Initial extends CategoriesPageModel1State {}

class CategoriesPageModel1Loading extends CategoriesPageModel1State {}

class CategoriesPageModel1Loaded extends CategoriesPageModel1State {
  final Category category;
  final List<SubCategoryModel> subCategories;

  const CategoriesPageModel1Loaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}

class CategoriesPageModel1Error extends CategoriesPageModel1State {
  final String message;

  const CategoriesPageModel1Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoriesPageModel1State {} 

class CacheClearError extends CategoriesPageModel1State {
  final String message;

  const CacheClearError(this.message);
}
