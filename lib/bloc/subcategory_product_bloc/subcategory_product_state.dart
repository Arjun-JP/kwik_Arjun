import 'package:equatable/equatable.dart';
import 'package:kwik/models/product_model.dart';

abstract class SubcategoryProductStatesubcategory extends Equatable {
  @override
  List<Object> get props => [];
}

class SubcategoryproductInitialsubcategory extends SubcategoryProductStatesubcategory {}

class SubcategoryProductLoadingsubcategory extends SubcategoryProductStatesubcategory {}

class SubcategoryProductLoadedsubcategory extends SubcategoryProductStatesubcategory {
  final List<ProductModel> products;

  SubcategoryProductLoadedsubcategory(this.products);

  @override
  List<Object> get props => [products];
}

class SubcategoryProductErrorsubcategory extends SubcategoryProductStatesubcategory {
  final String message;

  SubcategoryProductErrorsubcategory(this.message);

  @override
  List<Object> get props => [message];
}
