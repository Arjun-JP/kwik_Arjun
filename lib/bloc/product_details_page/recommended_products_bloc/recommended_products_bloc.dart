import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_event.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_state.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/recommended_product_repo.dart';

class RecommendedProductsBloc
    extends Bloc<RecommendedProductsEvent, RecommendedProductsState> {
  final RecommendedProductRepo productRepository;
  static const String _cacheKey = 'similar_product_cache';

  RecommendedProductsBloc(this.productRepository)
      : super(RecommendedProductInitial()) {
    on<FetchRecommendedProducts>(_onFetchProducts);
    on<ClearRecommendedproductCache>(_onClearCache);
  }

  Future<void> _onFetchProducts(FetchRecommendedProducts event,
      Emitter<RecommendedProductsState> emit) async {
    emit(RecommendedProductLoading());
    try {
      var box = await Hive.openBox('Recommended_product_cache');

      // Check if cached data exists and no force refresh
      if (!event.forceRefresh && box.containsKey(_cacheKey)) {
        final cachedData = (box.get(_cacheKey) as List)
            .map((json) =>
                ProductModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();

        emit(RecommendedProductLoaded(products: cachedData));
        return;
      }

      // Fetch from API if no cache
      final products =
          await productRepository.getProductsBySubCategory(event.subCategoryId);
      await box.put(
          _cacheKey,
          products
              .map((product) => product.toJson())
              .toList()); // Save to cache

      emit(RecommendedProductLoaded(products: products));
    } catch (e) {
      emit(RecommendedProductError(message: e.toString()));
    }
  }

  Future<void> _onClearCache(ClearRecommendedproductCache event,
      Emitter<RecommendedProductsState> emit) async {
    var box = await Hive.openBox('Recommended_product_cache');
    await box.delete(_cacheKey);
    emit(RecommendedProductInitial()); // Reset state
  }
}
