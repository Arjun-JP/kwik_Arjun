import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Add_Review_bloc/add_review_event.dart';
import 'package:kwik/bloc/Add_Review_bloc/add_review_state.dart';
import 'package:kwik/repositories/add_review.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewBloc({required this.reviewRepository}) : super(ReviewInitial()) {
    on<AddReviewEvent>((event, emit) async {
      emit(ReviewLoadingState());

      try {
        await reviewRepository.addReview(review: event.review);
        emit(ReviewSuccessState());
      } catch (e) {
        emit(ReviewErrorState(message: e.toString()));
      }
    });
  }
}
