part of 'categories_page_model3_bloc.dart';

sealed class CategoriesPageModel3Event extends Equatable {
  const CategoriesPageModel3Event();

  @override
  List<Object> get props => [];
}
class FetchCategoryDetailsModel3 extends CategoriesPageModel3Event {
  final String categoryId;

  const FetchCategoryDetailsModel3(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
class ClearCacheCatPage3 extends CategoriesPageModel3Event {}