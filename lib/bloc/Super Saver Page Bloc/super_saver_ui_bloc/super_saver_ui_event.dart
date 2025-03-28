import 'package:equatable/equatable.dart';

abstract class SuperSaverUiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUiDataEvent extends SuperSaverUiEvent {
  final bool forceRefresh;

  FetchUiDataEvent({this.forceRefresh = false});
}

class ClearUiCacheEvent extends SuperSaverUiEvent {}
