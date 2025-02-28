part of 'supersaver_model4_bloc.dart';

sealed class SupersaverModel4Event extends Equatable {
  const SupersaverModel4Event();

  @override
  List<Object> get props => [];
}
class FetchSubCategoryProductsSS4 extends SupersaverModel4Event {
  final String subCategoryId;

  FetchSubCategoryProductsSS4(this.subCategoryId);

  @override
  List<Object> get props => [subCategoryId];
}

class ClearsubcatCacheSS4 extends SupersaverModel4Event {}