import 'package:equatable/equatable.dart';

abstract class CategoryModel19Event extends Equatable {
  const CategoryModel19Event();

  @override
  List<Object> get props => [];
}

class FetchCategoryAndProductsEventCM19 extends CategoryModel19Event {
  final String categoryId;
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsEventCM19({
    required this.categoryId,
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [categoryId, subCategoryIds];
}

class UpdateSelectedCategoryModel19Event extends CategoryModel19Event {
  final String selectedCategoryId;

  const UpdateSelectedCategoryModel19Event({required this.selectedCategoryId});

  @override
  List<Object> get props => [selectedCategoryId];
}

class ClearCacheEventCM19 extends CategoryModel19Event {}
