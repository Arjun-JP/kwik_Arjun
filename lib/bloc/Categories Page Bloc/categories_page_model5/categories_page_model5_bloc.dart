import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/category_subcategory_product_repo.dart';

part 'categories_page_model5_event.dart';
part 'categories_page_model5_state.dart';

class CategoriesPageModel5Bloc extends Bloc<CategoriesPageModel5Event, CategoriesPageModel5State> {
  final Categorymodel5Repository categoryRepository;
  late Box _cachedSubCategoriesBox;
  late Box _cachedProductsBox;
  bool _isHiveInitialized =
      false;
  CategoriesPageModel5Bloc({required this.categoryRepository}) : super(CategoriesPageModel5Initial()) {
   on<FetchCategoryAndProductsEvent>(_onFetchCategoryAndProducts);
    on<ClearCacheEventCM5>(_onClearCache);
    _initializeHive();
    on<UpdateSelectedCategoryEvent>((event, emit) {
      final currentState = state;
      if (currentState is CategoryLoadedState) {
        emit(currentState.copyWith(
            selectedCategoryId: event.selectedCategoryId));
      }
    }); 
  }
  Future<void> _initializeHive() async {
    if (!_isHiveInitialized) {
      _cachedSubCategoriesBox = await Hive.openBox('subCategoriesBoxCatPage');
      _cachedProductsBox = await Hive.openBox('productsBoxCatPage');
      _isHiveInitialized = true;
    }
  }

  Future<void> _onFetchCategoryAndProducts(
      FetchCategoryAndProductsEvent event, Emitter<CategoriesPageModel5State> emit) async {
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
      ClearCacheEventCM5 event, Emitter<CategoriesPageModel5State> emit) async {
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

