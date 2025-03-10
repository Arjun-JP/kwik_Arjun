import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_1_bloc/category_model1_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_1_bloc/category_model1_state.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/repositories/category_model_3_repo_home.dart';

import '../../../models/subcategory_model.dart';
import '../../../repositories/category_model1_repository.dart';

class CategoryBlocModel1 extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepositoryModel3Home categoryRepositoryModel1;

  CategoryBlocModel1({required this.categoryRepositoryModel1})
      : super(CategoryInitial()) {
    on<FetchCategoryDetails>(_onFetchCategoryDetails);
    on<ClearCache>(_onClearCache);
  }

  void _onFetchCategoryDetails(
      FetchCategoryDetails event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());

      // Open boxes for cache
      var categoryBox = await Hive.openBox('categorymodel1Cache');
      var subCategoryBox = await Hive.openBox('subCategorymodel1Cache');

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
        emit(CategoryLoaded(
            category: cachedCategory, subCategories: cachedSubCategories));
      } else {
        // If not in cache, fetch from API
        final category = await categoryRepositoryModel1
            .fetchCategoryDetails(event.categoryId);
        final subCategories =
            await categoryRepositoryModel1.fetchSubCategories(event.categoryId);

        // Cache the results
        categoryBox.put(event.categoryId, jsonEncode(category.toJson()));
        subCategoryBox.put(event.categoryId,
            jsonEncode(subCategories.map((e) => e.toJson()).toList()));

        emit(CategoryLoaded(category: category, subCategories: subCategories));
      }
    } catch (e) {
      emit(CategoryError("Failed to load category details"));
    }
  }

  void _onClearCache(ClearCache event, Emitter<CategoryState> emit) async {
    try {
      // Open cache boxes
      var categoryBox = await Hive.openBox('categorymodel1Cache');
      var subCategoryBox = await Hive.openBox('subCategorymodel1Cache');

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
