import 'package:hive/hive.dart';
import '../stock_model.dart';
import '../variation_model.dart';

class VariationModelAdapter extends TypeAdapter<VariationModel> {
  @override
  final int typeId = 6; // Ensure this typeId is unique

  @override
  VariationModel read(BinaryReader reader) {
    final id = reader.readString();
    final qty = reader.readInt();
    final unit = reader.readString();
    final mrp = reader.readDouble();
    final buyingPrice = reader.readDouble();
    final sellingPrice = reader.readDouble();

    // Read the list of StockModel objects safely
    final stock =
        (reader.readList() as List).map((e) => e as StockModel).toList();

    // Read DateTime as int (milliseconds since epoch)
    final createdTimeMillis = reader.readInt();
    final createdTime = DateTime.fromMillisecondsSinceEpoch(createdTimeMillis);

    // Read highlight list safely
    final highlight = (reader.readList() as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    // Read info list safely
    final info = (reader.readList() as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    return VariationModel(
      id: id,
      qty: qty,
      unit: unit,
      mrp: mrp,
      buyingPrice: buyingPrice,
      sellingPrice: sellingPrice,
      stock: stock,
      createdTime: createdTime,
      highlight: highlight,
      info: info,
    );
  }

  @override
  void write(BinaryWriter writer, VariationModel obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.qty);
    writer.writeString(obj.unit);
    writer.writeDouble(obj.mrp);
    writer.writeDouble(obj.buyingPrice);
    writer.writeDouble(obj.sellingPrice);

    // Write the list of StockModel objects
    writer.writeList(obj.stock.map((e) => e.toJson()).toList());

    // Write DateTime as int (milliseconds since epoch)
    writer.writeInt(obj.createdTime.millisecondsSinceEpoch);

    // Write highlight list safely
    writer.writeList(
        obj.highlight.map((e) => Map<String, dynamic>.from(e)).toList());

    // Write info list safely
    writer
        .writeList(obj.info.map((e) => Map<String, dynamic>.from(e)).toList());
  }
}
