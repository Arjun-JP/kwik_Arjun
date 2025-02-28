part of 'supersaver_model2_bloc.dart';

sealed class SupersaverModel2State extends Equatable {
  const SupersaverModel2State();
  
  @override
  List<Object> get props => [];
}

final class SupersaverModel2Initial extends SupersaverModel2State {}
class SupersaverModel2Loading extends SupersaverModel2State {}

class SupersaverModel2Loaded extends SupersaverModel2State {
  final List<ProductModel> products;

SupersaverModel2Loaded(this.products);

  @override
  List<Object> get props => [products];
}

class SupersaverModel2Error extends SupersaverModel2State {
  final String message;

 SupersaverModel2Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends SupersaverModel2State {} // State for cache cleared successfully

class CacheClearError extends SupersaverModel2State {
  final String message;

  CacheClearError(this.message);
}
