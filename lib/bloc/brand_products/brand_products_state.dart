import 'package:equatable/equatable.dart';
import 'package:kwik/models/product_model.dart';

abstract class BrandProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class BrandProductInitial extends BrandProductState {}

class BrandProductLoading extends BrandProductState {}

class BrandProductLoaded extends BrandProductState {
  final List<ProductModel> products;

  BrandProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class BrandProductError extends BrandProductState {
  final String message;

  BrandProductError(this.message);

  @override
  List<Object> get props => [message];
}
