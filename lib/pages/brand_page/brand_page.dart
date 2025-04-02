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

class BrandPage extends StatefulWidget {
  final String brandid;
  const BrandPage({super.key, required this.brandid});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<BrandProductBloc>().add(FetchBrandProducts(widget.brandid));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder<BrandProductBloc, BrandProductState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: lightenColor(parseColor("ff0000"), .9),
            foregroundColor: lightenColor(parseColor("ff0000"), .9),
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
              const SizedBox(width: 20)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Orchard Bloom",
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                          ),
                          Text(
                            "Orchard Bloom brings you the freshest, most vibrant apples, hand-picked at the peak of ripeness. Our commitment to quality and natural growing practices ensures every bite is a burst of pure, orchard-fresh flavor.",
                            textAlign: TextAlign.left,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<BrandProductBloc, BrandProductState>(
                  builder: (context, state) {
                    if (state is BrandProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BrandProductLoaded) {
                      return StaggeredGrid.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 15,
                        children: List.generate(
                          state.products.length,
                          (index) => ProductItem(
                              subcategoryRef:
                                  state.products[index].subCategoryRef.first.id,
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
                              context: context,
                              product: state.products[index]),
                        ),
                      );
                    } else if (state is BrandProductError) {
                      return Center(child: Text(state.message));
                    }
                    return Center(child: Text("No products available"));
                  },
                ),
                const SizedBox(height: 20),
                const DescriptiveWidget(
                  textColor: '989898',
                  info: 'Delivery',
                  title: "Always on Your Time",
                  logo:
                      "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
                  showcategory: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
