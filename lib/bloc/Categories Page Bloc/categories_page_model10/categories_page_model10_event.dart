part of 'categories_page_model10_bloc.dart';

sealed class CategoriesPageModel10Event extends Equatable {
  const CategoriesPageModel10Event();

  @override
  List<Object> get props => [];
}

class FetchCategoryDetailsModel10 extends CategoriesPageModel10Event {
  final String categoryId;

  const FetchCategoryDetailsModel10(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class ClearCacheCatPage10 extends CategoriesPageModel10Event {}
