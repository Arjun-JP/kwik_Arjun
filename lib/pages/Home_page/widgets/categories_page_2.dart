import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/constants/colors.dart';
import '../../../bloc/category_model_4_bloc/category_model_4_bloc.dart';
import '../../../bloc/category_model_4_bloc/category_model_4_event.dart';
import '../../../bloc/category_model_4_bloc/category_model_4_state.dart';
import '../../../repositories/sub_category_product_repository.dart';

class CategoriesPage2 extends StatelessWidget {
  final String subCategoryId;
  final String titleColor;
  final String productColor;
  final String mrpBgColor;
  final String mrpTextColor;
  final String sellTextColor;
  final String sellPriceBgColor;
  final String bgColor;

  const CategoriesPage2({
    super.key,
    required this.subCategoryId,
    required this.titleColor,
    required this.mrpBgColor,
    required this.mrpTextColor,
    required this.sellPriceBgColor,
    required this.sellTextColor,
    required this.productColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryModel4Bloc(repository: SubcategoryProductRepository())
            ..add(FetchSubCategoryProducts(subCategoryId)),
      child: BlocBuilder<CategoryModel4Bloc, CategoryModel4State>(
        builder: (context, state) {
          if (state is CategoryModel4Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryModel4Loaded) {
            return Container(
              color: parseColor(bgColor),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "ONLY FOR YOU",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: state.products.first.subCategoryRef.name,
                      style: TextStyle(
                        color: parseColor(titleColor),
                        fontSize: 18,
                      ),
                      children: [
                        const TextSpan(
                          text: " Prices ",
                          style: TextStyle(color: AppColors.kblackColor),
                        ),
                        WidgetSpan(
                          child: Icon(Icons.trending_down,
                              color: parseColor(titleColor), size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 50,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return productItem(
                          imageurl: state.products[index].productImages.first,
                          price: "₹30",
                          mrp: "MRP ₹48",
                          productColor: productColor,
                          mrpBgColor: mrpBgColor,
                          mrpTextColor: mrpTextColor,
                          sellPriceBgColor: sellPriceBgColor,
                          sellTextColor: sellTextColor);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          } else if (state is CategoryModel4Error) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

Widget productItem(
    {required String imageurl,
    required String price,
    required String mrp,
    required String productColor,
    required String mrpTextColor,
    required String mrpBgColor,
    required String sellPriceBgColor,
    required String sellTextColor}) {
  return Container(
    padding: EdgeInsets.only(top: 5, bottom: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: parseColor(productColor),
    ),
    child: 
    Column(
      children: [
        Expanded(
          flex: 1,
          child: Image.network(imageurl, fit: BoxFit.cover),
        ),
        Container(
          width: double.infinity,
          color: parseColor(sellPriceBgColor),
          child: Text(
            textAlign: TextAlign.center,
            price,
            style: TextStyle(
                color: parseColor(sellTextColor), fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          color: parseColor(mrpBgColor),
          child: Text(
            mrp,
            style: TextStyle(
              color: parseColor(mrpTextColor),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.lineThrough,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
