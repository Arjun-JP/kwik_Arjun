import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/brand_products/brand_products_event.dart';
import 'package:kwik/bloc/brand_products/brand_products_state.dart';
import 'package:kwik/repositories/brand_products_repo.dart';

class BrandProductBloc extends Bloc<BrandProductEvent, BrandProductState> {
  final BrandProductRepository repository;

  BrandProductBloc(this.repository) : super(BrandProductInitial()) {
    on<FetchBrandProducts>(_onFetchBrandProducts);
  }

  Future<void> _onFetchBrandProducts(
      FetchBrandProducts event, Emitter<BrandProductState> emit) async {
    print("brand called");
    emit(BrandProductLoading());
    try {
      print("api called");

      final products = await repository.fetchProductsByBrand(event.brandId);

      print("api call completed, products received: $products");

      emit(BrandProductLoaded(products));
    } catch (e, stackTrace) {
      print("Error fetching brand products: $e");
      print(stackTrace);
      emit(BrandProductError(e.toString()));
    }
  }
}
