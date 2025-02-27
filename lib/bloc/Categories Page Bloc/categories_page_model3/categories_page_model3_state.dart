part of 'categories_page_model3_bloc.dart';

sealed class CategoriesPageModel3State extends Equatable {
  const CategoriesPageModel3State();
  
  @override
  List<Object> get props => [];
}

final class CategoriesPageModel3Initial extends CategoriesPageModel3State {}
class CategoriesPageModel3Loading extends CategoriesPageModel3State {}

class CategoriesPageModel3Loaded extends CategoriesPageModel3State {
  final Category category;
  final List<SubCategoryModel> subCategories;

  const CategoriesPageModel3Loaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}


class CategoriesPageModel3Error extends CategoriesPageModel3State {
  final String message;

  const CategoriesPageModel3Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends CategoriesPageModel3State {} 

class CacheClearError extends CategoriesPageModel3State {
  final String message;

  const CacheClearError(this.message);
}
