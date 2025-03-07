import 'package:equatable/equatable.dart';

abstract class CategoryModel9Event extends Equatable {
  const CategoryModel9Event();

  @override
  List<Object> get props => [];
}

class FetchCategoryAndProductsEvent extends CategoryModel9Event {
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsEvent({
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [subCategoryIds];
}

class ClearCacheEventCM9 extends CategoryModel9Event {}
