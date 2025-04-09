// bloc/policy_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_event.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_state.dart';
import 'package:kwik/repositories/get_app_data_repo.dart';

class GetAppdataBloc extends Bloc<GetAppdataEvent, GetAppdataState> {
  final GetAppDataRepo appDataRepo;

  GetAppdataBloc(this.appDataRepo) : super(Getappdatainitial()) {
    on<Loadappdata>(_onLoadappdata);
  }

  Future<void> _onLoadappdata(
      Loadappdata event, Emitter<GetAppdataState> emit) async {
    emit(GetappdataLoading());
    try {
      final content = await appDataRepo.getappdata();
      emit(GetappdataLoaded(content));
    } catch (e) {
      emit(GetappdataError(e.toString()));
    }
  }
}
