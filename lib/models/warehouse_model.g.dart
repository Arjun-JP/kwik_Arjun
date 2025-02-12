// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WarehouseModelAdapter extends TypeAdapter<WarehouseModel> {
  @override
  final int typeId = 7;

  @override
  WarehouseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WarehouseModel(
      warehouseLocation: fields[0] as WarehouseLocation,
      id: fields[1] as String,
      warehouseId: fields[2] as String,
      warehouseName: fields[3] as String,
      warehouseDescription: fields[4] as String,
      warehouseImage: fields[5] as String,
      warehouseNumber: fields[6] as String,
      picodes: (fields[7] as List).cast<String>(),
      managerName: fields[8] as String,
      managerNumber: fields[9] as String,
      managerEmail: fields[10] as String,
      warehouseEmail: fields[11] as String,
      warehousePassword: fields[12] as String,
      deliveryBoys: (fields[13] as List).cast<String>(),
      warehouseAddress: fields[14] as String,
      createdTime: fields[15] as String,
      version: fields[16] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WarehouseModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.warehouseLocation)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.warehouseId)
      ..writeByte(3)
      ..write(obj.warehouseName)
      ..writeByte(4)
      ..write(obj.warehouseDescription)
      ..writeByte(5)
      ..write(obj.warehouseImage)
      ..writeByte(6)
      ..write(obj.warehouseNumber)
      ..writeByte(7)
      ..write(obj.picodes)
      ..writeByte(8)
      ..write(obj.managerName)
      ..writeByte(9)
      ..write(obj.managerNumber)
      ..writeByte(10)
      ..write(obj.managerEmail)
      ..writeByte(11)
      ..write(obj.warehouseEmail)
      ..writeByte(12)
      ..write(obj.warehousePassword)
      ..writeByte(13)
      ..write(obj.deliveryBoys)
      ..writeByte(14)
      ..write(obj.warehouseAddress)
      ..writeByte(15)
      ..write(obj.createdTime)
      ..writeByte(16)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarehouseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WarehouseLocationAdapter extends TypeAdapter<WarehouseLocation> {
  @override
  final int typeId = 8;

  @override
  WarehouseLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WarehouseLocation(
      lat: fields[0] as double,
      lng: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WarehouseLocation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lng);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarehouseLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
