part of 'supersaver_model3_bloc.dart';

sealed class SupersaverModel3State extends Equatable {
  const SupersaverModel3State();
  
  @override
  List<Object> get props => [];
}

final class SupersaverModel3Initial extends SupersaverModel3State {}
class SupersaverModel3Loading extends SupersaverModel3State {}

class SupersaverModel3Loaded extends SupersaverModel3State {
  final List<ProductModel> products;

  SupersaverModel3Loaded(this.products);

  @override
  List<Object> get props => [products];
}

class SupersaverModel3Error extends SupersaverModel3State {
  final String message;

  SupersaverModel3Error(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared
    extends SupersaverModel3State {} // State for cache cleared successfully

class CacheClearError extends SupersaverModel3State {
  final String message;

  CacheClearError(this.message);
}
