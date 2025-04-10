import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/subcategory_product_bloc/subcategory_product_event.dart';
import 'package:kwik/bloc/subcategory_product_bloc/subcategory_product_state.dart';
import 'package:kwik/repositories/subcategory_product_repo.dart';

class SubcategoryProductBlocSubcategory extends Bloc<
    SubcategoryProductEventsubcategory, SubcategoryProductStatesubcategory> {
  final SubcategProductRepository repository;

  SubcategoryProductBlocSubcategory(this.repository)
      : super(SubcategoryproductInitialsubcategory()) {
    on<FetchSubcategoryProductsSubcategory>(_onFetchBrandProducts);
  }

  Future<void> _onFetchBrandProducts(FetchSubcategoryProductsSubcategory event,
      Emitter<SubcategoryProductStatesubcategory> emit) async {
    emit(SubcategoryProductLoadingsubcategory());
    try {
      final products =
          await repository.fetchProductsBySubcategory(event.subcategoryID);

      emit(SubcategoryProductLoadedsubcategory(products));
    } catch (e, stackTrace) {
      emit(SubcategoryProductErrorsubcategory("eooor"));
    }
  }
}
