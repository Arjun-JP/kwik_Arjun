import 'package:equatable/equatable.dart';

abstract class CategoryModel4Event extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSubCategoryProducts extends CategoryModel4Event {
  final String subCategoryId;

  FetchSubCategoryProducts(this.subCategoryId);

  @override
  List<Object> get props => [subCategoryId];
}

class Clearsubcatproduct1Cache extends CategoryModel4Event {}
