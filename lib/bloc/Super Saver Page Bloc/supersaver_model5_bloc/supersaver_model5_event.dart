part of 'supersaver_model5_bloc.dart';

sealed class SupersaverModel5Event extends Equatable {
  const SupersaverModel5Event();

  @override
  List<Object> get props => [];
}

class FetchCategoryAndProductsSS5Event extends SupersaverModel5Event {
  final List<String> subCategoryIds;

  const FetchCategoryAndProductsSS5Event({
    required this.subCategoryIds,
  });

  @override
  List<Object> get props => [subCategoryIds];
}

class ClearCacheSS5Event extends SupersaverModel5Event {}