import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';

part 'supersaver_model4_event.dart';
part 'supersaver_model4_state.dart';

class SupersaverModel4Bloc
    extends Bloc<SupersaverModel4Event, SupersaverModel4State> {
  final SubcategoryProductRepository repository;
  final Box _cacheBoxCM4 = Hive.box('product_cache');
  SupersaverModel4Bloc({required this.repository})
      : super(SupersaverModel4Initial()) {
    on<FetchSubCategoryProductsSS4>(_onFetchProducts);
    on<ClearsubcatCacheSS4>(_onClearCache);
  }

  Future<void> _onFetchProducts(FetchSubCategoryProductsSS4 event,
      Emitter<SupersaverModel4State> emit) async {
    emit(SupersaverModel4Loading());

    // Check cache
    if (_cacheBoxCM4.containsKey(event.subCategoryId)) {
      final cachedData = _cacheBoxCM4.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(SupersaverModel4Loaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxCM4.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(SupersaverModel4Loaded(products));
    } catch (e) {
      emit(SupersaverModel4Error(e.toString()));
    }
  }

  void _onClearCache(
      ClearsubcatCacheSS4 event, Emitter<SupersaverModel4State> emit) async {
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
