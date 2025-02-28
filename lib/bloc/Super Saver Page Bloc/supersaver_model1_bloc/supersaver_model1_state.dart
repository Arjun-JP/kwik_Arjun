part of 'supersaver_model1_bloc.dart';

sealed class SupersaverModel1BlocState extends Equatable {
  const SupersaverModel1BlocState();
  
  @override
  List<Object> get props => [];
}

final class SupersaverModel1BlocInitial extends SupersaverModel1BlocState {}
class SupersaverModel1Loading extends SupersaverModel1BlocState {}

class SupersaverModel1Loaded extends SupersaverModel1BlocState {
  final Category category;
  final List<SubCategoryModel> subCategories;

  const SupersaverModel1Loaded({required this.category, required this.subCategories});

  @override
  List<Object> get props => [category, subCategories];
}


class SupersaverModel1Error extends SupersaverModel1BlocState {
  final String message;

  const SupersaverModel1Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends SupersaverModel1BlocState {} 

class CacheClearError extends SupersaverModel1BlocState {
  final String message;

  const CacheClearError(this.message);
}
