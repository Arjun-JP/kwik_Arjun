import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/repositories/offerzone_cat1_repo.dart';

part 'supersaver_model1_event.dart';
part 'supersaver_model1_state.dart';

class SupersaverModel1BlocBloc
    extends Bloc<SupersaverModel1BlocEvent, SupersaverModel1BlocState> {
  final OfferzoneCat1Repo offerzoneCat1Repo;
  SupersaverModel1BlocBloc({
    required this.offerzoneCat1Repo,
  }) : super(SupersaverModel1BlocInitial()) {
    on<FetchCategoryDetailsSuperSave1>(_onFetchCategoryDetails);
    on<ClearCacheSuperSave1>(_onClearCache);
  }
  void _onFetchCategoryDetails(FetchCategoryDetailsSuperSave1 event,
      Emitter<SupersaverModel1BlocState> emit) async {
    try {
      emit(SupersaverModel1Loading());

      // // Open boxes for cache
      // var categoryBox = await Hive.openBox('categoryPagemodel2Cache');
      // var subCategoryBox = await Hive.openBox('subCategoryPagemodel2Cache');

      // Category? cachedCategory;
      // List<SubCategoryModel>? cachedSubCategories;

      // // Check cache first
      // if (categoryBox.containsKey(event.categoryId)) {
      //   cachedCategory =
      //       Category.fromJson(jsonDecode(categoryBox.get(event.categoryId)));
      // }

      // if (subCategoryBox.containsKey(event.categoryId)) {
      //   List<dynamic> cachedList =
      //       jsonDecode(subCategoryBox.get(event.categoryId));
      //   cachedSubCategories =
      //       cachedList.map((e) => SubCategoryModel.fromJson(e)).toList();
      // }

      // if (cachedCategory != null && cachedSubCategories != null) {
      //   // If both category and subcategories are in cache, emit the loaded state
      //   emit(SupersaverModel1Loaded(
      //       category: cachedCategory, subCategories: cachedSubCategories));
      // } else {
      // If not in cache, fetch from API
      final category =
          await offerzoneCat1Repo.fetchCategoryDetails(event.categoryId);
      final subCategories =
          await offerzoneCat1Repo.fetchSubCategories(event.categoryId);

      // Cache the results
      // categoryBox.put(event.categoryId, jsonEncode(category.toJson()));
      // subCategoryBox.put(event.categoryId,
      //     jsonEncode(subCategories.map((e) => e.toJson()).toList()));

      emit(SupersaverModel1Loaded(
          category: category, subCategories: subCategories));
      // }
    } catch (e) {
      emit(const SupersaverModel1Error("Failed to load category details"));
    }
  }

  void _onClearCache(ClearCacheSuperSave1 event,
      Emitter<SupersaverModel1BlocState> emit) async {
    try {
      // Open cache boxes
      // var categoryBox = await Hive.openBox('categoryPagemodel2Cache');
      // var subCategoryBox = await Hive.openBox('subCategoryPagemodel2Cache');

      // // Clear the cache
      // await categoryBox.clear();
      // await subCategoryBox.clear();

      emit(CacheCleared()); // Emit the cache cleared state
    } catch (e) {
      emit(CacheClearError("Failed to clear cache: $e"));
    }
  }
}
