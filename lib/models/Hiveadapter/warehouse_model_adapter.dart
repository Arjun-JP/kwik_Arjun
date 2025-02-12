import 'package:hive_flutter/hive_flutter.dart';

import '../warehouse_model.dart';

class WarehouseModelAdapter extends TypeAdapter<WarehouseModel> {
  @override
  final int typeId = 7;

  @override
  WarehouseModel read(BinaryReader reader) {
    return WarehouseModel(
      warehouseLocation: reader.read() as WarehouseLocation,
      id: reader.readString(),
      warehouseId: reader.readString(),
      warehouseName: reader.readString(),
      warehouseDescription: reader.readString(),
      warehouseImage: reader.readString(),
      warehouseNumber: reader.readString(),
      picodes: (reader.readList() as List).cast<String>(),
      managerName: reader.readString(),
      managerNumber: reader.readString(),
      managerEmail: reader.readString(),
      warehouseEmail: reader.readString(),
      warehousePassword: reader.readString(),
      deliveryBoys: (reader.readList() as List).cast<String>(),
      warehouseAddress: reader.readString(),
      createdTime: reader.readString(),
      version: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, WarehouseModel obj) {
    writer.write(obj.warehouseLocation);
    writer.writeString(obj.id);
    writer.writeString(obj.warehouseId);
    writer.writeString(obj.warehouseName);
    writer.writeString(obj.warehouseDescription);
    writer.writeString(obj.warehouseImage);
    writer.writeString(obj.warehouseNumber);
    writer.writeList(obj.picodes);
    writer.writeString(obj.managerName);
    writer.writeString(obj.managerNumber);
    writer.writeString(obj.managerEmail);
    writer.writeString(obj.warehouseEmail);
    writer.writeString(obj.warehousePassword);
    writer.writeList(obj.deliveryBoys);
    writer.writeString(obj.warehouseAddress);
    writer.writeString(obj.createdTime);
    writer.writeInt(obj.version);
  }
}

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
    writer.writeDouble(obj.lat);
    writer.writeDouble(obj.lng);
  }
}
