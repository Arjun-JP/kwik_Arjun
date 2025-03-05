import 'package:equatable/equatable.dart';

abstract class CategoryModel14Event extends Equatable {
  const CategoryModel14Event();

  @override
  List<Object> get props => [];
}

class FetchCategoryAndProductsEvent extends CategoryModel14Event {
  final String categoryId;
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsEvent({
    required this.categoryId,
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [categoryId, subCategoryIds];
}

class UpdateSelectedCategoryModel14Event extends CategoryModel14Event {
  final String selectedCategoryId;

  const UpdateSelectedCategoryModel14Event({required this.selectedCategoryId});

  @override
  List<Object> get props => [selectedCategoryId];
}

class ClearCacheEventCM14 extends CategoryModel14Event {}
