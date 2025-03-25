// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VariationModelAdapter extends TypeAdapter<VariationModel> {
  @override
  final int typeId = 6;

  @override
  VariationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VariationModel(
      qty: fields[0] as int,
      unit: fields[1] as String,
      mrp: fields[2] as double,
      buyingPrice: fields[3] as double,
      sellingPrice: fields[4] as double,
      stock: (fields[5] as List).cast<StockModel>(),
      createdTime: fields[6] as DateTime,
      highlight: (fields[7] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      info: (fields[8] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      id: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VariationModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.qty)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.mrp)
      ..writeByte(3)
      ..write(obj.buyingPrice)
      ..writeByte(4)
      ..write(obj.sellingPrice)
      ..writeByte(5)
      ..write(obj.stock)
      ..writeByte(6)
      ..write(obj.createdTime)
      ..writeByte(7)
      ..write(obj.highlight)
      ..writeByte(8)
      ..write(obj.info)
      ..writeByte(9)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
