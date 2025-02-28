part of 'supersaver_model6_bloc.dart';

sealed class SupersaverModel6Event extends Equatable {
  const SupersaverModel6Event();

  @override
  List<Object> get props => [];
}
class FetchSubCategoryProductsSS6 extends SupersaverModel6Event {
  final String subCategoryId;

  FetchSubCategoryProductsSS6(this.subCategoryId);

  @override
  List<Object> get props => [subCategoryId];
}

class ClearsubcatCacheSS6 extends SupersaverModel6Event {}
