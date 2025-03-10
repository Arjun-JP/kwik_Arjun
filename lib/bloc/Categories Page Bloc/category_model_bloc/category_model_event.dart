import 'package:equatable/equatable.dart';

abstract class CategoryModelEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCategoryDetails extends CategoryModelEvent {
  FetchCategoryDetails();

  @override
  List<Object> get props => [];
}

class ClearCacheCM extends CategoryModelEvent {}
