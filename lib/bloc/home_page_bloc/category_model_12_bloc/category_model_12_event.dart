import 'package:equatable/equatable.dart';

abstract class CategoryModel12Event extends Equatable {
  const CategoryModel12Event();

  @override
  List<Object> get props => [];
}

class FetchCategoryAndProductsEvent extends CategoryModel12Event {
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsEvent({
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [subCategoryIds];
}

class ClearCacheEventCM12 extends CategoryModel12Event {}
