// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:hive_flutter/hive_flutter.dart';

import '../brand_model.dart';

class BrandAdapter extends TypeAdapter<Brand> {
  @override
  final int typeId = 10;

  @override
  Brand read(BinaryReader reader) {
    return Brand(
      id: reader.readString(),
      brandName: reader.readString(),
      brandImage: reader.readString(),
      brandDescription: reader.readString(),
      brandUrl: reader.readString(),
      createdTime: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Brand obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.brandName);
    writer.writeString(obj.brandImage);
    writer.writeString(obj.brandDescription);
    writer.writeString(obj.brandUrl);
    writer.writeString(obj.createdTime);
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
