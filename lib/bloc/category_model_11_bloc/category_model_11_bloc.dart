import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwik/bloc/category_model_11_bloc/category_model_11_state.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/repositories/category_model2_repository.dart';

import '../../models/subcategory_model.dart';
import 'category_model_11_event.dart';

class CategoryBlocModel11
    extends Bloc<CategoryModel11Event, CategoryModel11State> {
  final CategoryRepositoryModel2 categoryRepositoryModel2;

  CategoryBlocModel11({required this.categoryRepositoryModel2})
      : super(CategoryModel11Initial()) {
    on<FetchCategoryDetails>(_onFetchCategoryDetails);
    on<ClearCacheCM11>(_onClearCache);
  }

  void _onFetchCategoryDetails(
      FetchCategoryDetails event, Emitter<CategoryModel11State> emit) async {
    try {
      emit(CategoryModel11Loading());

      // Open boxes for cache
      var categoryBox = await Hive.openBox('categorymodel2Cache');
      var subCategoryBox = await Hive.openBox('subCategorymodel2Cache');

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
        emit(CategoryModel11Loaded(
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

        emit(CategoryModel11Loaded(
            category: category, subCategories: subCategories));
      }
    } catch (e) {
      emit(CategoryModel11Error("Failed to load category details"));
    }
  }

  void _onClearCache(
      ClearCacheCM11 event, Emitter<CategoryModel11State> emit) async {
    try {
      // Open cache boxes
      var categoryBox = await Hive.openBox('categorymodel2Cache');
      var subCategoryBox = await Hive.openBox('subCategorymodel2Cache');

      // Clear the cache
      await categoryBox.clear();
      await subCategoryBox.clear();
      print("Cache cleared");
      emit(ClearCacheredCM11()); // Emit the cache cleared state
    } catch (e) {
      print("Error clearing cache: $e");
      emit(CacheClearErrorCM11("Failed to clear cache: $e"));
    }
  }
}
