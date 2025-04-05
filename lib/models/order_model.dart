import 'package:kwik/models/cart_model.dart';

class Order {
  String id;
  WarehouseModel warehouseRef;
  Map<String, dynamic>? userRef; // Added userRef as Map<String, dynamic>?
  List<CartProduct> products;
  Map<String, dynamic>? deliveryBoy;
  String orderStatus;
  AddressModel userAddress;
  String userContactNumber;
  Location userLocation;
  String otp;
  DateTime orderPlacedTime;
  DateTime? outForDeliveryTime;
  DateTime? packingTime;
  DateTime? completedTime;
  DateTime? failedTime;
  String paymentType;
  double totalAmount;
  double totalSaved;
  double discountPrice;
  double profit;
  String? paymentId;
  String typeOfDelivery;
  DateTime? selectedTimeSlot;
  double deliveryCharge;
  String? deliveryInstructions;
  DateTime createdTime;

  Order({
    required this.id,
    required this.warehouseRef,
    this.userRef, // Added userRef
    required this.products,
    this.deliveryBoy,
    required this.orderStatus,
    required this.userAddress,
    required this.userContactNumber,
    required this.userLocation,
    required this.otp,
    required this.orderPlacedTime,
    this.outForDeliveryTime,
    this.packingTime,
    this.completedTime,
    this.failedTime,
    required this.paymentType,
    required this.totalAmount,
    required this.totalSaved,
    required this.discountPrice,
    required this.profit,
    this.paymentId,
    required this.typeOfDelivery,
    this.selectedTimeSlot,
    required this.deliveryCharge,
    this.deliveryInstructions,
    required this.createdTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    try {
      return Order(
        id: json['_id'] ?? '',
        warehouseRef: WarehouseModel.fromJson(json['warehouse_ref']),
        userRef: json['user_ref'] is Map<String, dynamic>
            ? json['user_ref']
            : null, // Added userRef parsing
        products: (json['products'] as List? ?? [])
            .map((e) => CartProduct.fromJson(e))
            .toList(),
        deliveryBoy: json['delivery_boy'] is Map<String, dynamic>
            ? json['delivery_boy']
            : null,
        orderStatus: json['order_status'] ?? 'pending',
        userAddress: AddressModel.fromJson(json['user_address']),
        userContactNumber: json['user_contact_number'] ?? '',
        userLocation: Location.fromJson(json['user_location']),
        otp: json['otp'] ?? '',
        orderPlacedTime: DateTime.tryParse(json['order_placed_time'] ?? '') ??
            DateTime.now(),
        outForDeliveryTime:
            DateTime.tryParse(json['out_for_delivery_time'] ?? ''),
        packingTime: DateTime.tryParse(json['packing_time'] ?? ''),
        completedTime: DateTime.tryParse(json['completed_time'] ?? ''),
        failedTime: DateTime.tryParse(json['failed_time'] ?? ''),
        paymentType: json['payment_type'] ?? 'Cash',
        totalAmount: (json['total_amount'] ?? 0).toDouble(),
        totalSaved: (json['total_saved'] ?? 0).toDouble(),
        discountPrice: (json['discount_price'] ?? 0).toDouble(),
        profit: (json['profit'] ?? 0).toDouble(),
        paymentId: json['payment_id'],
        typeOfDelivery: json['type_of_delivery'] ?? 'normal',
        selectedTimeSlot: DateTime.tryParse(json['selected_time_slot'] ?? ''),
        deliveryCharge: (json['delivery_charge'] ?? 0).toDouble(),
        deliveryInstructions: json['delivery_instructions'],
        createdTime:
            DateTime.tryParse(json['created_time'] ?? '') ?? DateTime.now(),
      );
    } catch (e, stacktrace) {
      print('❌ Order.fromJson error: $e');
      print('📌 Stacktrace: $stacktrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'warehouse_ref': warehouseRef.toJson(),
      'user_ref': userRef, // Added userRef to toJson
      'products': products.map((e) => e.toJson()).toList(),
      'delivery_boy': deliveryBoy,
      'order_status': orderStatus,
      'user_address': userAddress.toJson(),
      'user_contact_number': userContactNumber,
      'user_location': userLocation.toJson(),
      'otp': otp,
      'order_placed_time': orderPlacedTime.toIso8601String(),
      'out_for_delivery_time': outForDeliveryTime?.toIso8601String(),
      'packing_time': packingTime?.toIso8601String(),
      'completed_time': completedTime?.toIso8601String(),
      'failed_time': failedTime?.toIso8601String(),
      'payment_type': paymentType,
      'total_amount': totalAmount,
      'total_saved': totalSaved,
      'discount_price': discountPrice,
      'profit': profit,
      'payment_id': paymentId,
      'type_of_delivery': typeOfDelivery,
      'selected_time_slot': selectedTimeSlot?.toIso8601String(),
      'delivery_charge': deliveryCharge,
      'delivery_instructions': deliveryInstructions,
      'created_time': createdTime.toIso8601String(),
    };
  }
}

class Location {
  final double lat;
  final double lang;

  Location({
    required this.lat,
    required this.lang,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] ?? 0).toDouble(),
      lang: (json['lang'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lang': lang,
    };
  }
}

// class CartProduct {
//   // Assuming CartProduct has its own model and fromJson/toJson methods
//   final Map<String, dynamic> productRef;
//   final Map<String, dynamic> variant;
//   final int quantity;
//   final String pincode;
//   final double sellingPrice;
//   final double mrp;
//   final double buyingPrice;
//   final bool inStock;
//   final bool variationVisibility;
//   final double finalPrice;
//   final String cartAddedDate;
//   final String id;

//   CartProduct({
//     required this.productRef,
//     required this.variant,
//     required this.quantity,
//     required this.pincode,
//     required this.sellingPrice,
//     required this.mrp,
//     required this.buyingPrice,
//     required this.inStock,
//     required this.variationVisibility,
//     required this.finalPrice,
//     required this.cartAddedDate,
//     required this.id,
//   });

//   factory CartProduct.fromJson(Map<String, dynamic> json) {
//     return CartProduct(
//       productRef: json['product_ref'] ?? {},
//       variant: json['variant'] ?? {},
//       quantity: json['quantity'] ?? 0,
//       pincode: json['pincode'] ?? "",
//       sellingPrice: (json['selling_price'] ?? 0).toDouble(),
//       mrp: (json['mrp'] ?? 0).toDouble(),
//       buyingPrice: (json['buying_price'] ?? 0).toDouble(),
//       inStock: json['inStock'] ?? false,
//       variationVisibility: json['variation_visibility'] ?? false,
//       finalPrice: (json['final_price'] ?? 0).toDouble(),
//       cartAddedDate: json['cart_added_date'] ?? "",
//       id: json['_id'] ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'product_ref': productRef,
//       'variant': variant,
//       'quantity': quantity,
//       'pincode': pincode,
//       'selling_price': sellingPrice,
//       'mrp': mrp,
//       'buying_price': buyingPrice,
//       'inStock': inStock,
//       'variation_visibility': variationVisibility,
//       'final_price': finalPrice,
//       'cart_added_date': cartAddedDate,
//       '_id': id,
//     };
//   }
// }

class AddressModel {
  // Assuming AddressModel has its own model and fromJson/toJson methods
  final Location location;
  final String addressType;
  final String flatNoName;
  final String floor;
  final String area;
  final String landmark;
  final String phoneNo;
  final String pincode;
  final String id;

  AddressModel({
    required this.location,
    required this.addressType,
    required this.flatNoName,
    required this.floor,
    required this.area,
    required this.landmark,
    required this.phoneNo,
    required this.pincode,
    required this.id,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      location: Location.fromJson(json['Location']),
      addressType: json['address_type'] ?? "",
      flatNoName: json['flat_no_name'] ?? "",
      floor: json['floor'] ?? "",
      area: json['area'] ?? "",
      landmark: json['landmark'] ?? "",
      phoneNo: json['phone_no'] ?? "",
      pincode: json['pincode'] ?? "",
      id: json['_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Location': location.toJson(),
      'address_type': addressType,
      'flat_no_name': flatNoName,
      'floor': floor,
      'area': area,
      'landmark': landmark,
      'phone_no': phoneNo,
      'pincode': pincode,
      '_id': id,
    };
  }
}

class WarehouseModel {
  // Assuming WarehouseModel has its own model and fromJson/toJson methods
  final Location warehouseLocation;
  final String id;
  final String warehouseId;
  final String warehouseName;
  final String warehouseDes;
  final String warehouseImage;
  final String warehouseNumber;
  final List<String> picode;
  final String managerName;
  final String managerNumber;
  final String managerEmail;
  final String warehouseEmail;
  final String warehousePassword;
  final List<dynamic> deliveryboys;
  final String warehouseAddress;
  final String createdTime;
  final int v;
  final String uid;
  final String tumTumdeliveryStartTime;
  final String tumtumdeliveryEndTime;
  final bool underMaintance;

  WarehouseModel({
    required this.warehouseLocation,
    required this.id,
    required this.warehouseId,
    required this.warehouseName,
    required this.warehouseDes,
    required this.warehouseImage,
    required this.warehouseNumber,
    required this.picode,
    required this.managerName,
    required this.managerNumber,
    required this.managerEmail,
    required this.warehouseEmail,
    required this.warehousePassword,
    required this.deliveryboys,
    required this.warehouseAddress,
    required this.createdTime,
    required this.v,
    required this.uid,
    required this.tumTumdeliveryStartTime,
    required this.tumtumdeliveryEndTime,
    required this.underMaintance,
  });
  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      warehouseLocation: Location.fromJson(json['warehouse_location']),
      id: json['_id'] ?? "",
      warehouseId: json['warehouse_id'] ?? "",
      warehouseName: json['warehouse_name'] ?? "",
      warehouseDes: json['warehouse_des'] ?? "",
      warehouseImage: json['warehouse_image'] ?? "",
      warehouseNumber: json['warehouse_number'] ?? "",
      picode: List<String>.from(json['picode'] ?? []),
      managerName: json['manager_name'] ?? "",
      managerNumber: json['manager_number'] ?? "",
      managerEmail: json['manager_email'] ?? "",
      warehouseEmail: json['warehouse_email'] ?? "",
      warehousePassword: json['warehouse_password'] ?? "",
      deliveryboys: json['deliveryboys'] ?? [],
      warehouseAddress: json['warehouse_address'] ?? "",
      createdTime: json['created_time'] ?? "",
      v: json['__v'] ?? 0,
      uid: json['UID'] ?? "",
      tumTumdeliveryStartTime: json['tum_tumdelivery_start_time'] ?? "",
      tumtumdeliveryEndTime: json['tumtumdelivery_end_time'] ?? "",
      underMaintance: json['under_maintance'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warehouse_location': warehouseLocation.toJson(),
      '_id': id,
      'warehouse_id': warehouseId,
      'warehouse_name': warehouseName,
      'warehouse_des': warehouseDes,
      'warehouse_image': warehouseImage,
      'warehouse_number': warehouseNumber,
      'picode': picode,
      'manager_name': managerName,
      'manager_number': managerNumber,
      'manager_email': managerEmail,
      'warehouse_email': warehouseEmail,
      'warehouse_password': warehousePassword,
      'deliveryboys': deliveryboys,
      'warehouse_address': warehouseAddress,
      'created_time': createdTime,
      '__v': v,
      'UID': uid,
      'tum_tumdelivery_start_time': tumTumdeliveryStartTime,
      'tumtumdelivery_end_time': tumtumdeliveryEndTime,
      'under_maintance': underMaintance,
    };
  }
}
