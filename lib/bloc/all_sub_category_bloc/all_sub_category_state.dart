import 'package:equatable/equatable.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/models/subcategory_model.dart';

abstract class AllSubCategoryState extends Equatable {
  const AllSubCategoryState();

  @override
  List<Object?> get props => [];
}

/// **Initial state when no data is loaded**
class CategoryInitial extends AllSubCategoryState {}

/// **State when data is being loaded**
class CategoryLoading extends AllSubCategoryState {}

/// **State when an error occurs**
class CategoryError extends AllSubCategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object> get props => [message];
}

/// **State when categories and products are loaded**
class CategoryLoaded extends AllSubCategoryState {
  final List<SubCategoryModel> subCategories;
  final String selectedSubCategory;
  final List<ProductModel> products;

  const CategoryLoaded({
    required this.subCategories,
    required this.selectedSubCategory,
    required this.products,
  });

  /// **Helper method to create a modified copy of the state**
  CategoryLoaded copyWith({
    List<SubCategoryModel>? subCategories,
    String? selectedSubCategory,
    List<ProductModel>? products,
  }) {
    return CategoryLoaded(
      subCategories: subCategories ?? this.subCategories,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      products: products ?? this.products,
    );
  }

  @override
  List<Object> get props => [subCategories, selectedSubCategory, products];
}
