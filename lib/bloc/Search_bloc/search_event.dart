import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchProducts extends SearchEvent {
  final String query;
  final String userId;

  SearchProducts(this.query, this.userId);
}

class LoadInitialProducts extends SearchEvent {}

class ClearCachesearch extends SearchEvent {}

class Clearsearchhistory extends SearchEvent {}
