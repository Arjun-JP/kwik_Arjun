import 'package:equatable/equatable.dart';

abstract class SuperSaverUiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UiInitial extends SuperSaverUiState {}

class UiLoading extends SuperSaverUiState {}

class UiLoaded extends SuperSaverUiState {
  final Map<String, dynamic> uiData;

  UiLoaded({required this.uiData});

  @override
  List<Object?> get props => [uiData];
}

class UiError extends SuperSaverUiState {
  final String message;

  UiError({required this.message});

  @override
  List<Object?> get props => [message];
}
