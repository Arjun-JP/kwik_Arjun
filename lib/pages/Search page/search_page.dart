import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Search_bloc/Search_bloc.dart';
import 'package:kwik/bloc/Search_bloc/search_event.dart';
import 'package:kwik/bloc/Search_bloc/search_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/widgets/produc_model_1.dart';
import 'package:kwik/widgets/shimmer/search_page_shimmer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showInitialContent = true;

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(LoadInitialProducts());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _showInitialContent = true;
      });
      context.read<SearchBloc>().add(LoadInitialProducts());
    }
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _showInitialContent = false;
      });
      context
          .read<SearchBloc>()
          .add(SearchProducts(query, FirebaseAuth.instance.currentUser!.uid));
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                _buildSearchField(context),
                Expanded(
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: SearchPageShimmer());
                      } else if (state is ProductLoaded &&
                          _showInitialContent) {
                        return _buildInitialContent(state);
                      } else if (state is SearchresultProductLoaded) {
                        return _buildSearchResults(state);
                      } else if (state is ProductError) {
                        return const Center(
                            child: Text('Error loading products'));
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TypeAheadField<ProductModel>(
      debounceDuration: const Duration(milliseconds: 300),
      hideOnEmpty: true,
      hideOnLoading: false,
      hideOnError: true,
      controller: _searchController,
      focusNode: _searchFocusNode,
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onSubmitted: _onSearch,
          onChanged: (value) {
            _onSearch(value);
          },
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
            hintStyle: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            fillColor: AppColors.backgroundColorWhite,
            hintText: "Find your essentials...",
            prefixIcon: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearch('');
                    },
                  )
                : null,
          ),
        );
      },
      suggestionsCallback: (pattern) async {
        if (pattern.isEmpty) return [];
        final state = context.read<SearchBloc>().state;
        if (state is SearchresultProductLoaded) {
          final filteredProducts = state.products
              .where((product) => product.productName
                  .toLowerCase()
                  .contains(pattern.toLowerCase()))
              .toList();

          final result = filteredProducts.length > 10
              ? filteredProducts.sublist(0, 10)
              : filteredProducts;
          return result;
        }
        return [];
      },
      itemBuilder: (context, product) {
        // Change to ProductModel
        return InkWell(
          onTap: () => context.push(
            '/productdetails',
            extra: {
              'product': product,
              'subcategoryref': product.subCategoryRef.first.categoryRef,
              'buttonbg': parseColor("E23338"), // example color as a string
              'buttontext': parseColor("FFFFFF"),
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
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w800),
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
              style: theme.textTheme.bodyMedium!
                  .copyWith(fontSize: 12, fontWeight: FontWeight.w800),
            ),
            subtitle: product.variations.length > 1
                ? Text(
                    "${product.variations.length} Variations",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : Text(
                    "${product.variations.first.qty} ${product.variations.first.unit}",
                    //  - \₹${product.variations.first.sellingPrice}', // Assuming sellingPrice is available
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ), // Assuming sellingPrice is available
          ),
        );
      },
      onSelected: (product) {
        _searchController.text = product.productName;
        _onSearch(product.productName);
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
      // Add debounce
      hideOnSelect: true, // Add hideOnSelect if you want it
      hideOnUnfocus: true,
    );
  }

  Widget _buildInitialContent(ProductLoaded state) {
    return ListView(
      children: [
        _buildRecentSearches(state.searchHistory),
        const SizedBox(height: 15),
        _buildTopPicks(state.products),
      ],
    );
  }

  Widget _buildRecentSearches(List<String> searchHistory) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Text('Recent Searches'),
        const SizedBox(height: 10),
        Wrap(
          children: searchHistory
              .map((query) => InkWell(
                    onTap: () {
                      _searchController.text = query;
                      _onSearch(query);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 4),
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
                                Color.fromARGB(255, 249, 207, 143),
                                Color.fromARGB(255, 247, 221, 182),
                                Color.fromARGB(255, 248, 224, 188),
                                Color.fromARGB(255, 255, 240, 219),
                                Color.fromARGB(255, 253, 241, 224),
                              ]),
                          color: const Color.fromARGB(255, 255, 239, 214),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        query,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTopPicks(List<ProductModel> products) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Picks',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return SizedBox(
                child: ProductItem(
                  mrpColor: "A19DA3",
                  offertextcolor: "FFFFFF",
                  productBgColor: "FFFFFF",
                  sellingPriceColor: "233D4D",
                  buttontextcolor: "E23338",
                  unitTextcolor: "A19DA3",
                  product: product,
                  offerbgcolor: "E3520D",
                  buttonBgColor: "FFFFFF",
                  productnamecolor: "000000",
                  unitbgcolor: "FFFFFF",
                  subcategoryRef: product.subCategoryRef.first.id,
                  ctx: context,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(SearchresultProductLoaded state) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Top Results',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return SizedBox(
                  child: ProductItem(
                    mrpColor: "A19DA3",
                    offertextcolor: "FFFFFF",
                    productBgColor: "FFFFFF",
                    sellingPriceColor: "233D4D",
                    buttontextcolor: "E23338",
                    unitTextcolor: "A19DA3",
                    product: product,
                    offerbgcolor: "E3520D",
                    buttonBgColor: "FFFFFF",
                    productnamecolor: "000000",
                    unitbgcolor: "00FFFFFF",
                    subcategoryRef: product.subCategoryRef.first.id,
                    ctx: context,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
