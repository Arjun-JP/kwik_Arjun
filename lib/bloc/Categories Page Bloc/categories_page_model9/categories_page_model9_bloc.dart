import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';

part 'categories_page_model9_event.dart';
part 'categories_page_model9_state.dart';

class CategoriesPageModel9Bloc
    extends Bloc<CategoriesPageModel9Event, CategoriesPageModel9State> {
  final SubcategoryProductRepository repository;
  final Box _cacheBoxCM4 = Hive.box('product_cache_category_model7');
  CategoriesPageModel9Bloc({required this.repository})
      : super(CategoriesPageModel9Initial()) {
    on<FetchSubCategoryProducts>(_onFetchProducts);
    on<Clearsubcatproduct7Cache>(_onClearCache);
  }
  Future<void> _onFetchProducts(FetchSubCategoryProducts event,
      Emitter<CategoriesPageModel9State> emit) async {
    emit(CategoriesPageModel9Loading());

    // Check cache
    if (_cacheBoxCM4.containsKey(event.subCategoryId)) {
      final cachedData = _cacheBoxCM4.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(CategoriesPageModel9Loaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxCM4.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(CategoriesPageModel9Loaded(products));
    } catch (e) {
      emit(CategoriesPageModel9Error(e.toString()));
    }
  }

  void _onClearCache(Clearsubcatproduct7Cache event,
      Emitter<CategoriesPageModel9State> emit) async {
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
