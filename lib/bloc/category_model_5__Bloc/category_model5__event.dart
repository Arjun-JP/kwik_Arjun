import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class FetchCategoryAndProductsEvent extends CategoryEvent {
  final String categoryId;
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsEvent({
    required this.categoryId,
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [categoryId, subCategoryIds];
}

class UpdateSelectedCategoryEvent extends CategoryEvent {
  final String selectedCategoryId;

  const UpdateSelectedCategoryEvent({required this.selectedCategoryId});

  @override
  List<Object> get props => [selectedCategoryId];
}

class ClearCacheEventCM5 extends CategoryEvent {}
