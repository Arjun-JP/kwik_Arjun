import 'package:equatable/equatable.dart';

abstract class CategoryModel11Event extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCategoryDetails extends CategoryModel11Event {
  final String categoryId;

  FetchCategoryDetails(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class ClearCacheCM11 extends CategoryModel11Event {}
