import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/category_model_8_repo.dart';

part 'categories_page_model6_event.dart';
part 'categories_page_model6_state.dart';

class CategoriesPageModel6Bloc extends Bloc<CategoriesPageModel6Event, CategoriesPageModel6State> {
    final Categorymodel8Repository categoryRepository;
  CategoriesPageModel6Bloc({required this.categoryRepository}) : super(CategoriesPageModel6Initial()) {
  on<FetchCategoriesmodel6>((event, emit) async {
      emit(CategoriesPageModel6Loading());
      try {
        final categories = await categoryRepository.fetchCategories();
        emit(CategoriesPageModel6Loaded(categories));
      } catch (e) {
        emit(CategoriesPageModel6Error(e.toString()));
      }
    });
  }
}
