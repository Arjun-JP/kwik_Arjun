part of 'supersaver_model1_bloc.dart';

sealed class SupersaverModel1BlocEvent extends Equatable {
  const SupersaverModel1BlocEvent();

  @override
  List<Object> get props => [];
}
class FetchCategoryDetailsSuperSave1 extends SupersaverModel1BlocEvent {
  final String categoryId;

  const FetchCategoryDetailsSuperSave1(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
class ClearCacheSuperSave1 extends SupersaverModel1BlocEvent {}