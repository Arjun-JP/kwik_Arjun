import 'package:equatable/equatable.dart';
import 'package:kwik/models/variation_model.dart';

abstract class VariationState extends Equatable {
  @override
  List<Object> get props => [];
}

class VariationInitial extends VariationState {}

class VariationSelected extends VariationState {
  final VariationModel selectedVariation;

  VariationSelected(this.selectedVariation);

  VariationSelected copyWith(VariationModel newVariation) {
    return VariationSelected(newVariation);
  }

  @override
  List<Object> get props => [selectedVariation];
}
