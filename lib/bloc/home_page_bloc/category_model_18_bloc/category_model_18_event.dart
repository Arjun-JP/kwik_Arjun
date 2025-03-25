import 'package:equatable/equatable.dart';

abstract class CategoryModel18Event extends Equatable {
  const CategoryModel18Event();

  @override
  List<Object> get props => [];
}

class FetchCategoryAndProductsEvent extends CategoryModel18Event {
  final String categoryId;
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsEvent({
    required this.categoryId,
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [categoryId, subCategoryIds];
}

class UpdateSelectedCategoryModel18Event extends CategoryModel18Event {
  final String selectedCategoryId;

  const UpdateSelectedCategoryModel18Event({required this.selectedCategoryId});

  @override
  List<Object> get props => [selectedCategoryId];
}

class ClearCacheEventCM18 extends CategoryModel18Event {}
