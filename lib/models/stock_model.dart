import 'package:hive/hive.dart';

part 'stock_model.g.dart'; // This is required for code generation

@HiveType(typeId: 4)
class StockModel {
  @HiveField(0)
  final String warehouseRef;

  @HiveField(1)
  final int stockQty;

  @HiveField(2)
  final bool visibility;

  StockModel({
    required this.warehouseRef,
    required this.stockQty,
    required this.visibility,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      warehouseRef: json['warehouse_ref'] ?? '',
      stockQty: json['stock_qty'] ?? 0,
      visibility: json['visibility'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warehouse_ref': warehouseRef,
      'stock_qty': stockQty,
      'visibility': visibility,
    };
  }
}
