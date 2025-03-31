import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';

part 'cart_similar_products_event.dart';
part 'cart_similar_products_state.dart';

class CartSimilarProductsBloc
    extends Bloc<CartSimilarProductsEvent, CartSimilarProductsState> {
  final SubcategoryProductRepository repository;
  final Box _cacheBoxCM4 = Hive.box('product');

  CartSimilarProductsBloc({required this.repository})
      : super(CartSimilarProductsInitial()) {
    on<FetchSubCategoryProducts>(_onFetchProducts);
    on<Clearsubcatproduct7Cache>(_onClearCache);
  }
  Future<void> _onFetchProducts(FetchSubCategoryProducts event,
      Emitter<CartSimilarProductsState> emit) async {
    emit(CartSimilarProductsLoading());

    // Check cache
    if (_cacheBoxCM4.containsKey(event.subCategoryId)) {
      final cachedData = _cacheBoxCM4.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(CartSimilarProductsLoaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxCM4.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(CartSimilarProductsLoaded(products));
    } catch (e) {
      emit(CartSimilarProductsError(e.toString()));
    }
  }

  void _onClearCache(Clearsubcatproduct7Cache event,
      Emitter<CartSimilarProductsState> emit) async {
    try {
      // Open cache boxes
      var subcategoryproduct =
          await Hive.openBox('product_cache_category_model7');

      // Clear the cache
      await subcategoryproduct.clear();

      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}
