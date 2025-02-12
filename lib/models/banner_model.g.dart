// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BannerModelAdapter extends TypeAdapter<BannerModel> {
  @override
  final int typeId = 0;

  @override
  BannerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BannerModel(
      id: fields[0] as String,
      bannerId: fields[1] as int,
      bannerImage: fields[2] as String,
      categoryRef: fields[3] as CategoryRef,
      subCategoryRef: fields[4] as String?,
      orderId: fields[5] as int,
      createdTime: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BannerModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bannerId)
      ..writeByte(2)
      ..write(obj.bannerImage)
      ..writeByte(3)
      ..write(obj.categoryRef)
      ..writeByte(4)
      ..write(obj.subCategoryRef)
      ..writeByte(5)
      ..write(obj.orderId)
      ..writeByte(6)
      ..write(obj.createdTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryRefAdapter extends TypeAdapter<CategoryRef> {
  @override
  final int typeId = 1;

  @override
  CategoryRef read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryRef(
      id: fields[0] as String,
      categoryId: fields[1] as String,
      categoryName: fields[2] as String,
      categoryDescription: fields[3] as String,
      categoryImage: fields[4] as String,
      createdTime: fields[5] as DateTime,
      color: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryRef obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.categoryName)
      ..writeByte(3)
      ..write(obj.categoryDescription)
      ..writeByte(4)
      ..write(obj.categoryImage)
      ..writeByte(5)
      ..write(obj.createdTime)
      ..writeByte(6)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryRefAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
