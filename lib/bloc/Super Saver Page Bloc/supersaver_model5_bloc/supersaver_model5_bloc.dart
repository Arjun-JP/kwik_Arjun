import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/category_model9_repo.dart';

part 'supersaver_model5_event.dart';
part 'supersaver_model5_state.dart';

class SupersaverModel5Bloc extends Bloc<SupersaverModel5Event, SupersaverModel5State> {
    final Categorymodel9Repository categoryRepository;
   late Box _cachedProductsBox;
  bool _isHiveInitialized =
      false;
  SupersaverModel5Bloc({required this.categoryRepository}) : super(SupersaverModel5Initial()) {
     on<FetchCategoryAndProductsSS5Event>(_onFetchCategoryAndProducts);
    on<ClearCacheSS5Event>(_onClearCache);
    _initializeHive();
   
  }

 Future<void> _initializeHive() async {
    if (!_isHiveInitialized) {
      _cachedProductsBox = await Hive.openBox('productsBoxcatmodel9');
      _isHiveInitialized = true;
    }
  }

  Future<void> _onFetchCategoryAndProducts(FetchCategoryAndProductsSS5Event event,
      Emitter<SupersaverModel5State> emit) async {
    await _initializeHive(); // Ensure Hive is initialized before accessing boxes
    emit(SupersaverModel5Loading());

    try {
      final products = await categoryRepository
          .fetchProductsFromSubCategories(event.subCategoryIds);

      _cachedProductsBox.put(event.subCategoryIds.toString(), products);

      emit(SupersaverModel5LoadedState(
        products: products,
      ));
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to fetch data: $e'));
    }
  }

  Future<void> _onClearCache(
      ClearCacheSS5Event event, Emitter<SupersaverModel5State> emit) async {
    await _initializeHive(); // Ensure Hive is initialized before clearing cache

    try {
      await _cachedProductsBox.clear();
      emit(CacheCleared());
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to clear cache: $e'));
    }
  }
}
