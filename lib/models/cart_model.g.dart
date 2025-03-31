// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartProductAdapter extends TypeAdapter<CartProduct> {
  @override
  final int typeId = 39;

  @override
  CartProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartProduct(
      productRef: fields[0] as ProductModel,
      variant: fields[1] as VariationModel,
      quantity: fields[2] as int,
      pincode: fields[3] as String,
      sellingPrice: fields[4] as double,
      mrp: fields[5] as double,
      buyingPrice: fields[6] as double,
      inStock: fields[7] as bool,
      variationVisibility: fields[8] as bool,
      finalPrice: fields[9] as double,
      cartAddedDate: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CartProduct obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.productRef)
      ..writeByte(1)
      ..write(obj.variant)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.pincode)
      ..writeByte(4)
      ..write(obj.sellingPrice)
      ..writeByte(5)
      ..write(obj.mrp)
      ..writeByte(6)
      ..write(obj.buyingPrice)
      ..writeByte(7)
      ..write(obj.inStock)
      ..writeByte(8)
      ..write(obj.variationVisibility)
      ..writeByte(9)
      ..write(obj.finalPrice)
      ..writeByte(10)
      ..write(obj.cartAddedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
