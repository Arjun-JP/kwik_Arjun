import 'package:equatable/equatable.dart';

abstract class CategoryModel16Event extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCategoryDetails extends CategoryModel16Event {
  final String categoryId;

  FetchCategoryDetails(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class ClearCacheCM16 extends CategoryModel16Event {}
