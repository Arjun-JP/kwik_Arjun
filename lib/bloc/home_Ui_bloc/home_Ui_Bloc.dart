import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_State.dart';
import 'package:kwik/repositories/home_Ui_repository.dart';

class HomeUiBloc extends Bloc<HomeUiEvent, HomeUiState> {
  final HomeUiRepository uiRepository;
  final List<String> searchSuggestions = [
    "chocolate",
    "ice cream",
    "cookies",
    "Vegitable",
    "coffee powder",
    "chocolate",
    "ice cream",
    "cookies",
    "Vegitable",
    "coffee powder",
    "chocolate",
    "ice cream",
    "cookies",
    "coffee powder",
    "chocolate",
    "ice cream",
    "cookies",
    "Vegitable",
    "coffee powder",
  ];
  var random = Random();

  static const String _cacheKey = 'ui_cache';

  HomeUiBloc({required this.uiRepository}) : super(UiInitial()) {
    on<FetchUiDataEvent>(_onFetchUiData);
    on<UpdateSearchTermEvent>(
        _onUpdateSearchTerm); // Fixed: Added event handler
    on<ClearUiCacheEvent>(_onClearCache);
  }

  Future<void> _onFetchUiData(
      FetchUiDataEvent event, Emitter<HomeUiState> emit) async {
    emit(UiLoading());

    try {
      var box = await Hive.openBox('ui_cache_box');

      if (!event.forceRefresh && box.containsKey(_cacheKey)) {
        final cachedData = Map<String, dynamic>.from(box.get(_cacheKey));
        emit(UiLoaded(
            uiData: cachedData,
            searchterm:
                searchSuggestions[random.nextInt(searchSuggestions.length)]));

        return;
      }

      final uiData = await uiRepository.fetchUiData();
      await box.put(_cacheKey, uiData);
      emit(UiLoaded(
          uiData: uiData,
          searchterm:
              searchSuggestions[random.nextInt(searchSuggestions.length)]));
    } catch (e) {
      emit(UiError(message: e.toString()));
    }
  }

  Future<void> _onClearCache(
      ClearUiCacheEvent event, Emitter<HomeUiState> emit) async {
    var box = await Hive.openBox('ui_cache_box');
    await box.delete(_cacheKey);
    emit(UiInitial());
  }

  Future<void> _onUpdateSearchTerm(
      UpdateSearchTermEvent event, Emitter<HomeUiState> emit) async {
    try {
      var box = await Hive.openBox('ui_cache_box');

      if (box.containsKey(_cacheKey)) {
        final cachedData = Map<String, dynamic>.from(box.get(_cacheKey));
        emit(UiLoaded(
            uiData: cachedData,
            searchterm:
                searchSuggestions[random.nextInt(searchSuggestions.length)]));

        return;
      }

      final uiData = await uiRepository.fetchUiData();
      await box.put(_cacheKey, uiData);
      emit(UiLoaded(
          uiData: uiData,
          searchterm:
              searchSuggestions[random.nextInt(searchSuggestions.length)]));
    } catch (e) {
      emit(UiError(message: e.toString()));
    }
  }
}
