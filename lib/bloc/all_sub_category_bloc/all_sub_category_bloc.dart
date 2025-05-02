import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_event.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_state.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/allsubcategory_repo.dart';

class AllSubCategoryBloc
    extends Bloc<AllSubCategoryEvent, AllSubCategoryState> {
  final AllsubcategoryRepo repository;
  late Box<String> subCategoryBox;
  late Box<String> productBox;

  AllSubCategoryBloc({required this.repository}) : super(CategoryInitial()) {
    _initializeHiveBoxes(); // Ensure Hive boxes are initialized

    on<LoadSubCategories>(_onLoadSubCategories);
    on<SelectSubCategory>(_onSelectSubCategory);
    on<ClearAllCategoryCache>(_onClearCache);
  }

  /// **Initialize Hive boxes safely**
  Future<void> _initializeHiveBoxes() async {
    if (!Hive.isBoxOpen('subCategoriesallcategorypage')) {
    
      subCategoryBox =
          await Hive.openBox<String>('subCategoriesallcategorypage');
    } else {

      subCategoryBox = Hive.box<String>('subCategoriesallcategorypage');


    }

    if (!Hive.isBoxOpen('productsallsubcategorypage')) {
      productBox = await Hive.openBox<String>('productsallsubcategorypage');
    } else {
      productBox = Hive.box<String>('productsallsubcategorypage');
    }
  }

  /// **Load all subcategories and products initially with Hive caching**
  Future<void> _onLoadSubCategories(
      LoadSubCategories event, Emitter<AllSubCategoryState> emit) async {
    
    await _initializeHiveBoxes(); // Ensure boxes are open

    String categoryKey = event.categoryId; // Use category ID as the cache key

    if (subCategoryBox.containsKey(categoryKey) &&
        productBox.containsKey(categoryKey)) {
      List<SubCategoryModel> cachedSubCategories =
          (jsonDecode(subCategoryBox.get(categoryKey)!) as List)
              .map((data) => SubCategoryModel.fromJson(data))
              .toList();


      List<ProductModel> cachedProducts =
          (jsonDecode(productBox.get(categoryKey)!) as List)
              .map((data) => ProductModel.fromJson(data))
              .toList();
   
      if (cachedSubCategories.isNotEmpty) {
        final defaultSubCategory =
            event.selectedsubcategoryId ?? cachedSubCategories.first.id;

        final filteredProducts = cachedProducts
            .where((product) => product.subCategoryRef
                .any((sub) => sub.id == defaultSubCategory))
            .toList();
    
        emit(CategoryLoaded(
          subCategories: cachedSubCategories,
          selectedSubCategory: defaultSubCategory,
          products: filteredProducts,
        ));
        return;
      }
    }

    emit(CategoryLoading());
    try {
      final subCategories =
          await repository.fetchSubCategories(event.categoryId);
      final products = await repository.fetchProductsFromSubCategories(
          subCategories.map((sub) => sub.id).toList());

      // Save fetched data to Hive cache (store as JSON strings)
      subCategoryBox.put(categoryKey,
          jsonEncode(subCategories.map((sub) => sub.toJson()).toList()));
      productBox.put(
          categoryKey, jsonEncode(products.map((p) => p.toJson()).toList()));

      final defaultSubCategory =
          event.selectedsubcategoryId ?? subCategories.first.id;
      final filteredProducts = products
          .where((product) =>
              product.subCategoryRef.any((sub) => sub.id == defaultSubCategory))
          .toList();

      emit(CategoryLoaded(
        subCategories: subCategories,
        selectedSubCategory: defaultSubCategory,
        products: filteredProducts,
      ));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  /// **Filter products instead of fetching again**
  Future<void> _onSelectSubCategory(
      SelectSubCategory event, Emitter<AllSubCategoryState> emit) async {
    await _initializeHiveBoxes(); // Ensure boxes are open

    final currentState = state;
    if (currentState is CategoryLoaded) {
      String categoryKey = event.categoryID;

      List<ProductModel> cachedProducts =
          (jsonDecode(productBox.get(categoryKey)!) as List)
              .map((data) => ProductModel.fromJson(data))
              .toList();

      final filteredProducts = cachedProducts
          .where((product) => product.subCategoryRef
              .any((sub) => sub.id == event.subCategoryId))
          .toList();

      emit(currentState.copyWith(
        selectedSubCategory: event.subCategoryId,
        products: filteredProducts,
      ));
    }
  }

  /// **Clear cache and reset state**
  void _onClearCache(
      ClearAllCategoryCache event, Emitter<AllSubCategoryState> emit) async {
    await _initializeHiveBoxes(); // Ensure boxes are open before clearing
    subCategoryBox.clear();
    productBox.clear();
    emit(CategoryInitial());
  }
}
