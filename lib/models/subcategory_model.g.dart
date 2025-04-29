// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubCategoryModelAdapter extends TypeAdapter<SubCategoryModel> {
  @override
  final int typeId = 55;

  @override
  SubCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubCategoryModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      imageUrl: fields[3] as String,
      createdTime: fields[4] as DateTime,
      categoryRef: fields[5] as Category,
      isDeleted: fields[6] as bool,
      offerPercentage: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubCategoryModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.createdTime)
      ..writeByte(5)
      ..write(obj.categoryRef)
      ..writeByte(6)
      ..write(obj.isDeleted)
      ..writeByte(7)
      ..write(obj.offerPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
