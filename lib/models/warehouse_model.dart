import 'package:hive/hive.dart';

part 'warehouse_model.g.dart';

@HiveType(typeId: 8)
class WarehouseLocation {
  @HiveField(0)
  final double lat;
  @HiveField(1)
  final double lng;

  WarehouseLocation({
    required this.lat,
    required this.lng,
  });

  factory WarehouseLocation.fromJson(Map<String, dynamic> json) {
    return WarehouseLocation(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };

  static WarehouseLocation empty() => WarehouseLocation(lat: 0.0, lng: 0.0);
}

@HiveType(typeId: 7)
class WarehouseModel {
  @HiveField(0)
  final WarehouseLocation warehouseLocation;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String warehouseId;
  @HiveField(3)
  final String warehouseName;
  @HiveField(4)
  final String warehouseDescription;
  @HiveField(5)
  final String warehouseImage;
  @HiveField(6)
  final String warehouseNumber;
  @HiveField(7)
  final List<String> pincodes;
  @HiveField(8)
  final String managerName;
  @HiveField(9)
  final String managerNumber;
  @HiveField(10)
  final String managerEmail;
  @HiveField(11)
  final String warehouseEmail;
  @HiveField(12)
  final String warehousePassword;
  @HiveField(13)
  final List<dynamic> deliveryBoys;
  @HiveField(14)
  final String warehouseAddress;
  @HiveField(15)
  final String createdTime;
  @HiveField(16)
  final int version;
  @HiveField(17) // New field
  final String uid;
  @HiveField(18) // New field
  final String tumTumDeliveryStartTime;
  @HiveField(19) // New field
  final String tumTumDeliveryEndTime;
  @HiveField(20) // New field
  final bool underMaintenance;
  @HiveField(21) // New field
  final bool isDeleted;

  WarehouseModel({
    required this.warehouseLocation,
    required this.id,
    required this.warehouseId,
    required this.warehouseName,
    required this.warehouseDescription,
    required this.warehouseImage,
    required this.warehouseNumber,
    required this.pincodes,
    required this.managerName,
    required this.managerNumber,
    required this.managerEmail,
    required this.warehouseEmail,
    required this.warehousePassword,
    required this.deliveryBoys,
    required this.warehouseAddress,
    required this.createdTime,
    required this.version,
    required this.uid,
    required this.tumTumDeliveryStartTime,
    required this.tumTumDeliveryEndTime,
    required this.underMaintenance,
    required this.isDeleted,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    // Handle case where warehouse data is nested under 'warehouse' key
    final warehouseData = json['warehouse'] ?? json;

    return WarehouseModel(
      warehouseLocation: warehouseData['warehouse_location'] != null
          ? WarehouseLocation.fromJson(warehouseData['warehouse_location'])
          : WarehouseLocation.empty(),
      id: warehouseData['_id']?.toString() ?? '',
      warehouseId: warehouseData['warehouse_id']?.toString() ?? '',
      warehouseName: warehouseData['warehouse_name']?.toString() ?? '',
      warehouseDescription: warehouseData['warehouse_des']?.toString() ?? '',
      warehouseImage: warehouseData['warehouse_image']?.toString() ?? '',
      warehouseNumber: warehouseData['warehouse_number']?.toString() ?? '',
      pincodes: List<String>.from(warehouseData['picode'] ?? []),
      managerName: warehouseData['manager_name']?.toString() ?? '',
      managerNumber: warehouseData['manager_number']?.toString() ?? '',
      managerEmail: warehouseData['manager_email']?.toString() ?? '',
      warehouseEmail: warehouseData['warehouse_email']?.toString() ?? '',
      warehousePassword: warehouseData['warehouse_password']?.toString() ?? '',
      deliveryBoys: List<dynamic>.from(warehouseData['deliveryboys'] ?? []),
      warehouseAddress: warehouseData['warehouse_address']?.toString() ?? '',
      createdTime: warehouseData['created_time']?.toString() ?? '',
      version: (warehouseData['__v'] as num?)?.toInt() ?? 0,
      uid: warehouseData['UID']?.toString() ?? '',
      tumTumDeliveryStartTime:
          warehouseData['tum_tumdelivery_start_time']?.toString() ?? '',
      tumTumDeliveryEndTime:
          warehouseData['tumtumdelivery_end_time']?.toString() ?? '',
      underMaintenance: warehouseData['under_maintance'] ?? false,
      isDeleted: warehouseData['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warehouse_location': warehouseLocation.toJson(),
      '_id': id,
      'warehouse_id': warehouseId,
      'warehouse_name': warehouseName,
      'warehouse_des': warehouseDescription,
      'warehouse_image': warehouseImage,
      'warehouse_number': warehouseNumber,
      'picode': pincodes,
      'manager_name': managerName,
      'manager_number': managerNumber,
      'manager_email': managerEmail,
      'warehouse_email': warehouseEmail,
      'warehouse_password': warehousePassword,
      'deliveryboys': deliveryBoys,
      'warehouse_address': warehouseAddress,
      'created_time': createdTime,
      '__v': version,
      'UID': uid,
      'tum_tumdelivery_start_time': tumTumDeliveryStartTime,
      'tumtumdelivery_end_time': tumTumDeliveryEndTime,
      'under_maintance': underMaintenance,
      'isDeleted': isDeleted,
    };
  }

  static WarehouseModel empty() {
    return WarehouseModel(
      warehouseLocation: WarehouseLocation.empty(),
      id: '',
      warehouseId: '',
      warehouseName: '',
      warehouseDescription: '',
      warehouseImage: '',
      warehouseNumber: '',
      pincodes: [],
      managerName: '',
      managerNumber: '',
      managerEmail: '',
      warehouseEmail: '',
      warehousePassword: '',
      deliveryBoys: [],
      warehouseAddress: '',
      createdTime: '',
      version: 0,
      uid: '',
      tumTumDeliveryStartTime: '',
      tumTumDeliveryEndTime: '',
      underMaintenance: false,
      isDeleted: false,
    );
  }
}
