import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/category_model_4_bloc/category_model_4_event.dart';
import 'package:kwik/bloc/category_model_4_bloc/category_model_4_state.dart';
import 'package:kwik/models/product_model.dart';

import '../../repositories/sub_category_product_repository.dart';

class CategoryModel4Bloc
    extends Bloc<CategoryModel4Event, CategoryModel4State> {
  final SubcategoryProductRepository repository;
  final Box _cacheBoxCM4 = Hive.box('product_cache');

  CategoryModel4Bloc({required this.repository})
      : super(CategoryModel4Initial()) {
    on<FetchSubCategoryProducts>(_onFetchProducts);
    on<Clearsubcatproduct1Cache>(_onClearCache);
  }

  Future<void> _onFetchProducts(
      FetchSubCategoryProducts event, Emitter<CategoryModel4State> emit) async {
    emit(CategoryModel4Loading());

    // Check cache
    if (_cacheBoxCM4.containsKey(event.subCategoryId)) {
      final cachedData = _cacheBoxCM4.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(CategoryModel4Loaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxCM4.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(CategoryModel4Loaded(products));
    } catch (e) {
      emit(CategoryModel4Error(e.toString()));
    }
  }

  void _onClearCache(
      Clearsubcatproduct1Cache event, Emitter<CategoryModel4State> emit) async {
    try {
      // Open cache boxes
      var subcategoryproduct = await Hive.openBox('product_cache');

      // Clear the cache
      await subcategoryproduct.clear();

      print("Cache cleared");
      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}
