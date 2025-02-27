part of 'categories_page_model8_bloc.dart';

sealed class CategoriesPageModel8Event extends Equatable {
  const CategoriesPageModel8Event();

  @override
  List<Object> get props => [];
}

class FetchCategoryDetails extends CategoriesPageModel8Event {
  final String categoryId;

  FetchCategoryDetails(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class ClearCache extends CategoriesPageModel8Event {}
