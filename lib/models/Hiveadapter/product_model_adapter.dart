import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/subcategory_model.dart';
import 'package:kwik/models/warehouse_model.dart';

import '../review_model.dart';
import '../variation_model.dart';

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 2; // Ensure this is unique

  @override
  ProductModel read(BinaryReader reader) {
    return ProductModel(
      id: reader.readString(),
      productName: reader.readString(),
      productDescription: reader.readString(),
      productImages: reader.readList().cast<String>(),
      brandId: reader.read(), // Custom object, so ensure Brand has an adapter
      categoryRef: reader.read(),
      subCategoryRef: reader.readList().cast<SubCategoryModel>(),
      variations: reader.readList().cast<VariationModel>(),
      warehouseRefs: reader.readList().cast<WarehouseModel>(),
      sku: reader.readString(),
      productVideo: reader.readString(),
      reviews: reader.readList().cast<ReviewModel>(),
      draft: reader.readBool(),
      createdTime: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.productName);
    writer.writeString(obj.productDescription);
    writer.writeList(obj.productImages);
    writer.write(obj.brandId);
    writer.write(obj.categoryRef);
    writer.writeList(obj.subCategoryRef);
    writer.writeList(obj.variations);
    writer.writeList(obj.warehouseRefs);
    writer.writeString(obj.sku);
    writer.writeString(obj.productVideo);
    writer.writeList(obj.reviews);
    writer.writeBool(obj.draft);
    writer.writeString(obj.createdTime);
  }
}
