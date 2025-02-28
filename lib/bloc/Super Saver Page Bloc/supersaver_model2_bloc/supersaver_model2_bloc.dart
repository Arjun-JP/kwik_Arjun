import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';

part 'supersaver_model2_event.dart';
part 'supersaver_model2_state.dart';

class SupersaverModel2Bloc
    extends Bloc<SupersaverModel2Event, SupersaverModel2State> {
  final SubcategoryProductRepository repository;
  final Box _cacheBoxSS = Hive.box('product_cache_category_model7');

  SupersaverModel2Bloc({required this.repository})
      : super(SupersaverModel2Initial()) {
    on<FetchSubCategoryProductsSS>(_onFetchProducts);
    on<ClearsubcatSS>(_onClearCache);
  }
  Future<void> _onFetchProducts(FetchSubCategoryProductsSS event,
      Emitter<SupersaverModel2State> emit) async {
    emit(SupersaverModel2Loading());

    // Check cache
    if (_cacheBoxSS.containsKey(event.subCategoryId)) {
      final cachedData = _cacheBoxSS.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(SupersaverModel2Loaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxSS.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(SupersaverModel2Loaded(products));
    } catch (e) {
      emit(SupersaverModel2Error(e.toString()));
    }
  }

  void _onClearCache(
      ClearsubcatSS event, Emitter<SupersaverModel2State> emit) async {
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
