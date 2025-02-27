part of 'categories_page_model2_bloc.dart';

sealed class CategoriesPageModel2Event extends Equatable {
  const CategoriesPageModel2Event();

  @override
  List<Object> get props => [];
}
class FetchCategoryDetailsModel2 extends CategoriesPageModel2Event {
  final String categoryId;

  const FetchCategoryDetailsModel2(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
class ClearCacheCatPage2 extends CategoriesPageModel2Event {}