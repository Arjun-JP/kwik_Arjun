part of 'supersaver_model2_bloc.dart';

sealed class SupersaverModel2Event extends Equatable {
  const SupersaverModel2Event();

  @override
  List<Object> get props => [];
}

class FetchSubCategoryProductsSS extends SupersaverModel2Event {
  final String subCategoryId;

  FetchSubCategoryProductsSS({required this.subCategoryId});

  @override
  List<Object> get props => [subCategoryId];
}

class ClearsubcatSS extends SupersaverModel2Event {}