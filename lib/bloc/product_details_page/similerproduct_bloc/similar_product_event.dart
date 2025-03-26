import 'package:equatable/equatable.dart';

abstract class SubcategoryProductEvent extends Equatable {
  const SubcategoryProductEvent();
}

class FetchSubcategoryProducts extends SubcategoryProductEvent {
  final String subCategoryId;
  final bool forceRefresh;

  const FetchSubcategoryProducts(this.subCategoryId,
      {this.forceRefresh = false});

  @override
  List<Object> get props => [subCategoryId, forceRefresh];
}

class ClearSimilarCache extends SubcategoryProductEvent {
  @override
  List<Object> get props => [];
}
