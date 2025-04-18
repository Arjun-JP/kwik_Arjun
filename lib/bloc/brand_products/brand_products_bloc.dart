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
    emit(BrandProductLoading());
    try {
      final products = await repository.fetchProductsByBrand(event.brandId);

      emit(BrandProductLoaded(products));
    } catch (e, stackTrace) {
      emit(BrandProductError(e.toString()));
    }
  }
}
