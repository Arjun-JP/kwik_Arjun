import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_product_event.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_products_state.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';

class SubcategoryProductBloc
    extends Bloc<SubcategoryProductEvent, SubcategoryProductState> {
  final SubcategoryProductRepository productRepository;
  static const String _cacheKey = 'similar_product_cache';

  SubcategoryProductBloc(this.productRepository)
      : super(SubcategoryProductInitial()) {
    on<FetchSubcategoryProducts>(_onFetchProducts);
    on<ClearSimilarCache>(_onClearCache);
  }

  Future<void> _onFetchProducts(FetchSubcategoryProducts event,
      Emitter<SubcategoryProductState> emit) async {
    emit(SubcategoryProductLoading());
    try {
      var box = await Hive.openBox('similar_product_cache');

      // Check if cached data exists and no force refresh
      if (!event.forceRefresh && box.containsKey(_cacheKey)) {
        final cachedData = (box.get(_cacheKey) as List)
            .map((json) =>
                ProductModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();

        emit(SubcategoryProductLoaded(products: cachedData));
        return;
      }

      // Fetch from API if no cache
      final products =
          await productRepository.getProductsBySubCategory(event.CategoryId);
      await box.put(
          _cacheKey,
          products
              .map((product) => product.toJson())
              .toList()); // Save to cache

      emit(SubcategoryProductLoaded(products: products));
    } catch (e) {
      emit(SubcategoryProductError(message: e.toString()));
    }
  }

  Future<void> _onClearCache(
      ClearSimilarCache event, Emitter<SubcategoryProductState> emit) async {
    var box = await Hive.openBox('subcategory_cache_box');
    await box.delete(_cacheKey);
    emit(SubcategoryProductInitial()); // Reset state
  }
}
