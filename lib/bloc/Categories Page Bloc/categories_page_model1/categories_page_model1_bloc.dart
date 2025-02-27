import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/category_model2_repository.dart';

part 'categories_page_model1_event.dart';
part 'categories_page_model1_state.dart';

class CategoriesPageModel1Bloc extends Bloc<CategoriesPageModel1Event, CategoriesPageModel1State> {
 final CategoryRepositoryModel2 categoryRepositoryModel2;

  
   CategoriesPageModel1Bloc({required this.categoryRepositoryModel2})
      : super(CategoriesPageModel1Initial()) {
    on<FetchCategoryDetailsModel1>(_onFetchCategoryDetails);
    on<ClearCacheCatPage1>(_onClearCache);
  }
void _onFetchCategoryDetails(
      FetchCategoryDetailsModel1 event, Emitter<CategoriesPageModel1State> emit) async {
    try {
      emit(CategoriesPageModel1Loading());

      // Open boxes for cache
      var categoryBox = await Hive.openBox('categoryPagemodel1Cache');
      var subCategoryBox = await Hive.openBox('subCategoryPagemodel1Cache');

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
        emit(CategoriesPageModel1Loaded(
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

        emit(CategoriesPageModel1Loaded(category: category, subCategories: subCategories));
      }
    } catch (e) {
      emit(const CategoriesPageModel1Error("Failed to load category details"));
    }
  }

  void _onClearCache(ClearCacheCatPage1 event, Emitter<CategoriesPageModel1State> emit) async {
    try {
      // Open cache boxes
      var categoryBox = await Hive.openBox('categoryPagemodel1Cache');
      var subCategoryBox = await Hive.openBox('subCategoryPagemodel1Cache');

      // Clear the cache
      await categoryBox.clear();
      await subCategoryBox.clear();
      print("Cache cleared");
      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      print("Error clearing cache: $e");
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}

