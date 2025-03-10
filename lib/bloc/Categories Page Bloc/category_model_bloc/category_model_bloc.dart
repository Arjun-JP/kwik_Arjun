import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwik/bloc/Categories%20Page%20Bloc/category_model_bloc/category_model_event.dart';
import 'package:kwik/bloc/Categories%20Page%20Bloc/category_model_bloc/category_model_state.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import '../../../repositories/category_model1_repository.dart';

class CategoryBlocModel extends Bloc<CategoryModelEvent, CategoryModelState> {
  final CategoryRepositoryModel1 categoryRepositoryModel1;

  CategoryBlocModel({required this.categoryRepositoryModel1})
      : super(CategoryInitial()) {
    on<FetchCategoryDetails>(_onFetchCategoryDetails);
    on<ClearCacheCM>(_onClearCache);
  }

  void _onFetchCategoryDetails(
      FetchCategoryDetails event, Emitter<CategoryModelState> emit) async {
    try {
      emit(CategoryLoading());

      // Open boxes for cache
      var categoryBox = await Hive.openBox('All_category_box');
      var subCategoryBox = await Hive.openBox('all_subcategory_box');

      List<Category>? cachedCategories;
      List<SubCategoryModel>? cachedSubCategories;

      // Check cache first
      if (categoryBox.containsKey("All_category_box")) {
        List<dynamic> cachedList =
            jsonDecode(categoryBox.get("All_category_box"));
        cachedCategories = cachedList.map((e) => Category.fromJson(e)).toList();
      }

      if (subCategoryBox.containsKey("all_subcategory_box")) {
        List<dynamic> cachedList =
            jsonDecode(subCategoryBox.get("all_subcategory_box"));
        cachedSubCategories =
            cachedList.map((e) => SubCategoryModel.fromJson(e)).toList();
      }

      if (cachedCategories != null && cachedSubCategories != null) {
        // If both categories and subcategories are in cache, emit the loaded state
        emit(CategoryLoaded(
            category: cachedCategories, subCategories: cachedSubCategories));
      } else {
        // If not in cache, fetch from API
        final categories =
            await categoryRepositoryModel1.fetchCategoryDetails();
        final subCategories = await categoryRepositoryModel1
            .fetchSubCategories("All_category_box");

        // Cache the results
        categoryBox.put("All_category_box",
            jsonEncode(categories.map((e) => e.toJson()).toList()));
        subCategoryBox.put("all_subcategory_box",
            jsonEncode(subCategories.map((e) => e.toJson()).toList()));

        emit(
            CategoryLoaded(category: categories, subCategories: subCategories));
      }
    } catch (e) {
      emit(CategoryError("Failed to load category details"));
    }
  }

  void _onClearCache(
      ClearCacheCM event, Emitter<CategoryModelState> emit) async {
    try {
      // Open cache boxes
      var categoryBox = await Hive.openBox('All_category_box');
      var subCategoryBox = await Hive.openBox('all_subcategory_box');

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
