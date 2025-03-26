import 'package:equatable/equatable.dart';
import 'package:kwik/models/product_model.dart';

import 'package:equatable/equatable.dart';

abstract class SubcategoryProductState extends Equatable {
  const SubcategoryProductState();

  @override
  List<Object> get props => [];
}

class SubcategoryProductInitial extends SubcategoryProductState {}

class SubcategoryProductLoading extends SubcategoryProductState {}

class SubcategoryProductLoaded extends SubcategoryProductState {
  final List<ProductModel> products;

  const SubcategoryProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class SubcategoryProductError extends SubcategoryProductState {
  final String message;

  const SubcategoryProductError({required this.message});

  @override
  List<Object> get props => [message];
}
