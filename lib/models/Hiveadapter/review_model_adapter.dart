import 'package:hive/hive.dart';
import '../review_model.dart';

class ReviewModelAdapter extends TypeAdapter<ReviewModel> {
  @override
  final typeId = 3; // Ensure this typeId is unique

  @override
  ReviewModel read(BinaryReader reader) {
    final userRef = reader.readString();
    final comment = reader.readString();
    final rating = reader.readDouble();
    final createdTime =
        DateTime.parse(reader.readString()); // Read as string and parse

    return ReviewModel(
      userRef: userRef,
      comment: comment,
      rating: rating,
      createdTime: createdTime,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewModel obj) {
    writer.writeString(obj.userRef);
    writer.writeString(obj.comment);
    writer.writeDouble(obj.rating);
    writer.writeString(
        obj.createdTime.toIso8601String()); // Write DateTime as string
  }
}
