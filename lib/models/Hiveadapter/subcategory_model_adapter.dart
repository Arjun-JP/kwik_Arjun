import 'package:hive/hive.dart';
import 'package:kwik/models/category_model.dart';
import 'package:kwik/models/subcategory_model.dart';

class SubCategoryModelAdapter extends TypeAdapter<SubCategoryModel> {
  @override
  final typeId = 55; // Ensure this typeId matches the model

  @override
  SubCategoryModel read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final description = reader.readString();
    final imageUrl = reader.readString();
    final createdTime = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final categoryRef = CategoryAdapter().read(reader);
    final isDeleted = reader.readBool();
    final offerPercentage = reader.readString(); // New field

    return SubCategoryModel(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      createdTime: createdTime,
      categoryRef: categoryRef,
      isDeleted: isDeleted,
      offerPercentage: offerPercentage, // Added to constructor
    );
  }

  @override
  void write(BinaryWriter writer, SubCategoryModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.description);
    writer.writeString(obj.imageUrl);
    writer.writeInt(obj.createdTime.millisecondsSinceEpoch);
    CategoryAdapter().write(writer, obj.categoryRef);
    writer.writeBool(obj.isDeleted);
    writer.writeString(obj.offerPercentage); // New field
  }
}
