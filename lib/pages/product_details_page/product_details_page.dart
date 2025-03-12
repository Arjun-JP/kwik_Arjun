import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/products_3.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColorWhite,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  productdetails(theme: theme),
                  similerproducts(theme: theme),
                  productsYouMightAlsoLike(theme: theme),
                ],
              ),
            ),
          ),
          addtocartContainer(theme: theme)
        ],
      ),
    );
  }

  Widget productdetails({required ThemeData theme}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
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
                  itemCount: widget.product.productImages.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.product.productImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColors.kblackColor),
                  onPressed: () => context.pop(),
                ),
              ),
              Positioned(
                top: 20,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.search, color: AppColors.kblackColor),
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
                      width: (widget.product.productImages.length * 50) / 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.kwhiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.product.productImages.length,
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
          Text(widget.product.productName, style: theme.textTheme.titleMedium),
          const Text(
            "1 pack (160g - 180g)",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              const Text("₹66",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Text("MRP ₹160",
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.kgreyColorlite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorDimGrey)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                collapsedIconColor: const Color(0xFF0d821f),
                iconColor: const Color(0xFF0d821f),
                collapsedBackgroundColor: AppColors.kwhiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tilePadding: EdgeInsets.zero,
                title: const Text(
                  "View product details",
                  style: TextStyle(
                      color: Color.fromARGB(255, 16, 160, 38),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                children: [
                  Column(
                    children: [
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          // iconColor: const Color(0xFF0d821f),
                          backgroundColor: AppColors.kwhiteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          collapsedBackgroundColor: AppColors.kwhiteColor,
                          initiallyExpanded: true,
                          tilePadding: EdgeInsets.zero,
                          title: const Text(
                            "Highlights",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundColorWhite,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  highlightContent("Imported", "No"),
                                  highlightContent("Organic", "No"),
                                  highlightContent("About The Product",
                                      "Incorporate strawberries into your diet as a naturally sweet treat that can elevate your breakfast, desserts, or smoothies."),
                                  highlightContent("Brand", "No"),
                                  highlightContent("Good For", "Immunity"),
                                  highlightContent(
                                      "Product Type", "Strawberry"),
                                  highlightContent("Weight", "160 - 180 G"),
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
                          collapsedBackgroundColor: AppColors.kwhiteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tilePadding: EdgeInsets.zero,
                          initiallyExpanded: true,
                          title: const Text(
                            "Information",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundColorWhite,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  highlightContent("Imported", "No"),
                                  highlightContent("Organic", "No"),
                                  highlightContent("About The Product",
                                      "Incorporate strawberries into your diet as a naturally sweet treat that can elevate your breakfast, desserts, or smoothies."),
                                  highlightContent("Brand", "No"),
                                  highlightContent("Good For", "Immunity"),
                                  highlightContent(
                                      "Product Type", "Strawberry"),
                                  highlightContent("Weight", "160 - 180 G"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  Widget similerproducts({required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: AppColors.kwhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            "Similar Products",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(
            height: 270,
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ProductItem(
                        name: widget.product.productName,
                        price: 200,
                        imageurl: widget.product.productImages[0],
                        sellingpricecolor: "000000",
                        mrpColor: "000000",
                        offertextcolor: "000000",
                        productBgColor: "FFFFFF",
                        sellingPriceColor: "000000",
                        buttontextcolor: "000000",
                        buttonBgColor: "FFFFFF",
                        unitTextcolor: "000000",
                        offerbgcolor: "FFFFFF",
                        context: context,
                        product: widget.product),
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: 3),
          ),
        ],
      ),
    );
  }

  Widget productsYouMightAlsoLike({required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: AppColors.kwhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text("You might also like", style: theme.textTheme.titleMedium),
          SizedBox(
            height: 280,
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ProductItem(
                        name: widget.product.productName,
                        price: 200,
                        imageurl: widget.product.productImages[0],
                        sellingpricecolor: "000000",
                        mrpColor: "000000",
                        offertextcolor: "000000",
                        productBgColor: "FFFFFF",
                        sellingPriceColor: "000000",
                        buttontextcolor: "000000",
                        buttonBgColor: "FFFFFF",
                        unitTextcolor: "000000",
                        offerbgcolor: "FFFFFF",
                        context: context,
                        product: widget.product),
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: 3),
          ),
        ],
      ),
    );
  }

  Widget addtocartContainer({required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.kwhiteColor,
        border: Border(
          top: BorderSide(
            color: AppColors.buttonColorOrange, // Border color
            width: .3, // Border width
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "1 pack (160g - 180g)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                spacing: 5,
                children: [
                  const Text("₹66",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Text("MRP ₹160",
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.kgreyColorlite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorDimGrey)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                        color: AppColors.korangeColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "15% OFF",
                      style: TextStyle(
                          fontSize: 12,
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
              const SizedBox(
                height: 8,
              )
            ],
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Set border radius here
                ),
                backgroundColor: AppColors.addToCartBorder,
                minimumSize: const Size(152, 48),
              ),
              child: const Text("Add to Cart",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
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
