part of 'categories_ui_bloc.dart';

sealed class CategoriesUiState extends Equatable {
  const CategoriesUiState();

  @override
  List<Object> get props => [];
}

final class CategoriesUiInitial extends CategoriesUiState {}

class CatUiLoading extends CategoriesUiState {}

class CatUiLoaded extends CategoriesUiState {
  final Map<String, dynamic> uiData;

  CatUiLoaded({required this.uiData});

  @override
  List<Object> get props => [uiData];
}

class CatUiError extends CategoriesUiState {
  final String message;

  CatUiError({required this.message});

  @override
  List<Object> get props => [message];
}
