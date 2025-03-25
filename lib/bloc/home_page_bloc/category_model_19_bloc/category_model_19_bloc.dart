import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_19_bloc/category_model_19_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_19_bloc/category_model_19_state.dart';
import '../../../repositories/category_subcategory_product_repo.dart';

class CategoryBloc19 extends Bloc<CategoryModel19Event, CategoryModel19State> {
  final Categorymodel5Repository categoryRepository;
  late Box _cachedSubCategoriesBox;
  late Box _cachedProductsBox;
  bool _isHiveInitialized =
      false; // Flag to ensure Hive is initialized only once

  CategoryBloc19({required this.categoryRepository})
      : super(SubCategoriesInitial()) {
    on<FetchCategoryAndProductsEventCM19>(_onFetchCategoryAndProducts);
    on<ClearCacheEventCM19>(_onClearCache);
    _initializeHive();
    on<UpdateSelectedCategoryModel19Event>((event, emit) {
      final currentState = state;
      if (currentState is CategoryLoadedState) {
        emit(currentState.copyWith(
            selectedCategoryId: event.selectedCategoryId));
      }
    }); // Initialize Hive when the bloc is created
  }

  Future<void> _initializeHive() async {
    if (!_isHiveInitialized) {
      _cachedSubCategoriesBox = await Hive.openBox('subCategoriesBoxCM19');
      _cachedProductsBox = await Hive.openBox('productsBoxCM19');
      _isHiveInitialized = true;
    }
  }

  Future<void> _onFetchCategoryAndProducts(
      FetchCategoryAndProductsEventCM19 event,
      Emitter<CategoryModel19State> emit) async {
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
              .toList(),
          products: products,
          selectedCategoryId: subCategories.first.id));
    } catch (e) {
      emit(CategoryErrorState(message: 'Failed to fetch data: $e'));
    }
  }

  Future<void> _onClearCache(
      ClearCacheEventCM19 event, Emitter<CategoryModel19State> emit) async {
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
