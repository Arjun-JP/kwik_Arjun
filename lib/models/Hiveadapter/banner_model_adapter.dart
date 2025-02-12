import 'package:hive/hive.dart';
import '../banner_model.dart';

// BannerModel Adapter
class BannerModelAdapter extends TypeAdapter<BannerModel> {
  @override
  final typeId = 0; // Ensure this typeId is unique

  @override
  BannerModel read(BinaryReader reader) {
    final id = reader.readString();
    final bannerId = reader.readInt();
    final bannerImage = reader.readString();
    final categoryRef = reader.read() as CategoryRef; // Read CategoryRef
    final subCategoryRef = reader.readString();
    final orderId = reader.readInt();
    final createdTime = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return BannerModel(
      id: id,
      bannerId: bannerId,
      bannerImage: bannerImage,
      categoryRef: categoryRef,
      subCategoryRef: subCategoryRef,
      orderId: orderId,
      createdTime: createdTime,
    );
  }

  @override
  void write(BinaryWriter writer, BannerModel obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.bannerId);
    writer.writeString(obj.bannerImage);
    writer.write(obj.categoryRef); // Write CategoryRef
    writer.writeString(obj.subCategoryRef ?? '');
    writer.writeInt(obj.orderId);
    writer.writeInt(obj
        .createdTime.millisecondsSinceEpoch); // Convert DateTime to timestamp
  }
}

// CategoryRef Adapter
class CategoryRefAdapter extends TypeAdapter<CategoryRef> {
  @override
  final typeId = 1; // Ensure this typeId is unique

  @override
  CategoryRef read(BinaryReader reader) {
    final id = reader.readString();
    final categoryId = reader.readString();
    final categoryName = reader.readString();
    final categoryDescription = reader.readString();
    final categoryImage = reader.readString();
    final createdTime = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final color = reader.readString();

    return CategoryRef(
      id: id,
      categoryId: categoryId,
      categoryName: categoryName,
      categoryDescription: categoryDescription,
      categoryImage: categoryImage,
      createdTime: createdTime,
      color: color,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryRef obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.categoryId);
    writer.writeString(obj.categoryName);
    writer.writeString(obj.categoryDescription);
    writer.writeString(obj.categoryImage);
    writer.writeInt(obj
        .createdTime.millisecondsSinceEpoch); // Convert DateTime to timestamp
    writer.writeString(obj.color);
  }
}
