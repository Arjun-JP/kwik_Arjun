import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/category_model_13_bloc/category_model_13_event.dart';

import '../../repositories/category_subcategory_product_repo.dart';
import 'category_model_13_state.dart';

class CategoryBloc13 extends Bloc<CategoryModel13Event, CategoryModel13State> {
  final Categorymodel5Repository categoryRepository;
  late Box _cachedSubCategoriesBox;
  late Box _cachedProductsBox;
  bool _isHiveInitialized =
      false; // Flag to ensure Hive is initialized only once

  CategoryBloc13({required this.categoryRepository})
      : super(SubCategoriesInitial()) {
    on<FetchCategoryAndProductsEvent>(_onFetchCategoryAndProducts);
    on<ClearCacheEventCM13>(_onClearCache);
    _initializeHive();
    on<UpdateSelectedCategoryModel13Event>((event, emit) {
      final currentState = state;
      if (currentState is CategoryLoadedState) {
        emit(currentState.copyWith(
            selectedCategoryId: event.selectedCategoryId));
      }
    }); // Initialize Hive when the bloc is created
  }

  Future<void> _initializeHive() async {
    if (!_isHiveInitialized) {
      _cachedSubCategoriesBox = await Hive.openBox('subCategoriesBoxCM13');
      _cachedProductsBox = await Hive.openBox('productsBoxCM13');
      _isHiveInitialized = true;
    }
  }

  Future<void> _onFetchCategoryAndProducts(FetchCategoryAndProductsEvent event,
      Emitter<CategoryModel13State> emit) async {
    await _initializeHive(); // Ensure Hive is initialized before accessing boxes
    emit(SubCategoriesLoading());

    try {
      final subCategories =
          await categoryRepository.fetchSubCategories(event.categoryId);
      final products = await categoryRepository
          .fetchProductsFromSubCategories(event.subCategoryIds);

      // Cache the data
      _cachedSubCategoriesBox.put(event.categoryId, subCategories);
      _cachedProductsBox.put(event.subCategoryIds.toString(), products);

      emit(CategoryLoadedState(
          subCategories: subCategories,
          products: products,
          selectedCategoryId: subCategories.first.id));
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to fetch data: $e'));
    }
  }

  Future<void> _onClearCache(
      ClearCacheEventCM13 event, Emitter<CategoryModel13State> emit) async {
    await _initializeHive(); // Ensure Hive is initialized before clearing cache

    try {
      await _cachedSubCategoriesBox.clear();
      await _cachedProductsBox.clear();
      emit(CacheCleared());
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to clear cache: $e'));
    }
  }
}
