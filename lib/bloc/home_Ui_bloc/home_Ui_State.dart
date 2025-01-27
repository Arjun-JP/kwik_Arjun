import 'package:equatable/equatable.dart';

abstract class HomeUiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UiInitial extends HomeUiState {}

class UiLoading extends HomeUiState {}

class UiLoaded extends HomeUiState {
  final Map<String, dynamic> uiData;

  UiLoaded({required this.uiData});

  @override
  List<Object?> get props => [uiData];
}

class UiError extends HomeUiState {
  final String message;

  UiError({required this.message});

  @override
  List<Object?> get props => [message];
}
