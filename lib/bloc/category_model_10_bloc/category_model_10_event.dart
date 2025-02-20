import 'package:equatable/equatable.dart';

abstract class CategoryModel10Event extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSubCategoryProducts extends CategoryModel10Event {
  final String subCategoryId;

  FetchSubCategoryProducts({required this.subCategoryId});

  @override
  List<Object> get props => [subCategoryId];
}

class Clearsubcatproduct10Cache extends CategoryModel10Event {}
