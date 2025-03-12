import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/category_landing_page_bloc/category_landing_page__state.dart';
import 'package:kwik/bloc/category_landing_page_bloc/category_landing_page_event.dart';
import 'package:kwik/repositories/category_landing_page_repo.dart';

class CategoryLandingpageBloc
    extends Bloc<CategoryLandingpageEvent, CategorylandingpageState> {
  final CategoryLandingPageRepo categoryRepository;
  late Box _cachedSubCategoriesBox;
  late Box _cachedProductsBox;
  bool _isHiveInitialized =
      false; // Flag to ensure Hive is initialized only once

  CategoryLandingpageBloc({required this.categoryRepository})
      : super(SubCategoriesInitial()) {
    on<FetchCategoryAndProductsEventcategorylandiongpage>(
        _onFetchCategoryAndProducts);
    on<ClearCacheEventCLP>(_onClearCache);
    _initializeHive();
    on<UpdateSelectedCategoryLandingpageEvent>((event, emit) {
      final currentState = state;
      if (currentState is CategoryLoadedState) {
        emit(currentState.copyWith(
            selectedCategoryId: event.selectedCategoryId));
      }
    }); // Initialize Hive when the bloc is created
  }

  Future<void> _initializeHive() async {
    if (!_isHiveInitialized) {
      _cachedSubCategoriesBox =
          await Hive.openBox('subCategoriesBoxcategorylanding');
      _cachedProductsBox = await Hive.openBox('productsBoxcategorylanding');
      _isHiveInitialized = true;
    }
  }

  Future<void> _onFetchCategoryAndProducts(
      FetchCategoryAndProductsEventcategorylandiongpage event,
      Emitter<CategorylandingpageState> emit) async {
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
          subCategories: subCategories
              .where((subCategory) =>
                  event.subCategoryIds.contains(subCategory.id))
              .toSet()
              .toList(),
          products: products,
          selectedCategoryId: subCategories.first.id));
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to fetch data: $e'));
    }
  }

  Future<void> _onClearCache(
      ClearCacheEventCLP event, Emitter<CategorylandingpageState> emit) async {
    await _initializeHive(); // Ensure Hive is initialized before clearing cache

    try {
      await _cachedSubCategoriesBox.clear();
      await _cachedProductsBox.clear();
      emit(CacheClearedCLP());
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to clear cache: $e'));
    }
  }
}
