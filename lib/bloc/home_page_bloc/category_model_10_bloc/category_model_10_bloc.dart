import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/category_model_10_repo.dart';
import 'category_model_10_event.dart';
import 'category_model_10_state.dart';

class CategoryModel10Bloc
    extends Bloc<CategoryModel10Event, CategoryModel10State> {
  final CategoryModel10Repo repository;
  final Box _cacheBoxCM4 = Hive.box('product_cache_category_model10');

  CategoryModel10Bloc({required this.repository})
      : super(CategoryModel10Initial()) {
    on<FetchSubCategoryProducts>(_onFetchProducts);
    on<Clearsubcatproduct10Cache>(_onClearCache);
  }

  Future<void> _onFetchProducts(FetchSubCategoryProducts event,
      Emitter<CategoryModel10State> emit) async {
    emit(CategoryModel10Loading());

    // Check cache
    if (_cacheBoxCM4.containsKey(event.subCategoryId)) {
      final cachedData = _cacheBoxCM4.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(CategoryModel10Loaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxCM4.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(CategoryModel10Loaded(products));
    } catch (e) {
      emit(CategoryModel10Error(e.toString()));
    }
  }

  void _onClearCache(Clearsubcatproduct10Cache event,
      Emitter<CategoryModel10State> emit) async {
    try {
      // Open cache boxes
      var subcategoryproduct =
          await Hive.openBox('product_cache_category_model10');

      // Clear the cache
      await subcategoryproduct.clear();

      print("Cache cleared");
      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}
