import 'package:equatable/equatable.dart';

abstract class CategoryModel13Event extends Equatable {
  const CategoryModel13Event();

  @override
  List<Object> get props => [];
}

class FetchCategoryAndProductsEvent extends CategoryModel13Event {
  final String categoryId;
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsEvent({
    required this.categoryId,
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [categoryId, subCategoryIds];
}

class UpdateSelectedCategoryModel13Event extends CategoryModel13Event {
  final String selectedCategoryId;

  const UpdateSelectedCategoryModel13Event({required this.selectedCategoryId});

  @override
  List<Object> get props => [selectedCategoryId];
}

class ClearCacheEventCM13 extends CategoryModel13Event {}
