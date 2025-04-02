import 'package:equatable/equatable.dart';

abstract class BrandProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchBrandProducts extends BrandProductEvent {
  final String brandId;

  FetchBrandProducts(this.brandId);

  @override
  List<Object> get props => [brandId];
}
