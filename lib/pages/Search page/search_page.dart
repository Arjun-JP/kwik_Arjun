import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Search_bloc/Search_bloc.dart';
import 'package:kwik/bloc/Search_bloc/search_event.dart';
import 'package:kwik/bloc/Search_bloc/search_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/widgets/produc_model_1.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(LoadInitialProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    if (_searchController.text.isNotEmpty) {
      context.read<SearchBloc>().add(
            SearchProducts(
                _searchController.text, "67821e97640fb7573f33cba5", 1, 10),
          );
    }
  }

  Future<List<String>> searchProducts(String query) async {
    if (query.isEmpty) return [];
    final searchBloc = context.read<SearchBloc>();
    searchBloc.add(SearchProducts(query, "67821e97640fb7573f33cba5", 1, 10));
    await Future.delayed(const Duration(milliseconds: 500));
    final state = searchBloc.state;
    if (state is ProductLoaded) {
      return state.searchHistory;
    }
    return [];
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 45,
                  child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductLoaded) {
                      return TypeAheadField<ProductModel>(
                        // Change to ProductModel type
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            onSubmitted: (_) => _onSearch(),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: AppColors.dotColorUnSelected,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: .5,
                                  color: AppColors.dotColorUnSelected,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText:
                                  "Find your essentials...", // Updated hintText
                              filled: true,
                              hintStyle: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: AppColors.backgroundColorWhite,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () => context.pop(),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        suggestionsCallback: (pattern) async {
                          return state.products; // Use async for searchProducts
                        },
                        itemBuilder: (context, product) {
                          // Change to ProductModel
                          return InkWell(
                            onTap: () => context.push(
                              '/productdetails',
                              extra: {
                                'product': product,
                                'subcategoryref':
                                    product.subCategoryRef.first.id,
                              },
                            ),
                            child: ListTile(
                              dense: true,

                              leading: Image.network(
                                product.productImages.first,
                                width: 50,
                                height: 50,
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "₹ ${product.variations.first.sellingPrice.toStringAsFixed(0)}",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    "₹ ${product.variations.first.mrp.toStringAsFixed(0)}",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              title: Text(
                                product.productName,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w800),
                              ),
                              subtitle: product.productDescription != null
                                  ? Text(
                                      product.productDescription,
                                      //  - \₹${product.variations.first.sellingPrice}', // Assuming sellingPrice is available
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      '\$${product.variations.first.sellingPrice}'), // Assuming sellingPrice is available
                            ),
                          );
                        },
                        onSelected: (product) {
                          // Change to ProductModel
                          _searchController.text =
                              product.productName; // Use product.name
                          _onSearch();
                        },
                        decorationBuilder: (context, child) => DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColorWhite,
                            border: Border.all(
                              color: AppColors.dotColorUnSelected,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: child,
                        ),
                        debounceDuration:
                            const Duration(milliseconds: 300), // Add debounce
                        hideOnSelect: true, // Add hideOnSelect if you want it
                        hideOnUnfocus:
                            true, // Add hideOnUnfocus if you want it.
                      );
                    } else {
                      return SizedBox();
                    }
                  }),
                ),
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductLoaded) {
                      return Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Recent search",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "Clear",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: List.generate(
                                  state.searchHistory.length,
                                  (index) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            stops: [
                                              .1,
                                              .3,
                                              .5,
                                              .7,
                                              .9
                                            ],
                                            colors: [
                                              Color.fromARGB(
                                                  255, 249, 207, 143),
                                              Color.fromARGB(
                                                  255, 247, 221, 182),
                                              Color.fromARGB(
                                                  255, 248, 224, 188),
                                              Color.fromARGB(
                                                  255, 255, 240, 219),
                                              Color.fromARGB(
                                                  255, 253, 241, 224),
                                            ]),
                                        color: const Color.fromARGB(
                                            255, 255, 239, 214),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      state.searchHistory[index],
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Top picks for you",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 5),
                              StaggeredGrid.count(
                                crossAxisCount: 3,
                                mainAxisSpacing: 30,
                                crossAxisSpacing: 12,
                                children: List.generate(
                                  state.products.length,
                                  (index) => SizedBox(
                                    height: 278,
                                    child: ProductItem(
                                      mrpColor: "A19DA3",
                                      offertextcolor: "FFFFFF",
                                      productBgColor: "FFFFFF",
                                      sellingPriceColor: "233D4D",
                                      buttontextcolor: "E23338",
                                      unitTextcolor: "A19DA3",
                                      product: state.products[index],
                                      offerbgcolor: "E3520D",
                                      buttonBgColor: "FFFFFF",
                                      productnamecolor: "000000",
                                      unitbgcolor: "FFFFFF",
                                      subcategoryRef: state.products[index]
                                          .subCategoryRef.first.id,
                                      context: context,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is ProductError) {
                      return const Center(
                          child: Text("Failed to load products"));
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
