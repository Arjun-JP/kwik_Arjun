part of 'supersaver_model6_bloc.dart';

sealed class SupersaverModel6State extends Equatable {
  const SupersaverModel6State();
  
  @override
  List<Object> get props => [];
}

final class SupersaverModel6Initial extends SupersaverModel6State {}
class SupersaverModel6Loading extends SupersaverModel6State {}

class SupersaverModel6Loaded extends SupersaverModel6State {
  final List<ProductModel> products;

  SupersaverModel6Loaded(this.products);

  @override
  List<Object> get props => [products];
}

class SupersaverModel6Error extends SupersaverModel6State {
  final String message;

  SupersaverModel6Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends SupersaverModel6State {} // State for cache cleared successfully

class CacheClearError extends SupersaverModel6State {
  final String message;

  CacheClearError(this.message);
}
