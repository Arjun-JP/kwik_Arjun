part of 'categories_page_model7_bloc.dart';

sealed class CategoriesPageModel7Event extends Equatable {
  const CategoriesPageModel7Event();

  @override
  List<Object> get props => [];
}
class FetchSubCategoryProducts extends CategoriesPageModel7Event {
  final String subCategoryId;

  FetchSubCategoryProducts({required this.subCategoryId});

  @override
  List<Object> get props => [subCategoryId];
}

class Clearsubcatproduct10Cache extends CategoriesPageModel7Event {}