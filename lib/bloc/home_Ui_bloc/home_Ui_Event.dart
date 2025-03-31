import 'package:equatable/equatable.dart';

abstract class HomeUiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUiDataEvent extends HomeUiEvent {
  final bool forceRefresh;

  FetchUiDataEvent({this.forceRefresh = false});
}

class UpdateSearchTermEvent extends HomeUiEvent {
  final String searchTerm;
  UpdateSearchTermEvent(this.searchTerm);
}

class ClearUiCacheEvent extends HomeUiEvent {}
