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

    // Correctly read the StockModel list
    final stock = (reader.readList() as List).whereType<StockModel>().toList();

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

    // Correctly write StockModel list
    writer.writeList(obj.stock);

    // Write DateTime as int (milliseconds since epoch)
    writer.writeInt(obj.createdTime.millisecondsSinceEpoch);

    // Write highlight list safely
    writer.writeList(obj.highlight);

    // Write info list safely
    writer.writeList(obj.info);
  }
}
