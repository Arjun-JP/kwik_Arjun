import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwik/models/warehouse_model.dart';

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
      pincodes: (fields[7] as List).cast<String>(),
      managerName: fields[8] as String,
      managerNumber: fields[9] as String,
      managerEmail: fields[10] as String,
      warehouseEmail: fields[11] as String,
      warehousePassword: fields[12] as String,
      deliveryBoys: (fields[13] as List).cast<dynamic>(),
      warehouseAddress: fields[14] as String,
      createdTime: fields[15] as String,
      version: fields[16] as int,
      uid: fields[17] as String, // New field
      tumTumDeliveryStartTime: fields[18] as String, // New field
      tumTumDeliveryEndTime: fields[19] as String, // New field
      underMaintenance: fields[20] as bool, // New field
      isDeleted: fields[21] as bool, // New field
    );
  }

  @override
  void write(BinaryWriter writer, WarehouseModel obj) {
    writer
      ..writeByte(22) // Updated to 22 fields (was 17)
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
      ..write(obj.pincodes)
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
      ..write(obj.version)
      ..writeByte(17) // New field
      ..write(obj.uid)
      ..writeByte(18) // New field
      ..write(obj.tumTumDeliveryStartTime)
      ..writeByte(19) // New field
      ..write(obj.tumTumDeliveryEndTime)
      ..writeByte(20) // New field
      ..write(obj.underMaintenance)
      ..writeByte(21) // New field
      ..write(obj.isDeleted);
  }
}

// WarehouseLocationAdapter remains the same
class WarehouseLocationAdapter extends TypeAdapter<WarehouseLocation> {
  @override
  final int typeId = 8;

  @override
  WarehouseLocation read(BinaryReader reader) {
    return WarehouseLocation(
      lat: reader.readDouble(),
      lng: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, WarehouseLocation obj) {
    writer
      ..writeDouble(obj.lat)
      ..writeDouble(obj.lng);
  }
}
