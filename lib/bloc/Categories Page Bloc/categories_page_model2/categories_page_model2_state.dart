part of 'categories_page_model2_bloc.dart';

sealed class CategoriesPageModel2State extends Equatable {
  const CategoriesPageModel2State();
  
  @override
  List<Object> get props => [];
}

final class CategoriesPageModel2Initial extends CategoriesPageModel2State {}
class CategoriesPageModel2Loading extends CategoriesPageModel2State {}

class CategoriesPageModel2Loaded extends CategoriesPageModel2State {
  final Category category;
  final List<SubCategoryModel> subCategories;

  const CategoriesPageModel2Loaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}


class CategoriesPageModel2Error extends CategoriesPageModel2State {
  final String message;

  const CategoriesPageModel2Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoriesPageModel2State {} 

class CacheClearError extends CategoriesPageModel2State {
  final String message;

  const CacheClearError(this.message);
}
