import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchProducts extends SearchEvent {
  final String query;
  final String userId;
  final int page;
  final int size;

  SearchProducts(this.query, this.userId, this.page, this.size);
}

class LoadInitialProducts extends SearchEvent {}

class ClearCachesearch extends SearchEvent {}
