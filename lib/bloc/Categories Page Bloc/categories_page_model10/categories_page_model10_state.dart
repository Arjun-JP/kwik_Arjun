part of 'categories_page_model10_bloc.dart';

sealed class CategoriesPageModel10State extends Equatable {
  const CategoriesPageModel10State();
  
  @override
  List<Object> get props => [];
}

final class CategoriesPageModel10Initial extends CategoriesPageModel10State {}
class CategoriesPageModel10Loading extends CategoriesPageModel10State {}

class CategoriesPageModel10Loaded extends CategoriesPageModel10State {
  final Category category;
  final List<SubCategoryModel> subCategories;

  const CategoriesPageModel10Loaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}

class CategoriesPageModel10Error extends CategoriesPageModel10State {
  final String message;

  const CategoriesPageModel10Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoriesPageModel10State {} 

class CacheClearError extends CategoriesPageModel10State {
  final String message;

  const CacheClearError(this.message);
}
