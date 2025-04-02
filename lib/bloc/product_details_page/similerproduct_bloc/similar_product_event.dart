import 'package:equatable/equatable.dart';

abstract class SubcategoryProductEvent extends Equatable {
  const SubcategoryProductEvent();
}

class FetchSubcategoryProducts extends SubcategoryProductEvent {
  final String CategoryId;
  final bool forceRefresh;

  const FetchSubcategoryProducts(this.CategoryId, {this.forceRefresh = false});

  @override
  List<Object> get props => [CategoryId, forceRefresh];
}

class ClearSimilarCache extends SubcategoryProductEvent {
  @override
  List<Object> get props => [];
}
