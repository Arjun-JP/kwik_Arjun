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

  VariationModel({
    required this.qty,
    required this.unit,
    required this.mrp,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.stock,
    required this.createdTime,
    required this.highlight,
    required this.info,
  });

  factory VariationModel.fromJson(Map<String, dynamic> json) {
    return VariationModel(
      qty: json['Qty'] ?? 0,
      unit: json['unit'] ?? '',
      mrp: (json['MRP'] ?? 0).toDouble(),
      buyingPrice: (json['buying_price'] ?? 0).toDouble(),
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      stock: (json['stock'] as List<dynamic>?)
              ?.map((e) => StockModel.fromJson(e))
              .toList() ??
          [],
      createdTime: DateTime.parse(
          json['created_time'] ?? DateTime.now().toIso8601String()),
      highlight: List<Map<String, dynamic>>.from(json['highlight'] ?? []),
      info: List<Map<String, dynamic>>.from(json['info'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Qty': qty,
      'unit': unit,
      'MRP': mrp,
      'buying_price': buyingPrice,
      'selling_price': sellingPrice,
      'stock': stock.map((e) => e.toJson()).toList(),
      'created_time': createdTime.toIso8601String(),
      'highlight': highlight,
      'info': info,
    };
  }
}
