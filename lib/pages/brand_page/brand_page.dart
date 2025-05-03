import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/brand_products/brand_products_bloc.dart';
import 'package:kwik/bloc/brand_products/brand_products_event.dart';
import 'package:kwik/bloc/brand_products/brand_products_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/product1_grid_Shimnmer.dart';
import 'package:url_launcher/url_launcher.dart';

class BrandPage extends StatefulWidget {
  final String brandid;
  final String brandname;
  final String branddes;
  final String brandimageurl;
  final String websiteurl;
  final String color;
  const BrandPage(
      {super.key,
      required this.brandid,
      required this.brandname,
      required this.branddes,
      required this.brandimageurl,
      required this.websiteurl,
      required this.color});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  void initState() {
    super.initState();
    context.read<BrandProductBloc>().add(FetchBrandProducts(widget.brandid));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder<BrandProductBloc, BrandProductState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: lightenColor(parseColor(widget.color), .9),
            foregroundColor: lightenColor(parseColor(widget.color), .9),
            toolbarHeight: 40,
            leading: InkWell(
              onTap: () {
                context.pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.push('/searchpage');
                },
                child: SvgPicture.asset(
                  "assets/images/search.svg",
                  fit: BoxFit.contain,
                  width: 30,
                  height: 20,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: SingleChildScrollView(
            // Prevents layout overflow
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.brandname,
                              style: theme.textTheme.headlineMedium!
                                  .copyWith(color: parseColor(widget.color)),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                            ),
                            Text(
                              widget.branddes,
                              textAlign: TextAlign.left,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 2),
                            InkWell(
                              onTap: () async {
                                Uri uri = Uri.parse(widget.websiteurl);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  throw 'Could not launch ${widget.websiteurl}';
                                }
                              },
                              child: Text(
                                "Discover more about this brand!",
                                textAlign: TextAlign.left,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 12, 174, 249)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        shadowColor: parseColor(widget.color),
                        // surfaceTintColor: parseColor(widget.color),
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          height: 80,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                widget.brandimageurl,
                              ))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<BrandProductBloc, BrandProductState>(
                    builder: (context, state) {
                      if (state is BrandProductLoading) {
                        return const Center(child: ProductModel1GridShimmer());
                      } else if (state is BrandProductLoaded) {
                        if (state.products.isEmpty) {
                          return const Center(
                              child: Text("No products available"));
                        }
                        return StaggeredGrid.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                          children: List.generate(
                            state.products.length,
                            (index) => SizedBox(
                              height: 278,
                              child: ProductItem(
                                subcategoryRef: state
                                    .products[index].subCategoryRef.first.id,
                                productnamecolor: "000000",
                                mrpColor: "A19DA3",
                                offertextcolor: "FFFFFF",
                                productBgColor: "FFFFFF",
                                sellingPriceColor: "000000",
                                buttontextcolor: "E23338",
                                buttonBgColor: "FFFFFF",
                                unitTextcolor: "A19DA3",
                                unitbgcolor: "FFFFFF",
                                offerbgcolor: "E3520D",
                                ctx: context,
                                product: state.products[index],
                              ),
                            ),
                          ),
                        );
                      } else if (state is BrandProductError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink(); // Avoids layout errors
                    },
                  ),
                  const SizedBox(height: 20),
                  const DescriptiveWidget(
                    title: "Skip the store, we're at your door!",
                    logo:
                        "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
                    showcategory: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
