import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_7_bloc/category_model_7_state.dart';

import 'package:kwik/models/product_model.dart';

import '../../../repositories/sub_category_product_repository.dart';
import 'category_model_7_event.dart';

class CategoryModel7Bloc
    extends Bloc<CategoryModel7Event, CategoryModel7State> {
  final SubcategoryProductRepository repository;
  final Box _cacheBoxCM4 = Hive.box('product_cache_category_model7');

  CategoryModel7Bloc({required this.repository})
      : super(CategoryModel7Initial()) {
    on<FetchSubCategoryProducts>(_onFetchProducts);
    on<Clearsubcatproduct7Cache>(_onClearCache);
  }

  Future<void> _onFetchProducts(
      FetchSubCategoryProducts event, Emitter<CategoryModel7State> emit) async {
    emit(CategoryModel7Loading());

    // Check cache
    if (_cacheBoxCM4.containsKey(event.subCategoryId)) {
      final cachedData = _cacheBoxCM4.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(CategoryModel7Loaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxCM4.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(CategoryModel7Loaded(products));
    } catch (e) {
      emit(CategoryModel7Error(e.toString()));
    }
  }

  void _onClearCache(
      Clearsubcatproduct7Cache event, Emitter<CategoryModel7State> emit) async {
    try {
      // Open cache boxes
      var subcategoryproduct =
          await Hive.openBox('product_cache_category_model7');

      // Clear the cache
      await subcategoryproduct.clear();

      print("Cache cleared");
      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}
