import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/repositories/category_model_8_repo.dart';

import 'category_model_8_event.dart';
import 'category_model_8_state.dart';

class CategoryModel8Bloc extends Bloc<Categorybloc8Event, CategoryBloc8State> {
  final Categorymodel8Repository categoryRepository;

  CategoryModel8Bloc({required this.categoryRepository})
      : super(Categorymode8Initial()) {
    on<FetchCategoriesmodel8>((event, emit) async {
      emit(Categorymode8Loading());
      try {
        final categories = await categoryRepository.fetchCategories();
        emit(Categorymode8Loaded(categories));
      } catch (e) {
        emit(Categorymode8Error(e.toString()));
      }
    });
  }
}
