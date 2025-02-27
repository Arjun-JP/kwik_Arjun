part of 'categories_page_model1_bloc.dart';

sealed class CategoriesPageModel1Event extends Equatable {
  const CategoriesPageModel1Event();

  @override
  List<Object> get props => [];
}
class FetchCategoryDetailsModel1 extends CategoriesPageModel1Event {
  final String categoryId;

  const FetchCategoryDetailsModel1(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
class ClearCacheCatPage1 extends CategoriesPageModel1Event {}