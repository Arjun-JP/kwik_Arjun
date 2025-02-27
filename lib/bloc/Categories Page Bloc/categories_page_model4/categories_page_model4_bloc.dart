import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';

part 'categories_page_model4_event.dart';
part 'categories_page_model4_state.dart';

class CategoriesPageModel4Bloc
    extends Bloc<CategoriesPageModel4Event, CategoriesPageModel4State> {
  final SubcategoryProductRepository repository;
  final Box _cacheBoxCat4 = Hive.box('product_cache');
  CategoriesPageModel4Bloc({required this.repository})
      : super(CategoriesPageModel4Initial()) {
    on<FetchSubCategoryProducts4>(_onFetchProducts);
    on<Clearsubcatproduct1Cache4>(_onClearCache);
  }
  Future<void> _onFetchProducts(FetchSubCategoryProducts4 event,
      Emitter<CategoriesPageModel4State> emit) async {
    emit(CategoriesPageModel4Loading());

    // Check cache
    if (_cacheBoxCat4.containsKey(event.subCategoryId)) {
      final cachedData =
          _cacheBoxCat4.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(CategoriesPageModel4Loaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxCat4.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(CategoriesPageModel4Loaded(products));
    } catch (e) {
      emit(CategoriesPageModel4Error(e.toString()));
    }
  }

  void _onClearCache(Clearsubcatproduct1Cache4 event,
      Emitter<CategoriesPageModel4State> emit) async {
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
