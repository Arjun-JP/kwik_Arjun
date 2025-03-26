import 'package:hive/hive.dart';
import 'package:kwik/models/stock_model.dart';

part 'variation_model.g.dart'; // This is required for code generation

@HiveType(typeId: 6) // Ensure typeId is unique for this model
class VariationModel {
  @HiveField(0)
  final int qty;

  @HiveField(1)
  final String unit;

  @HiveField(2)
  final double mrp;

  @HiveField(3)
  final double buyingPrice;

  @HiveField(4)
  final double sellingPrice;

  @HiveField(5)
  final List<StockModel> stock;

  @HiveField(6)
  final DateTime createdTime;

  @HiveField(7)
  final List<Map<String, dynamic>> highlight;

  @HiveField(8)
  final List<Map<String, dynamic>> info;

  @HiveField(9)
  final String id;

  VariationModel(
      {required this.qty,
      required this.unit,
      required this.mrp,
      required this.buyingPrice,
      required this.sellingPrice,
      required this.stock,
      required this.createdTime,
      required this.highlight,
      required this.info,
      required this.id});

  factory VariationModel.fromJson(Map<String, dynamic> json) {
    return VariationModel(
      id: json['_id'] ?? "",
      qty: json['Qty'] ?? 0,
      unit: json['unit'] ?? '',
      mrp: (json['MRP'] ?? 0).toDouble(),
      buyingPrice: (json['buying_price'] ?? 0).toDouble(),
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      stock: (json['stock'] as List<dynamic>?)
              ?.map((e) => StockModel.fromJson(e))
              .toList() ??
          [],
      createdTime: json['created_time'] != null
          ? DateTime.tryParse(json['created_time']) ?? DateTime.now()
          : DateTime.now(),
      highlight: (json['Highlight'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
      info: (json['info'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Ensure consistency with `fromJson()`
      'Qty': qty,
      'unit': unit,
      'MRP': mrp,
      'buying_price': buyingPrice,
      'selling_price': sellingPrice,
      'stock': stock.map((e) => e.toJson()).toList(),
      'created_time': createdTime.toIso8601String(),
      'Highlight': highlight.map((e) => Map<String, dynamic>.from(e)).toList(),
      'info': info.map((e) => Map<String, dynamic>.from(e)).toList(),
    };
  }
}
