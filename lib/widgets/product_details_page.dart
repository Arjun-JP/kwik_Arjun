import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/widgets/products_3.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> imageList = [
      'assets/images/image2.jpeg',
      'assets/images/image2.jpeg',
      'assets/images/image2.jpeg',
    ];
    return Scaffold(
      backgroundColor: AppColors.backgroundColorWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 433,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          imageList[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: AppColors.kblackColor),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: IconButton(
                    icon:
                        const Icon(Icons.search, color: AppColors.kblackColor),
                    onPressed: () {},
                  ),
                ),
                Positioned.fill(
                  bottom: -10,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Expanded(
                      child: Container(
                        height: 25,
                        width: (imageList.length * 50) / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.kwhiteColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            imageList.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentIndex == index ? 8 : 6,
                              height: _currentIndex == index ? 8 : 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? AppColors.dotColorSelected
                                    : AppColors.dotColorUnSelected,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Strawberry",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text(
                    "1 pack (160g - 180g)",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 10,
                    children: [
                      const Text("₹66",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const Text("MRP ₹160",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.kgreyColorlite,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColorDimGrey)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.korangeColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "15% OFF",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColorWhite,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                        collapsedBackgroundColor: AppColors.kwhiteColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        tilePadding: EdgeInsets.zero,
                        title: const Text(
                          "View product details",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Column(
                            children: [
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  backgroundColor: AppColors.kwhiteColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  collapsedBackgroundColor:
                                      AppColors.kwhiteColor,
                                  initiallyExpanded: true,
                                  tilePadding: EdgeInsets.zero,
                                  title: const Text(
                                    "Highlights",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: AppColors.backgroundColorWhite,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          highlightContent("Imported", "No"),
                                          highlightContent("Organic", "No"),
                                          highlightContent("About The Product",
                                              "Incorporate strawberries into your diet as a naturally sweet treat that can elevate your breakfast, desserts, or smoothies."),
                                          highlightContent("Brand", "No"),
                                          highlightContent(
                                              "Good For", "Immunity"),
                                          highlightContent(
                                              "Product Type", "Strawberry"),
                                          highlightContent(
                                              "Weight", "160 - 180 G"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  backgroundColor: AppColors.kwhiteColor,
                                  collapsedBackgroundColor:
                                      AppColors.kwhiteColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  tilePadding: EdgeInsets.zero,
                                  title: const Text(
                                    "Information",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: AppColors.backgroundColorWhite,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          highlightContent("Imported", "No"),
                                          highlightContent("Organic", "No"),
                                          highlightContent("About The Product",
                                              "Incorporate strawberries into your diet as a naturally sweet treat that can elevate your breakfast, desserts, or smoothies."),
                                          highlightContent("Brand", "No"),
                                          highlightContent(
                                              "Good For", "Immunity"),
                                          highlightContent(
                                              "Product Type", "Strawberry"),
                                          highlightContent(
                                              "Weight", "160 - 180 G"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ]),
                  ),
                  Container(
                    color: AppColors.kwhiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        const Text("Similar Products",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 340,
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                                return const Products3(
                                  image: 'assets/images/image2.jpeg',
                                  title: 'Watermelon Kiran',
                                  quantity: "1 Pc",
                                  mrp: "100",
                                  buyingPrice: "50",
                                  pricetextColor: '233D4D',
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: 3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: AppColors.kwhiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        const Text("You might also like",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 340,
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                                return const Products3(
                                  image: 'assets/images/image2.jpeg',
                                  title: 'Watermelon Kiran',
                                  quantity: "1 Pc",
                                  mrp: "100",
                                  buyingPrice: "50",
                                  pricetextColor: '233D4D',
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: 3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: AppColors.kwhiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "1 pack (160g - 180g)",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                const Text("₹66",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const Text("MRP ₹160",
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor:
                                            AppColors.kgreyColorlite,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColorDimGrey)),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: AppColors.korangeColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Text(
                                    "15% OFF",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColorWhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Inclusive of all taxes",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColorDimGrey,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.addToCartBorder,
                            minimumSize: const Size(152, 48),
                          ),
                          child: const Text("Add to Cart",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget highlightContent(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textColorDimGrey),
          ),
        ),
      ],
    ),
  );
}
