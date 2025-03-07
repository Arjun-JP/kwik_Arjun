import 'package:equatable/equatable.dart';

abstract class CategoryModel15Event extends Equatable {
  const CategoryModel15Event();

  @override
  List<Object> get props => [];
}

class FetchCategoryAndProductsEvent extends CategoryModel15Event {
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsEvent({
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [subCategoryIds];
}

class ClearCacheEventCM15 extends CategoryModel15Event {}
