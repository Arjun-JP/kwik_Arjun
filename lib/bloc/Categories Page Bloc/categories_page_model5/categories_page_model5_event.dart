part of 'categories_page_model5_bloc.dart';

sealed class CategoriesPageModel5Event extends Equatable {
  const CategoriesPageModel5Event();

  @override
  List<Object> get props => [];
}
class FetchCategoryAndProductsEvent extends CategoriesPageModel5Event {
  final String categoryId;
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsEvent({
    required this.categoryId,
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [categoryId, subCategoryIds];
}

class UpdateSelectedCategoryEvent extends CategoriesPageModel5Event {
  final String selectedCategoryId;

  const UpdateSelectedCategoryEvent({required this.selectedCategoryId});

  @override
  List<Object> get props => [selectedCategoryId];
}

class ClearCacheEventCM5 extends CategoriesPageModel5Event {}
