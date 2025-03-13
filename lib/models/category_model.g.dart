// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 11;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      catref: fields[0] as String,
      id: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      imageUrl: fields[4] as String,
      color: fields[5] as String,
      bannerImage: fields[8] as String,
      isDeleted: fields[9] as bool,
      selectedSubCategoryRef: (fields[10] as List?)?.cast<dynamic>(),
      islandingPage: fields[11] as bool?,
      visibility: fields[6] as bool?,
      createdTime: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.catref)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.visibility)
      ..writeByte(7)
      ..write(obj.createdTime)
      ..writeByte(8)
      ..write(obj.bannerImage)
      ..writeByte(9)
      ..write(obj.isDeleted)
      ..writeByte(10)
      ..write(obj.selectedSubCategoryRef)
      ..writeByte(11)
      ..write(obj.islandingPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
