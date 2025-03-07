import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_12_bloc/category_model_12_event.dart';
import 'package:kwik/repositories/category_model_12_repo.dart';

import 'category_model_12_state.dart';

class CategoryBloc12 extends Bloc<CategoryModel12Event, CategoryModel12State> {
  final Categorymodel12Repository categoryRepository;

  late Box _cachedProductsBox;
  bool _isHiveInitialized =
      false; // Flag to ensure Hive is initialized only once

  CategoryBloc12({required this.categoryRepository})
      : super(SubCategoriesInitial()) {
    on<FetchCategoryAndProductsEvent>(_onFetchCategoryAndProducts);
    on<ClearCacheEventCM12>(_onClearCache);
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    if (!_isHiveInitialized) {
      _cachedProductsBox = await Hive.openBox('productsBoxcatmodel12');
      _isHiveInitialized = true;
    }
  }

  Future<void> _onFetchCategoryAndProducts(FetchCategoryAndProductsEvent event,
      Emitter<CategoryModel12State> emit) async {
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
      ClearCacheEventCM12 event, Emitter<CategoryModel12State> emit) async {
    await _initializeHive(); // Ensure Hive is initialized before clearing cache

    try {
      await _cachedProductsBox.clear();
      emit(CacheClearedCM12());
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to clear cache: $e'));
    }
  }
}
