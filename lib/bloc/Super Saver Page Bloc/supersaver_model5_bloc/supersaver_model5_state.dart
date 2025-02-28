part of 'supersaver_model5_bloc.dart';

sealed class SupersaverModel5State extends Equatable {
  const SupersaverModel5State();
  
  @override
  List<Object> get props => [];
}

final class SupersaverModel5Initial extends SupersaverModel5State {}
class SupersaverModel5Loading extends SupersaverModel5State {}

class SupersaverModel5LoadedState extends SupersaverModel5State {
  final List<ProductModel> products;

  const SupersaverModel5LoadedState({
    required this.products,
  });

  @override
  List<Object> get props => [
        products,
      ];

  // Method to update selectedCategoryId without modifying data
  SupersaverModel5LoadedState copyWith() {
    return SupersaverModel5LoadedState(
      products: products,
    );
  }
}

class SupersaverModel5Error extends SupersaverModel5State {
  final String message;

  const SupersaverModel5Error(this.message);

  @override
  List<Object> get props => [message];
}

class SupersaverModel5ProductsLoading extends SupersaverModel5State {}

class SupersaverModel5ProductsLoaded extends SupersaverModel5State {
  final List<ProductModel> products;

  const SupersaverModel5ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class SupersaverModel5ProductsError extends SupersaverModel5State {
  final String message;

  const SupersaverModel5ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

class CacheCleared extends SupersaverModel5State {}

class CategoryErrorState extends SupersaverModel5State {
  final String message;
  CategoryErrorState({required this.message});
}
