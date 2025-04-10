import 'package:equatable/equatable.dart';

abstract class SubcategoryProductEventsubcategory extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSubcategoryProductsSubcategory
    extends SubcategoryProductEventsubcategory {
  final String subcategoryID;

  FetchSubcategoryProductsSubcategory({required this.subcategoryID});

  @override
  List<Object> get props => [subcategoryID];
}
