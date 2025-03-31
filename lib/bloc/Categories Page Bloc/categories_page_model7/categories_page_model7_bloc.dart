import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/category_model_10_repo.dart';

part 'categories_page_model7_event.dart';
part 'categories_page_model7_state.dart';

class CategoriesPageModel7Bloc
    extends Bloc<CategoriesPageModel7Event, CategoriesPageModel7State> {
  final CategoryModel10Repo repository;
  final Box _cacheBoxCM4 = Hive.box('product_cache_category_model10');
  CategoriesPageModel7Bloc({required this.repository})
      : super(CategoriesPageModel7Initial()) {
    on<FetchSubCategoryProducts>(_onFetchProducts);
    on<Clearsubcatproduct10Cache>(_onClearCache);
  }
  Future<void> _onFetchProducts(FetchSubCategoryProducts event,
      Emitter<CategoriesPageModel7State> emit) async {
    emit(CategoriesPageModel7Loading());

    // Check cache
    if (_cacheBoxCM4.containsKey(event.subCategoryId)) {
      final cachedData = _cacheBoxCM4.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(CategoriesPageModel7Loaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxCM4.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(CategoriesPageModel7Loaded(products));
    } catch (e) {
      emit(CategoriesPageModel7Error(e.toString()));
    }
  }

  void _onClearCache(Clearsubcatproduct10Cache event,
      Emitter<CategoriesPageModel7State> emit) async {
    try {
      // Open cache boxes
      var subcategoryproduct =
          await Hive.openBox('product_cache_category_model10');

      // Clear the cache
      await subcategoryproduct.clear();

      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}
