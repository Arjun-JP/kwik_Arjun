import 'package:equatable/equatable.dart';

abstract class HomeUiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUiDataEvent extends HomeUiEvent {}
