// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 2;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      productName: fields[1] as String,
      productDescription: fields[2] as String,
      productImages: (fields[3] as List).cast<String>(),
      brandId: fields[4] as Brand,
      categoryRef: fields[5] as Category,
      subCategoryRef: (fields[6] as List).cast<SubCategoryModel>(),
      variations: (fields[7] as List).cast<VariationModel>(),
      warehouseRefs: (fields[8] as List).cast<WarehouseModel>(),
      sku: fields[9] as String,
      productVideo: fields[10] as String,
      reviews: (fields[11] as List).cast<ReviewModel>(),
      draft: fields[12] as bool,
      createdTime: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.productDescription)
      ..writeByte(3)
      ..write(obj.productImages)
      ..writeByte(4)
      ..write(obj.brandId)
      ..writeByte(5)
      ..write(obj.categoryRef)
      ..writeByte(6)
      ..write(obj.subCategoryRef)
      ..writeByte(7)
      ..write(obj.variations)
      ..writeByte(8)
      ..write(obj.warehouseRefs)
      ..writeByte(9)
      ..write(obj.sku)
      ..writeByte(10)
      ..write(obj.productVideo)
      ..writeByte(11)
      ..write(obj.reviews)
      ..writeByte(12)
      ..write(obj.draft)
      ..writeByte(13)
      ..write(obj.createdTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
