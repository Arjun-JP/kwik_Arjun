import 'package:equatable/equatable.dart';
import 'package:kwik/models/variation_model.dart';

abstract class VariationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectVariationEvent extends VariationEvent {
  final VariationModel selectedVariation;

  SelectVariationEvent(this.selectedVariation);

  @override
  List<Object> get props => [selectedVariation];
}
