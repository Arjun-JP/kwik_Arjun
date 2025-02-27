part of 'categories_page_model6_bloc.dart';

sealed class CategoriesPageModel6State extends Equatable {
  const CategoriesPageModel6State();
  
  @override
  List<Object> get props => [];
}

final class CategoriesPageModel6Initial extends CategoriesPageModel6State {}
class CategoriesPageModel6Loading extends CategoriesPageModel6State {}

class CategoriesPageModel6Loaded extends CategoriesPageModel6State {
  final List<SubCategoryModel> categories;

  CategoriesPageModel6Loaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoriesPageModel6Error extends CategoriesPageModel6State {
  final String message;

  CategoriesPageModel6Error(this.message);

  @override
  List<Object> get props => [message];
}
