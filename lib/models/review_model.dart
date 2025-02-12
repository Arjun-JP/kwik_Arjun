import 'package:hive/hive.dart';

part 'review_model.g.dart'; // The generated file from build_runner

@HiveType(typeId: 3) // Unique typeId for Review model
class ReviewModel {
  @HiveField(0)
  final String userRef;

  @HiveField(1)
  final String comment;

  @HiveField(2)
  final double rating;

  @HiveField(3)
  final DateTime createdTime;

  ReviewModel({
    required this.userRef,
    required this.comment,
    required this.rating,
    required this.createdTime,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userRef: json['user_ref'] ?? '',
      comment: json['comment'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      createdTime: DateTime.parse(
          json['created_time'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_ref': userRef,
      'comment': comment,
      'rating': rating,
      'created_time': createdTime.toIso8601String(),
    };
  }
}
