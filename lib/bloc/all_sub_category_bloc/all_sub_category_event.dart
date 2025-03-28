import 'package:equatable/equatable.dart';

abstract class AllSubCategoryEvent extends Equatable {
  const AllSubCategoryEvent();

  @override
  List<Object?> get props => [];
}

/// **Event to load all subcategories and products**
class LoadSubCategories extends AllSubCategoryEvent {
  final String categoryId;
  final String? selectedsubcategoryId;

  const LoadSubCategories(
      {required this.categoryId, this.selectedsubcategoryId});

  @override
  List<Object?> get props => [categoryId, selectedsubcategoryId];
}

/// **Event to select a subcategory and filter products**
class SelectSubCategory extends AllSubCategoryEvent {
  final String subCategoryId;
  final String categoryID;

  const SelectSubCategory(
      {required this.categoryID, required this.subCategoryId});

  @override
  List<Object> get props => [subCategoryId];
}

/// **Event to clear cache**
class ClearAllCategoryCache extends AllSubCategoryEvent {
  const ClearAllCategoryCache();
}
