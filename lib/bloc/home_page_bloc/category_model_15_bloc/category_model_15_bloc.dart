import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_15_bloc/category_model_15_event.dart';
import 'package:kwik/repositories/category_model_12_repo.dart';
import 'category_model_15_state.dart';

class CategoryBloc15 extends Bloc<CategoryModel15Event, CategoryModel15State> {
  final Categorymodel12Repository categoryRepository;

  late Box _cachedProductsBox;
  bool _isHiveInitialized =
      false; // Flag to ensure Hive is initialized only once

  CategoryBloc15({required this.categoryRepository})
      : super(SubCategoriesInitial()) {
    on<FetchCategoryAndProductsEvent>(_onFetchCategoryAndProducts);
    on<ClearCacheEventCM15>(_onClearCache);
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    if (!_isHiveInitialized) {
      _cachedProductsBox = await Hive.openBox('productsBoxcatmodel15');
      _isHiveInitialized = true;
    }
  }

  Future<void> _onFetchCategoryAndProducts(FetchCategoryAndProductsEvent event,
      Emitter<CategoryModel15State> emit) async {
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
      ClearCacheEventCM15 event, Emitter<CategoryModel15State> emit) async {
    await _initializeHive(); // Ensure Hive is initialized before clearing cache

    try {
      await _cachedProductsBox.clear();
      emit(CacheClearedCM15());
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to clear cache: $e'));
    }
  }
}
