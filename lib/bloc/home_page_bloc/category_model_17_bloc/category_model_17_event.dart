import 'package:equatable/equatable.dart';

abstract class CategoryModel17Event extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCategoryDetails extends CategoryModel17Event {
  final String categoryId;

  FetchCategoryDetails(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class ClearCacheCM17 extends CategoryModel17Event {}
