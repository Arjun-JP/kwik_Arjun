import 'package:equatable/equatable.dart';

abstract class RecommendedProductsEvent extends Equatable {
  const RecommendedProductsEvent();
}

class FetchRecommendedProducts extends RecommendedProductsEvent {
  final String subCategoryId;
  final bool forceRefresh;

  const FetchRecommendedProducts(this.subCategoryId,
      {this.forceRefresh = false});

  @override
  List<Object> get props => [subCategoryId, forceRefresh];
}

class ClearRecommendedproductCache extends RecommendedProductsEvent {
  @override
  List<Object> get props => [];
}
