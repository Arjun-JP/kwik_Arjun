import 'package:hive/hive.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/variation_model.dart';

// 📌 CartProduct Adapter
class CartProductAdapter extends TypeAdapter<CartProduct> {
  @override
  final typeId = 8; // Unique type ID

  @override
  CartProduct read(BinaryReader reader) {
    return CartProduct(
      productRef: reader.readString(),
      variant: VariationModelAdapter()
          .read(reader), // Read Variation object using its adapter
      quantity: reader.readInt(),
      pincode: reader.readString(),
      sellingPrice: reader.readDouble(),
      mrp: reader.readDouble(),
      buyingPrice: reader.readDouble(),
      inStock: reader.readBool(),
      variationVisibility: reader.readBool(),
      finalPrice: reader.readDouble(),
      cartAddedDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, CartProduct obj) {
    writer.writeString(obj.productRef);
    VariationModelAdapter()
        .write(writer, obj.variant); // Write Variation object using its adapter
    writer.writeInt(obj.quantity);
    writer.writeString(obj.pincode);
    writer.writeDouble(obj.sellingPrice);
    writer.writeDouble(obj.mrp);
    writer.writeDouble(obj.buyingPrice);
    writer.writeBool(obj.inStock);
    writer.writeBool(obj.variationVisibility);
    writer.writeDouble(obj.finalPrice);
    writer.writeInt(obj.cartAddedDate.millisecondsSinceEpoch);
  }
}
