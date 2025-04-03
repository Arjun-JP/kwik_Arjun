import 'package:hive/hive.dart';
import 'package:kwik/models/brand_model.dart';

class BrandAdapter extends TypeAdapter<Brand> {
  @override
  final int typeId = 10; // Ensure this typeId is unique

  @override
  Brand read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    try {
      return Brand(
        id: fields[0] as String,
        brandName: fields[1] as String,
        brandImage: fields[2] as String,
        brandDescription: fields[3] as String,
        brandUrl: fields[4] as String,
        createdTime: fields[5] as String, // Read createdTime as String
        color: fields[6] as String,
      );
    } catch (e) {
      print("Error reading Brand from Hive: $e");
      return Brand(
          //Return a default brand object in case of error.
          id: "",
          brandName: "",
          brandImage: "",
          brandDescription: "",
          brandUrl: "",
          createdTime: "", // Default createdTime as String
          color: "");
    }
  }

  @override
  void write(BinaryWriter writer, Brand obj) {
    try {
      writer
        ..writeByte(7) // Number of fields
        ..writeByte(0)
        ..write(obj.id)
        ..writeByte(1)
        ..write(obj.brandName)
        ..writeByte(2)
        ..write(obj.brandImage)
        ..writeByte(3)
        ..write(obj.brandDescription)
        ..writeByte(4)
        ..write(obj.brandUrl)
        ..writeByte(5)
        ..write(obj.createdTime) // Write createdTime as String
        ..writeByte(6)
        ..write(obj.color);
    } catch (e) {
      print("Error writing Brand to Hive: $e");
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
