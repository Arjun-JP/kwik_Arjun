import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/repositories/category_model9_repo.dart';

import 'category_model_9_event.dart';
import 'category_model_9_state.dart';

class CategoryBloc9 extends Bloc<CategoryModel9Event, CategoryModel9State> {
  final Categorymodel9Repository categoryRepository;

  late Box _cachedProductsBox;
  bool _isHiveInitialized =
      false; // Flag to ensure Hive is initialized only once

  CategoryBloc9({required this.categoryRepository})
      : super(SubCategoriesInitial()) {
    on<FetchCategoryAndProductsEvent>(_onFetchCategoryAndProducts);
    on<ClearCacheEventCM9>(_onClearCache);
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    if (!_isHiveInitialized) {
      _cachedProductsBox = await Hive.openBox('productsBoxcatmodel9');
      _isHiveInitialized = true;
    }
  }

  Future<void> _onFetchCategoryAndProducts(FetchCategoryAndProductsEvent event,
      Emitter<CategoryModel9State> emit) async {
    await _initializeHive(); // Ensure Hive is initialized before accessing boxes
    emit(SubCategoriesLoading());

    try {
      final products = await categoryRepository
          .fetchProductsFromSubCategories(event.subCategoryIds);

      _cachedProductsBox.put(event.subCategoryIds.toString(), products);

      emit(CategoryLoadedState(
        products: products,
      ));
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to fetch data: $e'));
    }
  }

  Future<void> _onClearCache(
      ClearCacheEventCM9 event, Emitter<CategoryModel9State> emit) async {
    await _initializeHive(); // Ensure Hive is initialized before clearing cache

    try {
      await _cachedProductsBox.clear();
      emit(CacheCleared());
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to clear cache: $e'));
    }
  }
}
