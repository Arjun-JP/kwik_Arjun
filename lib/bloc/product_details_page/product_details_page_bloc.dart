import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/product_details_page/product_details_page_event.dart';
import 'package:kwik/bloc/product_details_page/product_details_page_state.dart';

class VariationBloc extends Bloc<VariationEvent, VariationState> {
  VariationBloc() : super(VariationInitial()) {
    on<SelectVariationEvent>((event, emit) {
      if (state is VariationSelected) {
        final currentState = state as VariationSelected;
        emit(currentState.copyWith(event.selectedVariation));
      } else {
        emit(VariationSelected(event.selectedVariation));
      }
    });
  }
}
