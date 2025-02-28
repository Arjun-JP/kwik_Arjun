part of 'supersaver_model3_bloc.dart';

sealed class SupersaverModel3Event extends Equatable {
  const SupersaverModel3Event();

  @override
  List<Object> get props => [];
}

class FetchSubCategoryProductsSS3 extends SupersaverModel3Event {
  final String subCategoryId;

  FetchSubCategoryProductsSS3({required this.subCategoryId});

  @override
  List<Object> get props => [subCategoryId];
}

class ClearsubcatSS3 extends SupersaverModel3Event {}