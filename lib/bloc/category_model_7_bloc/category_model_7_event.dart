import 'package:equatable/equatable.dart';

abstract class CategoryModel7Event extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSubCategoryProducts extends CategoryModel7Event {
  final String subCategoryId;

  FetchSubCategoryProducts({required this.subCategoryId});

  @override
  List<Object> get props => [subCategoryId];
}

class Clearsubcatproduct7Cache extends CategoryModel7Event {}
