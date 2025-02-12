// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrandAdapter extends TypeAdapter<Brand> {
  @override
  final int typeId = 10;

  @override
  Brand read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Brand(
      id: fields[0] as String,
      brandName: fields[1] as String,
      brandImage: fields[2] as String,
      brandDescription: fields[3] as String,
      brandUrl: fields[4] as String,
      createdTime: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Brand obj) {
    writer
      ..writeByte(6)
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
      ..write(obj.createdTime);
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
