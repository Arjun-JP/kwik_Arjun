import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/super_saver_ui_bloc/super_saver_ui_event.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/super_saver_ui_bloc/super_saver_ui_state.dart';
import 'package:kwik/repositories/super_saver_ui_repo.dart';

class SuperSaverUiBloc extends Bloc<SuperSaverUiEvent, SuperSaverUiState> {
  final SuperSaverRepository uiRepository;
  static const String _cacheKey = 'ui_cache';

  SuperSaverUiBloc({required this.uiRepository}) : super(UiInitial()) {
    on<FetchUiDataEvent>(_onFetchUiData);
    on<ClearUiCacheEvent>(_onClearCache);
  }

  Future<void> _onFetchUiData(
      FetchUiDataEvent event, Emitter<SuperSaverUiState> emit) async {
    emit(UiLoading());
    try {
      var box = await Hive.openBox('Supersaver_ui_cache_box');

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
      ClearUiCacheEvent event, Emitter<SuperSaverUiState> emit) async {
    var box = await Hive.openBox('Supersaver_ui_cache_box');
    await box.delete(_cacheKey);
    await uiRepository.clearCache();
    emit(UiInitial()); // Reset state
  }
}
