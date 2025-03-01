part of 'categories_ui_bloc.dart';

sealed class CategoriesUiEvent extends Equatable {
  const CategoriesUiEvent();

  @override
  List<Object> get props => [];
}
class FetchCatUiDataEvent extends CategoriesUiEvent {
  final bool forceRefresh;

  FetchCatUiDataEvent({this.forceRefresh = false});
}

class ClearCatUiCacheEvent extends CategoriesUiEvent {}
