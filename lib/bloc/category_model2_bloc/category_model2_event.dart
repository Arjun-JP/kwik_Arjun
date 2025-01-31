import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCategoryDetails extends CategoryEvent {
  final String categoryId;

  FetchCategoryDetails(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class ClearCache extends CategoryEvent {}
