import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/product_model.dart' show ProductModel;
import 'package:kwik/repositories/sub_category_product_repository.dart';

part 'supersaver_model6_event.dart';
part 'supersaver_model6_state.dart';

class SupersaverModel6Bloc
    extends Bloc<SupersaverModel6Event, SupersaverModel6State> {
  final SubcategoryProductRepository repository;
  final Box _cacheBoxCM4 = Hive.box('product_cache_SS5');
  SupersaverModel6Bloc({required this.repository})
      : super(SupersaverModel6Initial()) {
    on<FetchSubCategoryProductsSS6>(_onFetchProducts);
    on<ClearsubcatCacheSS6>(_onClearCache);
  }
  Future<void> _onFetchProducts(FetchSubCategoryProductsSS6 event,
      Emitter<SupersaverModel6State> emit) async {
    emit(SupersaverModel6Loading());

    // Check cache
    if (_cacheBoxCM4.containsKey(event.subCategoryId)) {
      final cachedData = _cacheBoxCM4.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(SupersaverModel6Loaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxCM4.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(SupersaverModel6Loaded(products));
    } catch (e) {
      emit(SupersaverModel6Error(e.toString()));
    }
  }

  void _onClearCache(
      ClearsubcatCacheSS6 event, Emitter<SupersaverModel6State> emit) async {
    try {
      // Open cache boxes
      var subcategoryproduct = await Hive.openBox('product_cache_SS5');

      // Clear the cache
      await subcategoryproduct.clear();

      print("Cache cleared");
      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}
