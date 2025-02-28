part of 'supersaver_model4_bloc.dart';

sealed class SupersaverModel4State extends Equatable {
  const SupersaverModel4State();
  
  @override
  List<Object> get props => [];
}

final class SupersaverModel4Initial extends SupersaverModel4State {}
class SupersaverModel4Loading extends SupersaverModel4State {}

class SupersaverModel4Loaded extends SupersaverModel4State {
  final List<ProductModel> products;

  SupersaverModel4Loaded(this.products);

  @override
  List<Object> get props => [products];
}

class SupersaverModel4Error extends SupersaverModel4State {
  final String message;

  SupersaverModel4Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends SupersaverModel4State {} // State for cache cleared successfully

class CacheClearError extends SupersaverModel4State {
  final String message;

  CacheClearError(this.message);
}
