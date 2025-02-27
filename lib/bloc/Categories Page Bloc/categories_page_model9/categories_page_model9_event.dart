part of 'categories_page_model9_bloc.dart';

sealed class CategoriesPageModel9Event extends Equatable {
  const CategoriesPageModel9Event();

  @override
  List<Object> get props => [];
}
class FetchSubCategoryProducts extends CategoriesPageModel9Event {
  final String subCategoryId;

  FetchSubCategoryProducts({required this.subCategoryId});

  @override
  List<Object> get props => [subCategoryId];
}

class Clearsubcatproduct7Cache extends CategoriesPageModel9Event {}