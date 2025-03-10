import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/category_model1_repository.dart';

part 'categories_page_model8_event.dart';
part 'categories_page_model8_state.dart';

class CategoriesPageModel8Bloc
    extends Bloc<CategoriesPageModel8Event, CategoriesPageModel8State> {
  final CategoryRepositoryModel1 categoryRepositoryModel1;
  CategoriesPageModel8Bloc({required this.categoryRepositoryModel1})
      : super(CategoriesPageModel8Initial()) {
    on<FetchCategoryDetails>(_onFetchCategoryDetails);
    on<ClearCache>(_onClearCache);
  }
  void _onFetchCategoryDetails(FetchCategoryDetails event,
      Emitter<CategoriesPageModel8State> emit) async {
    try {
      emit(CategoryLoading());

      // Open boxes for cache
      var categoryBox = await Hive.openBox('categorymodel8Cache');
      var subCategoryBox = await Hive.openBox('subCategorymodel8Cache');

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
        final category = await categoryRepositoryModel1.fetchCategoryDetails();
        final subCategories =
            await categoryRepositoryModel1.fetchSubCategories(event.categoryId);

        // // Cache the results
        // categoryBox.put(event.categoryId, jsonEncode(category.toJson()));
        // subCategoryBox.put(event.categoryId,
        //     jsonEncode(subCategories.map((e) => e.toJson()).toList()));

        // emit(CategoryLoaded(category: category, subCategories: subCategories));
      }
    } catch (e) {
      emit(CategoryError("Failed to load category details"));
    }
  }

  void _onClearCache(
      ClearCache event, Emitter<CategoriesPageModel8State> emit) async {
    try {
      // Open cache boxes
      var categoryBox = await Hive.openBox('categorymodel8Cache');
      var subCategoryBox = await Hive.openBox('subCategorymodel8Cache');

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
