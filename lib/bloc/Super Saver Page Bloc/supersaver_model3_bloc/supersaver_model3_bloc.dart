import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/category_model_10_repo.dart';

part 'supersaver_model3_event.dart';
part 'supersaver_model3_state.dart';

class SupersaverModel3Bloc
    extends Bloc<SupersaverModel3Event, SupersaverModel3State> {
  final CategoryModel10Repo repository;
  final Box _cacheBoxCM4 = Hive.box('product_cache_category_SS3');
  SupersaverModel3Bloc({required this.repository})
      : super(SupersaverModel3Initial()) {
    on<FetchSubCategoryProductsSS3>(_onFetchProducts);
    on<ClearsubcatSS3>(_onClearCache);
  }
  Future<void> _onFetchProducts(FetchSubCategoryProductsSS3 event,
      Emitter<SupersaverModel3State> emit) async {
    emit(SupersaverModel3Loading());

    // Check cache
    if (_cacheBoxCM4.containsKey(event.subCategoryId)) {
      final cachedData = _cacheBoxCM4.get(event.subCategoryId) as List<dynamic>;
      final cachedProducts = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      emit(SupersaverModel3Loaded(cachedProducts));
      return;
    }

    // Fetch from API
    try {
      final products =
          await repository.getProductsBySubCategory(event.subCategoryId);
      _cacheBoxCM4.put(
          event.subCategoryId, products.map((p) => p.toJson()).toList());
      emit(SupersaverModel3Loaded(products));
    } catch (e) {
      emit(SupersaverModel3Error(e.toString()));
    }
  }

  void _onClearCache(
      ClearsubcatSS3 event, Emitter<SupersaverModel3State> emit) async {
    try {
      // Open cache boxes
      var subcategoryproduct = await Hive.openBox('product_cache_category_SS3');

      // Clear the cache
      await subcategoryproduct.clear();

      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}
