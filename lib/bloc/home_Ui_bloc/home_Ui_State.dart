import 'package:equatable/equatable.dart';

abstract class HomeUiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UiInitial extends HomeUiState {}

class UiLoading extends HomeUiState {}

class UiLoaded extends HomeUiState {
  final Map<String, dynamic> uiData;
  final String searchterm;

  UiLoaded({required this.searchterm, required this.uiData});

  @override
  List<Object?> get props => [uiData, searchterm];
  UiLoaded copyWith({Map<String, dynamic>? uiData, String? searchterm}) {
    return UiLoaded(
      uiData: uiData ?? this.uiData,
      searchterm: searchterm ?? this.searchterm,
    );
  }
}

class UiError extends HomeUiState {
  final String message;

  UiError({required this.message});

  @override
  List<Object?> get props => [message];
}
