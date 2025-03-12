import 'package:equatable/equatable.dart';

abstract class CategoryLandingpageEvent extends Equatable {
  const CategoryLandingpageEvent();

  @override
  List<Object> get props => [];
}

class FetchCategoryAndProductsEventcategorylandiongpage
    extends CategoryLandingpageEvent {
  final String categoryId;
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsEventcategorylandiongpage({
    required this.categoryId,
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [categoryId, subCategoryIds];
}

class UpdateSelectedCategoryLandingpageEvent extends CategoryLandingpageEvent {
  final String selectedCategoryId;

  const UpdateSelectedCategoryLandingpageEvent(
      {required this.selectedCategoryId});

  @override
  List<Object> get props => [selectedCategoryId];
}

class ClearCacheEventCLP extends CategoryLandingpageEvent {}
