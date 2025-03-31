import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/category_model2_repository.dart';

part 'categories_page_model10_event.dart';
part 'categories_page_model10_state.dart';

class CategoriesPageModel10Bloc
    extends Bloc<CategoriesPageModel10Event, CategoriesPageModel10State> {
  final CategoryRepositoryModel2 categoryRepositoryModel2;
  CategoriesPageModel10Bloc({required this.categoryRepositoryModel2})
      : super(CategoriesPageModel10Initial()) {
    on<FetchCategoryDetailsModel10>(_onFetchCategoryDetails);
    on<ClearCacheCatPage10>(_onClearCache);
  }
  void _onFetchCategoryDetails(FetchCategoryDetailsModel10 event,
      Emitter<CategoriesPageModel10State> emit) async {
    try {
      emit(CategoriesPageModel10Loading());

      // Open boxes for cache
      var categoryBox = await Hive.openBox('categoryPagemodel10Cache');
      var subCategoryBox = await Hive.openBox('subCategoryPagemodel10Cache');

      Category? cachedCategory;
      List<SubCategoryModel>? cachedSubCategories;

      // Check cache first
      if (categoryBox.containsKey(event.categoryId)) {
        cachedCategory =
            Category.fromJson(jsonDecode(categoryBox.get(event.categoryId)));
      }

      if (subCategoryBox.containsKey(event.categoryId)) {
        List<dynamic> cachedList =
            jsonDecode(subCategoryBox.get(event.categoryId));
        cachedSubCategories =
            cachedList.map((e) => SubCategoryModel.fromJson(e)).toList();
      }

      if (cachedCategory != null && cachedSubCategories != null) {
        // If both category and subcategories are in cache, emit the loaded state
        emit(CategoriesPageModel10Loaded(
            category: cachedCategory, subCategories: cachedSubCategories));
      } else {
        // If not in cache, fetch from API
        final category = await categoryRepositoryModel2
            .fetchCategoryDetails(event.categoryId);
        final subCategories =
            await categoryRepositoryModel2.fetchSubCategories(event.categoryId);

        // Cache the results
        categoryBox.put(event.categoryId, jsonEncode(category.toJson()));
        subCategoryBox.put(event.categoryId,
            jsonEncode(subCategories.map((e) => e.toJson()).toList()));

        emit(CategoriesPageModel10Loaded(
            category: category, subCategories: subCategories));
      }
    } catch (e) {
      emit(const CategoriesPageModel10Error("Failed to load category details"));
    }
  }

  void _onClearCache(ClearCacheCatPage10 event,
      Emitter<CategoriesPageModel10State> emit) async {
    try {
      // Open cache boxes
      var categoryBox = await Hive.openBox('categoryPagemodel10Cache');

      var subCategoryBox = await Hive.openBox('subCategoryPagemodel10Cache');

      // Clear the cache
      await categoryBox.clear();
      await subCategoryBox.clear();

      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}
