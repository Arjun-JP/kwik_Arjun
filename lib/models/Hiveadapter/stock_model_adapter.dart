import 'package:hive/hive.dart';
import 'package:kwik/models/stock_model.dart';

class StockModelAdapter extends TypeAdapter<StockModel> {
  @override
  final typeId = 4; // Ensure this typeId is unique

  @override
  StockModel read(BinaryReader reader) {
    final warehouseRef = reader.readString();
    final stockQty = reader.readInt();
    final visibility = reader.readBool();

    return StockModel(
      warehouseRef: warehouseRef,
      stockQty: stockQty,
      visibility: visibility,
    );
  }

  @override
  void write(BinaryWriter writer, StockModel obj) {
    writer.writeString(obj.warehouseRef);
    writer.writeInt(obj.stockQty);
    writer.writeBool(obj.visibility);
  }
}
