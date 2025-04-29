import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kwik/repositories/categories_page_ui_repository.dart';

part 'categories_ui_event.dart';
part 'categories_ui_state.dart';

class CategoriesUiBloc extends Bloc<CategoriesUiEvent, CategoriesUiState> {
  final CategoriesPageUiRepository catUiRepository;
  static const String _cacheKey = 'cat_ui_cache';
  CategoriesUiBloc({required this.catUiRepository})
      : super(CategoriesUiInitial()) {
    on<FetchCatUiDataEvent>(_onFetchUiData);
    on<ClearCatUiCacheEvent>(_onClearCache);
  }

  Future<void> _onFetchUiData(
      FetchCatUiDataEvent event, Emitter<CategoriesUiState> emit) async {
    emit(CatUiLoading());
    try {
      var box = await Hive.openBox('cat_ui_cache_box');

      // Load from cache if available & no force refresh
      if (!event.forceRefresh && box.containsKey(_cacheKey)) {
        final cachedData = Map<String, dynamic>.from(box.get(_cacheKey));

        emit(CatUiLoaded(uiData: cachedData));
        return;
      }

      // Fetch from API
      final uiData = await catUiRepository.fetchUiData();
      await box.put(_cacheKey, uiData); // Save to cache
      emit(CatUiLoaded(uiData: uiData));
    } catch (e) {
      emit(CatUiError(message: e.toString()));
    }
  }

  Future<void> _onClearCache(
      ClearCatUiCacheEvent event, Emitter<CategoriesUiState> emit) async {
    var box = await Hive.openBox('cat_ui_cache_box');
    await box.delete(_cacheKey);
    await catUiRepository.clearCache();
    emit(CategoriesUiInitial()); // Reset state
  }
}
