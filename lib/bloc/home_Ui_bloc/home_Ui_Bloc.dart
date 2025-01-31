import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_State.dart';

import 'package:kwik/repositories/home_Ui_repository.dart';

class HomeUiBloc extends Bloc<HomeUiEvent, HomeUiState> {
  final HomeUiRepository uiRepository;
  static const String _cacheKey = 'ui_cache';

  HomeUiBloc({required this.uiRepository}) : super(UiInitial()) {
    on<FetchUiDataEvent>(_onFetchUiData);
    on<ClearUiCacheEvent>(_onClearCache);
  }

  Future<void> _onFetchUiData(
      FetchUiDataEvent event, Emitter<HomeUiState> emit) async {
    emit(UiLoading());
    try {
      var box = await Hive.openBox('ui_cache_box');

      // Load from cache if available & no force refresh
      if (!event.forceRefresh && box.containsKey(_cacheKey)) {
        final cachedData = Map<String, dynamic>.from(box.get(_cacheKey));

        emit(UiLoaded(uiData: cachedData));
        return;
      }

      // Fetch from API
      final uiData = await uiRepository.fetchUiData();
      await box.put(_cacheKey, uiData); // Save to cache
      emit(UiLoaded(uiData: uiData));
    } catch (e) {
      emit(UiError(message: e.toString()));
    }
  }

  Future<void> _onClearCache(
      ClearUiCacheEvent event, Emitter<HomeUiState> emit) async {
    var box = await Hive.openBox('ui_cache_box');
    await box.delete(_cacheKey);
    emit(UiInitial()); // Reset state
  }
}
