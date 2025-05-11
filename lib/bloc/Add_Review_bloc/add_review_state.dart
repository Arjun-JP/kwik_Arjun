abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoadingState extends ReviewState {}

class ReviewSuccessState extends ReviewState {}

class ReviewErrorState extends ReviewState {
  final String message;

  ReviewErrorState({required this.message});
}
