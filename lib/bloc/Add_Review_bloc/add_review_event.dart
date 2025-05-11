import 'package:kwik/models/review_model.dart';

abstract class ReviewEvent {}

class AddReviewEvent extends ReviewEvent {
  final List<Map<String, dynamic>> review;

  AddReviewEvent({required this.review});
}
