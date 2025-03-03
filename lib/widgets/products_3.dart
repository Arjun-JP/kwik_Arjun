import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';

class Products3 extends StatelessWidget {
  final String image;
  final String title;
  final String quantity;
  final String mrp;
  final String buyingPrice;
  const Products3(
      {super.key,
      required this.image,
      required this.title,
      required this.quantity,
      required this.mrp,
      required this.buyingPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: Image.asset(
                  image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      title,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kblackColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quantity,
                    style: TextStyle(color: AppColors.kgreyColorlite),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "{₹$buyingPrice}",
                            style: TextStyle(
                              color: AppColors.kgreyColorlite,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            "{₹${mrp}}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kblackColor,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kwhiteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          side: const BorderSide(
                              color: AppColors.addToCartBorder),
                        ),
                        onPressed: () {},
                        child: const Text("Add",
                            style: TextStyle(color: AppColors.addToCartBorder)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
