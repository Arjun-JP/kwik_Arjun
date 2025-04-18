import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_6_bloc/category_model_6_event.dart';
import 'package:kwik/models/category_model.dart';
import '../../../models/subcategory_model.dart';
import '../../../repositories/category_model_6_repo.dart';
import 'category_model_6_state.dart';

class CategoryBlocModel6 extends Bloc<CategoryEvent6, CategoryState6> {
  final CategoryModel6Repo categoryModel6Repo;

  CategoryBlocModel6({required this.categoryModel6Repo})
      : super(CategoryInitial()) {
    on<FetchCategoryDetails>(_onFetchCategoryDetails);
    on<ClearCacheCM6>(_onClearCache);
  }

  void _onFetchCategoryDetails(
      FetchCategoryDetails event, Emitter<CategoryState6> emit) async {
    try {
      emit(CategoryLoading());

      // Open boxes for cache

      var subCategoryBox = await Hive.openBox('categorymodel6cache');

      Category? cachedCategory;
      List<SubCategoryModel>? cachedSubCategories;

      if (subCategoryBox.containsKey("categorymodel6cache")) {
        List<dynamic> cachedList =
            jsonDecode(subCategoryBox.get("categorymodel6cache"));
        cachedSubCategories =
            cachedList.map((e) => SubCategoryModel.fromJson(e)).toList();
      }

      if (cachedSubCategories != null) {
        // If both category and subcategories are in cache, emit the loaded state
        emit(CategoryLoaded(subCategories: cachedSubCategories));
      } else {
        final subCategories = await categoryModel6Repo.fetchAllSubCategories();

        // Cache the results

        subCategoryBox.put("categorymodel6cache",
            jsonEncode(subCategories.map((e) => e.toJson()).toList()));

        emit(CategoryLoaded(subCategories: subCategories));
      }
    } catch (e) {
      emit(CategoryError("Failed to load category details"));
    }
  }

  void _onClearCache(ClearCacheCM6 event, Emitter<CategoryState6> emit) async {
    try {
      // Open cache boxes

      var subCategoryBox = await Hive.openBox('categorymodel6cache');

      // Clear the cache

      await subCategoryBox.clear();

      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}
