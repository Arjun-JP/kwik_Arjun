import 'package:hive/hive.dart';
import '../stock_model.dart';
import '../variation_model.dart';

class VariationModelAdapter extends TypeAdapter<VariationModel> {
  @override
  final typeId = 6; // Ensure this typeId is unique

  @override
  VariationModel read(BinaryReader reader) {
    final qty = reader.readInt();
    final unit = reader.readString();
    final mrp = reader.readDouble();
    final buyingPrice = reader.readDouble();
    final sellingPrice = reader.readDouble();

    // Read the list of StockModel objects
    final stock = (reader.readList().cast<StockModel>()) ?? [];

    // Read DateTime as int (milliseconds since epoch)
    final createdTimeMillis = reader.readInt();
    final createdTime = DateTime.fromMillisecondsSinceEpoch(createdTimeMillis);

    return VariationModel(
      qty: qty,
      unit: unit,
      mrp: mrp,
      buyingPrice: buyingPrice,
      sellingPrice: sellingPrice,
      stock: stock,
      createdTime: createdTime,
    );
  }

  @override
  void write(BinaryWriter writer, VariationModel obj) {
    writer.writeInt(obj.qty);
    writer.writeString(obj.unit);
    writer.writeDouble(obj.mrp);
    writer.writeDouble(obj.buyingPrice);
    writer.writeDouble(obj.sellingPrice);

    // Write the list of StockModel objects
    writer.writeList(obj.stock);

    // Write DateTime as int (milliseconds since epoch)
    writer.writeInt(obj.createdTime.millisecondsSinceEpoch);
  }
}
