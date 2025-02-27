part of 'categories_page_model4_bloc.dart';

sealed class CategoriesPageModel4Event extends Equatable {
  const CategoriesPageModel4Event();

  @override
  List<Object> get props => [];
}

class FetchSubCategoryProducts4 extends CategoriesPageModel4Event {
  final String subCategoryId;

  FetchSubCategoryProducts4(this.subCategoryId);

  @override
  List<Object> get props => [subCategoryId];
}

class Clearsubcatproduct1Cache4 extends CategoriesPageModel4Event {}
