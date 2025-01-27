import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_State.dart';
import 'package:kwik/repositories/home_Ui_repository.dart';

class HomeUiBloc extends Bloc<HomeUiEvent, HomeUiState> {
  final HomeUiRepository uiRepository;

  HomeUiBloc({required this.uiRepository}) : super(UiInitial()) {
    on<FetchUiDataEvent>(_onFetchUiData);
  }

  Future<void> _onFetchUiData(
      FetchUiDataEvent event, Emitter<HomeUiState> emit) async {
    emit(UiLoading());
    try {
      final uiData = await uiRepository.fetchUiData();
      emit(UiLoaded(uiData: uiData));
    } catch (e) {
      emit(UiError(message: e.toString()));
    }
  }
}
