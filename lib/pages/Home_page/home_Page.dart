// ignore_for_file: use_build_context_synchronously, use_full_hex_values_for_flutter_colors, curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/Search_bloc/Search_bloc.dart';
import 'package:kwik/bloc/Search_bloc/search_event.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_bloc.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_event.dart';
import 'package:kwik/bloc/force_update_bloc/force_update_bloc.dart'
    show UpdateBloc;
import 'package:kwik/bloc/force_update_bloc/force_update_event.dart';
import 'package:kwik/bloc/force_update_bloc/force_update_state.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_13_bloc/category_model_13_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_13_bloc/category_model_13_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_16_bloc/category_model_16_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_16_bloc/category_model_16_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_18_bloc/category_model_18_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_18_bloc/category_model_18_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_19_bloc/category_model_19_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_19_bloc/category_model_19_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_2_bloc/category_model2_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_12_bloc/category_model_12_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_4_bloc/category_model_4_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_5__Bloc/category_model5__event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_6_bloc/category_model_6_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_6_bloc/category_model_6_event.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_9_bloc/category_model_9_bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_State.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_bloc.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_event.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_product_bloc.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_product_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/network_check.dart';
import 'package:kwik/models/order_model.dart' as locationmode;
import 'package:kwik/pages/Address_management/location_search_page.dart';
import 'package:kwik/pages/Force%20Update%20page/force_update.dart';
import 'package:kwik/pages/Home_page/widgets/banner_model.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_10.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_12.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_14.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_15.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_16.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_17.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_18.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_19.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_2.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_3.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_4.dart';
import 'package:kwik/pages/Home_page/widgets/category_model_9.dart';
import 'package:kwik/pages/Home_page/widgets/descriptive_widget.dart';
import 'package:kwik/pages/No_service_page/no_service_page.dart';
import 'package:kwik/pages/No_service_page/under_maintanance_screen.dart';
import 'package:kwik/widgets/navbar/navbar.dart';
import 'package:kwik/widgets/shimmer/main_loading_indicator.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';
import '../../bloc/home_page_bloc/category_model_1_bloc/category_model1_event.dart';
import '../../bloc/home_page_bloc/category_model_2_bloc/category_model2_event.dart';
import '../../bloc/home_page_bloc/category_model_10_bloc/category_model_10_bloc.dart';
import '../../bloc/home_page_bloc/category_model_10_bloc/category_model_10_event.dart';
import '../../bloc/home_page_bloc/category_model_12_bloc/category_model_12_event.dart';
import '../../bloc/home_page_bloc/category_model_4_bloc/category_model_4_event.dart';
import '../../bloc/home_page_bloc/category_model_7_bloc/category_model_7_bloc.dart';
import '../../bloc/home_page_bloc/category_model_7_bloc/category_model_7_event.dart';
import '../../bloc/home_page_bloc/category_model_9_bloc/category_model_9_event.dart';
import 'package:geolocator/geolocator.dart';
import '../../bloc/navbar_bloc/navbar_event.dart';
import 'widgets/category_model_1.dart';
import 'widgets/category_model_5.dart';
import 'widgets/category_model_6.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<AddressState>? _addressSubscription;
  bool _isInitialized = false;

  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NetworkUtils.checkConnection(context);
      await forceupdate();
      await _initializeAppWithWarehouseCheck(); // Combined initialization
      if (mounted) {
        context.read<HomeUiBloc>().add(FetchUiDataEvent());
        context.read<CartBloc>().add(
            SyncCartWithServer(userId: FirebaseAuth.instance.currentUser!.uid));
      }
    });
  }

  Future<void> _initializeAppWithWarehouseCheck() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null && mounted) {
      GoRouter.of(context).go('/loginPage');
      return;
    }

    if (_isInitialized) {
      print("Skipped the initial call");
      return;
    }

    // Show loading indicator
    // You might want to use a state variable to control this
    setState(() {
      _isInitialized = true;
    });

    try {
      // First check warehouse status
      await getwarehousedata();

      // Only proceed if warehouse is available
      final addressBloc = context.read<AddressBloc>();
      final addressState = addressBloc.state;

      if (addressState is LocationSearchResults &&
          addressState.warehouse != null &&
          addressState.warehouse?.underMaintenance != true) {
        // Initialize other app components
        context.read<HomeUiBloc>().add(FetchUiDataEvent());
        context.read<CartBloc>().add(SyncCartWithServer(userId: user!.uid));
      }
    } catch (e) {
      print("Initialization error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Initialization error: ${e.toString()}")));
      }
    }
  }

  Future<void> getwarehousedata() async {
    print("Initializing warehouse data fetch");
    try {
      final addressBloc = context.read<AddressBloc>();
      final currentState = addressBloc.state;

      // Check if we already have a valid warehouse
      if (currentState is LocationSearchResults &&
          currentState.warehouse != null) {
        print("Warehouse already available - skipping fetch");
        return;
      }

      // First try to use saved address if available
      if (currentState is LocationSearchResults &&
          currentState.selecteaddress != null &&
          currentState.warehouse == null) {
        print("Using existing saved address for warehouse lookup");
        final selectedAddress = currentState.selecteaddress!;
        await _fetchWarehouseByAddress(
            selectedAddress.pincode,
            locationmode.Location(
              lat: selectedAddress.location.lat,
              lang: selectedAddress.location.lang,
            ),
            "${currentState.selecteaddress?.flatNoName},${currentState.selecteaddress?.area}");
        return;
      }

      // If no saved address or warehouse, try getting saved address first
      print("Fetching saved addresses");
      addressBloc.add(const GetsavedAddressEvent());

      // Wait for address state update
      final addressState = await addressBloc.stream
          .firstWhere(
            (state) => state is! AddressLoading,
          )
          .timeout(const Duration(seconds: 5))
          .catchError((_) => const AddressError("Timeout"));

      if (addressState is LocationSearchResults &&
          addressState.selecteaddress != null) {
        print("Using newly fetched saved address");
        final selectedAddress = addressState.selecteaddress!;
        await _fetchWarehouseByAddress(
          selectedAddress.pincode,
          locationmode.Location(
            lat: selectedAddress.location.lat,
            lang: selectedAddress.location.lang,
          ),
          "${selectedAddress.flatNoName},${selectedAddress.area}",
        );
        return;
      }

      // Fall back to current location only if no saved address works
      print("No saved address available - checking location permission");
      // final hasPermission = await _checkLocationPermission();
      // if (!hasPermission && mounted) {
      //   await _showLocationPermissionSheet();
      //   return;
      // }

      print("Getting current location");
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final postalCode = placemarks.first.postalCode;

      if (postalCode != null) {
        await _fetchWarehouseByAddress(
            postalCode,
            locationmode.Location(
              lat: position.latitude,
              lang: position.longitude,
            ),
            "${placemarks.first.street ?? ""},${placemarks.first.subLocality ?? ""},${placemarks.first.locality ?? ""}");
      } else if (mounted) {
        print("Postal code not found - navigating to no service");
        GoRouter.of(context).go('/no-service');
      }
    } catch (e) {
      print("Error in getwarehousedata: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error getting location: ${e.toString()}")),
        );
        GoRouter.of(context).go('/no-service');
      }
    }
  }

  Future<void> _fetchWarehouseByAddress(String pincode,
      locationmode.Location location, String usedaddress) async {
    if (!mounted) return;

    final addressBloc = context.read<AddressBloc>();
    print("Fetching warehouse for pincode: $pincode");
    addressBloc.add(GetWarehousedetailsEvent(pincode, location, usedaddress));

    try {
      final warehouseState = await addressBloc.stream
          .firstWhere(
            (state) =>
                state is NowarehousefoudState ||
                (state is LocationSearchResults && state.warehouse != null),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (warehouseState is NowarehousefoudState) {
        print("No warehouse found - navigating to no service");
        GoRouter.of(context).go('/no-service');
      } else if (warehouseState is LocationSearchResults) {
        if (warehouseState.warehouse?.underMaintenance == true) {
          print("Warehouse under maintenance");
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                UnderMaintananceScreen(warehouse: warehouseState.warehouse!),
          ));
        }
        print("Warehouse found and set");
      }
    } catch (e) {
      print("Warehouse lookup timeout/error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Warehouse lookup timed out")),
        );
        GoRouter.of(context).go('/no-service');
      }
    }
  }

  forceupdate() async {
    context.read<UpdateBloc>().add(CheckForUpdate(context));
    final updateBloc = BlocProvider.of<UpdateBloc>(context);
    final updateState = updateBloc.state;

    if (updateState is UpdateAvailable) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForceUpdatePage(
            title: updateState.title,
            description: updateState.description,
            downloadUrl: updateState.downloadUrl,
          ),
        ),
      );
    } else {}
  }

  // Future<void> _checkLocationAndFetchWarehouse() async {
  //   print("calledddddd");
  //   try {
  //     final hasPermission = await _checkLocationPermission();
  //     if (!hasPermission && mounted) {
  //       await _showLocationPermissionSheet();
  //       return; // Don't proceed if permission is not granted
  //     }

  //     Position position = await Geolocator.getCurrentPosition();
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );
  //     print("print placemark ${placemarks}");
  //     final postalCode = placemarks.first.postalCode;
  //     print(postalCode);
  //     if (postalCode != null) {
  //       context.read<AddressBloc>().add(GetWarehousedetailsEvent(
  //             postalCode,
  //             locationmode.Location(
  //               lat: position.latitude,
  //               lang: position.longitude,
  //             ),
  //           ));
  //     } else {
  //       // Handle case where postal code is not available
  //       if (mounted) {
  //         // Optionally show an error or try a different approach
  //         print("Postal code not found");
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       print("Error fetching location or warehouse: $e");
  //       // Optionally show an error to the user
  //     }
  //   }
  // }

  Future<void> _onRefresh() async {
    context.read<HomeUiBloc>().add(ClearUiCacheEvent());

    // Clear all category caches
    final blocsToClear = [
      BlocProvider.of<CategoryBlocModel1>(context),
      BlocProvider.of<CategoryBlocModel2>(context),
      BlocProvider.of<CategoryModel4Bloc>(context),
      BlocProvider.of<CategoryBloc5>(context),
      BlocProvider.of<CategoryBlocModel6>(context),
      BlocProvider.of<CategoryModel7Bloc>(context),
      BlocProvider.of<CategoryBloc9>(context),
      BlocProvider.of<CategoryModel10Bloc>(context),
      BlocProvider.of<CategoryBloc12>(context),
      BlocProvider.of<CategoryBloc13>(context),
      BlocProvider.of<CategoryBlocModel16>(context),
      BlocProvider.of<CategoryBloc18>(context),
      BlocProvider.of<CategoryBloc19>(context),
      BlocProvider.of<SubcategoryProductBloc>(context),
      BlocProvider.of<SearchBloc>(context),
      BlocProvider.of<RecommendedProductsBloc>(context),
    ];

    for (final bloc in blocsToClear) {
      if (bloc is CategoryBlocModel1)
        bloc.add(ClearCache());
      else if (bloc is CategoryBlocModel2)
        bloc.add(ClearCacheCM2());
      else if (bloc is CategoryModel4Bloc)
        bloc.add(Clearsubcatproduct1Cache());
      else if (bloc is CategoryBloc5)
        bloc.add(ClearCacheEventCM5());
      else if (bloc is CategoryBlocModel6)
        bloc.add(ClearCacheCM6());
      else if (bloc is CategoryModel7Bloc)
        bloc.add(Clearsubcatproduct7Cache());
      else if (bloc is CategoryBloc9)
        bloc.add(ClearCacheEventCM9());
      else if (bloc is CategoryModel10Bloc)
        bloc.add(Clearsubcatproduct10Cache());
      else if (bloc is CategoryBloc12)
        bloc.add(ClearCacheEventCM12());
      else if (bloc is CategoryBloc13)
        bloc.add(ClearCacheEventCM13());
      else if (bloc is CategoryBlocModel16)
        bloc.add(ClearCacheCM16());
      else if (bloc is CategoryBloc18)
        bloc.add(ClearCacheEventCM18());
      else if (bloc is CategoryBloc19)
        bloc.add(ClearCacheEventCM19());
      else if (bloc is SubcategoryProductBloc)
        bloc.add(ClearSimilarCache());
      else if (bloc is SearchBloc)
        bloc.add(ClearCachesearch());
      else if (bloc is RecommendedProductsBloc)
        bloc.add(ClearRecommendedproductCache());
    }
    context.read<AllSubCategoryBloc>().add(const ClearAllCategoryCache());
    context.read<HomeUiBloc>().add(FetchUiDataEvent());
  }

  @override
  void dispose() {
    _addressSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeUiBloc, HomeUiState>(
      builder: (context, homeUiState) {
        final addressState = context.watch<AddressBloc>().state;

        if (homeUiState is UiInitial ||
            homeUiState is UiLoading ||
            addressState is AddressLoading) {
          return const Center(child: MainLoadingIndicator());
        }

        // Show HomePageContent ONLY when both HomeUi is loaded AND warehouse data is available
        if (homeUiState is UiLoaded &&
            addressState is LocationSearchResults &&
            addressState.warehouse != null) {
          return _HomePageContent(
            uiData: homeUiState.uiData,
            searchTerm: homeUiState.searchterm,
            onRefresh: _onRefresh,
          );
        }

        // Navigate and show "No Service" Page
        if (addressState is NowarehousefoudState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/no-service');
          });
          return const SizedBox(); // Return an empty widget,  Navigator is handled.
        }

        //show error
        if (addressState is AddressError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home Page')),
            body: Center(child: Text('Error: ${addressState.message}')),
          );
        }

        // Handle cases where HomeUi is loaded but warehouse is still loading or not found
        if (homeUiState is UiLoaded &&
            addressState is LocationSearchResults &&
            addressState.warehouse == null) {
          print("thius is running");
          return const NoServicePage();
        }

        // Default case when HomeUi might not be loaded yet or other AddressStates
        return const SizedBox();
      },
    );
  }
}

class _HomePageContent extends StatefulWidget {
  final Map<String, dynamic> uiData;
  final String searchTerm;
  final Future<void> Function() onRefresh;

  const _HomePageContent({
    required this.uiData,
    required this.searchTerm,
    required this.onRefresh,
  });

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _isLoadingMore = false;
  static const int _widgetsPerPage = 6;
  List<Map<String, dynamic>> _allTemplates = [];

  @override
  void initState() {
    super.initState();
    _allTemplates = _buildAllTemplates();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreWidgets();
    }
  }

  void _loadMoreWidgets() {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _currentPage++;
          _isLoadingMore = false;
        });
      }
    });
  }

  List<Map<String, dynamic>> _getVisibleTemplates() {
    final endIndex =
        ((_currentPage + 1) * _widgetsPerPage).clamp(0, _allTemplates.length);
    return _allTemplates.sublist(0, endIndex);
  }

  List<Map<String, dynamic>> _buildAllTemplates() {
    final categoryRef =
        List<String>.from(widget.uiData["categorylist"]["category_ref"]);
    final templates = [
      // Banner templates
      {
        'template': BannerModel1(
          titlecolor: widget.uiData["template2"]["title_color"],
          bgColor: widget.uiData["template2"]["background_color"],
          bannerId: 1,
          height: 0.35,
          horizontalpadding: 10,
          borderradious: 20,
          showbanner: widget.uiData["template2"]["show_Category"],
        ),
        'order': widget.uiData["template2"]["ui_order_number"]
      },

      {
        'template': BannerModel1(
          titlecolor: widget.uiData["template5"]["title_color"],
          bgColor: widget.uiData["template5"]["background_color"],
          bannerId: 3,
          height: 0.8,
          horizontalpadding: 0,
          borderradious: 0,
          showbanner: widget.uiData["template5"]["show_Category"],
        ),
        'order': widget.uiData["template5"]["ui_order_number"]
      },
      {
        'template': BannerModel1(
          titlecolor: widget.uiData["template21"]["title_color"],
          bgColor: widget.uiData["template21"]["background_color"],
          bannerId: 2,
          height: 0.45,
          viewportFraction: .8,
          verticalpadding: 10,
          borderradious: 20,
          showbanner: widget.uiData["template21"]["show_Category"],
        ),
        'order': widget.uiData["template21"]["ui_order_number"]
      },

      // Home page dynamic widgets in the created order

      {
        'template': CategoryModel1(
          title: widget.uiData["categorylist"]["title"],
          bgColor: widget.uiData["categorylist"]["background_color"],
          categories: categoryRef,
          titlecolor: widget.uiData["categorylist"]["title_color"],
          textcolor: widget.uiData["categorylist"]["subcategory_color"],
          showcategory: widget.uiData["categorylist"]["show_Category"],
        ),
        'order': widget.uiData["categorylist"]["ui_order_number"]
      },

      {
        'template': CategoryModel2(
          categoryId: widget.uiData["template7"]["category_ref"],
          bgcolor: widget.uiData["template7"]["background_color"],
          titleColor: widget.uiData["template7"]["title_color"],
          subcatColor: widget.uiData["template7"]["subcat_color"],
          showcategory: widget.uiData["template7"]["show_Category"],
          title: widget.uiData["template7"]["title"],
        ),
        'order': widget.uiData["template7"]["ui_order_number"]
      },
      {
        'template': CategoryModel3(
          maincategories: List<String>.from(
              widget.uiData["template3"]["main_sub_category"]),
          secondarycategories: List<String>.from(
              widget.uiData["template3"]["secondary_sub_category"]),
          categoryId: widget.uiData["template3"]["category_ref"],
          bgcolor: widget.uiData["template3"]["background_color"],
          titleColor: widget.uiData["template3"]["title_color"],
          subcatColor: widget.uiData["template3"]["subcat_color"],
          showcategory: widget.uiData["template3"]["show_Category"],
          title: widget.uiData["template3"]["title"],
        ),
        'order': widget.uiData["template3"]["ui_order_number"]
      },
      {
        'template': CategoryModel3(
          maincategories: List<String>.from(
              widget.uiData["template4"]["main_sub_category"]),
          secondarycategories: List<String>.from(
              widget.uiData["template4"]["secondary_sub_category"]),
          categoryId: widget.uiData["template4"]["category_ref"],
          bgcolor: widget.uiData["template4"]["background_color"],
          titleColor: widget.uiData["template4"]["title_color"],
          subcatColor: widget.uiData["template4"]["subcat_color"],
          showcategory: widget.uiData["template4"]["show_Category"],
          title: widget.uiData["template4"]["title"],
        ),
        'order': widget.uiData["template4"]["ui_order_number"]
      },

      {
        'template': CategoryModel4(
          categoryref: widget.uiData["template6"]["category_ref"],
          buttonbgcolor: widget.uiData["template6"]["buttonbgcolor"],
          buttontextcolor: widget.uiData["template6"]["buttontextcolor"],
          offerbgcolor: widget.uiData["template6"]["offerbgcolor"],
          offertextcolor: widget.uiData["template6"]["offertextcolor"],
          offertext2: widget.uiData["template6"]["offertext2"],
          offerborder: widget.uiData["template6"]["offerborder"],
          unitcolor: widget.uiData["template6"]["unitcolor"],
          seeAllButtonBG: widget.uiData["template6"]["seeAllButtonBG"],
          seeAllButtontext: widget.uiData["template6"]["seeAllButtontext"],
          mrpColor: widget.uiData["template6"]["mrp_color"],
          sellingpricecolor: widget.uiData["template6"]["selling_price_color"],
          title: widget.uiData["template6"]["title"],
          subtitle: widget.uiData["template6"]["subtitle"],
          subCategoryId: widget.uiData["template6"]["sub_category_ref"],
          bgcolor: widget.uiData["template6"]["background_color"],
          titleColor: widget.uiData["template6"]["title_color"],
          subtitlecolor: widget.uiData["template6"]["title_color"],
          productColor: widget.uiData["template6"]["subcat_color"],
          showcategory: widget.uiData["template6"]["show_Category"],
        ),
        'order': widget.uiData["template6"]["ui_order_number"]
      },

      {
        'template': CategoryModel5(
          producttextcolor: widget.uiData["template8"]["producttextcolor"],
          maincategories:
              List<String>.from(widget.uiData["template8"]["sub_categories"]),
          categoryId: widget.uiData["template8"]["category_ref"],
          bgcolor: widget.uiData["template8"]["background_color"],
          titleColor: widget.uiData["template8"]["title_color"],
          subcatColor: widget.uiData["template8"]["subcat_color"],
          offerBGcolor: widget.uiData["template8"]["offer_bg_color"],
          mrpColor: widget.uiData["template8"]["mrp_color"],
          productBgColor: widget.uiData["template8"]
              ["product_background_color"],
          sellingPriceColor: widget.uiData["template8"]["saleprice_color"],
          categoryName: widget.uiData["template8"]["category_name"],
          brandImage: widget.uiData["template8"]["brand_image"],
          showcategory: widget.uiData["template8"]["show_Category"],
          buttonbgcolor: widget.uiData["template8"]["buttonbgcolor"],
          buttontextcolor: widget.uiData["template8"]["buttontextcolor"],
          indicatercolor: widget.uiData["template8"]["indicatercolor"],
          offertextcolor: widget.uiData["template8"]["offertextcolor"],
          unitcolor: widget.uiData["template8"]["unitcolor"],
          unitbgcolor: widget.uiData["template8"]["unitbgcolor"],
          seeallbuttonbg: widget.uiData["template8"]["seeallbuttonbg"],
          seeallbuttontext: widget.uiData["template8"]["seeallbuttontext"],
        ),
        'order': widget.uiData["template8"]["ui_order_number"]
      },

      {
        'template': CategoryModel6(
          title: widget.uiData["template9"]["title"],
          outerbordercolor: widget.uiData["template9"]["outerbordercolor"],
          subcategories:
              List<String>.from(widget.uiData["template9"]["sub_categories"]),
          bgcolor: widget.uiData["template9"]["background_color"],
          titleColor: widget.uiData["template9"]["title_color"],
          catnamecolor: widget.uiData["template9"]["subcat_color"],
          offertextcolor: widget.uiData["template9"]["offer_text_color"],
          offerbgcolor: widget.uiData["template9"]["offer_bg_color"],
          catnamebgcolor: widget.uiData["template9"]["subcatbg_color"],
          showcategory: widget.uiData["template9"]["show_Category"],
        ),
        'order': widget.uiData["template9"]["ui_order_number"]
      },

      {
        'template': CategoryModel9(
          seeAllButtonBG: widget.uiData["template12"]["seeAllButtonBG"],
          seeAllButtontext: widget.uiData["template12"]["seeAllButtontext"],
          maincategories:
              List<String>.from(widget.uiData["template12"]["maincategories"]),
          categoryId: widget.uiData["template12"]["categoryId"],
          bgcolor: widget.uiData["template12"]["bgcolor"],
          titleColor: widget.uiData["template12"]["titleColor"],
          subcatColor: widget.uiData["template12"]["offerBGcolor"],
          offerBGcolor: widget.uiData["template12"]["offerBGcolor"],
          mrpColor: widget.uiData["template12"]["mrpColor"],
          productBgColor: widget.uiData["template12"]["productBgColor"],
          sellingPriceColor: widget.uiData["template12"]["sellingPriceColor"],
          buttontextcolor: widget.uiData["template12"]["buttontextcolor"],
          buttonbgcolor: widget.uiData["template12"]["button_bgcolor"],
          offerTextcolor: widget.uiData["template12"]["offerTextcolor"],
          title: widget.uiData["template12"]["title"],
          unitTextcolor: widget.uiData["template12"]["unitTextcolor"],
          unitbgcolor: widget.uiData["template12"]["unitbgcolor"],
          showcategory: widget.uiData["template12"]["show_Category"],
        ),
        'order': widget.uiData["template12"]["ui_order_number"]
      },
      {
        'template': CategoryModel10(
          subCatID: widget.uiData["template13"]["category_ref"],
          offerbgcolor: widget.uiData["template13"]["offer_bg_color"],
          offertextcolor: widget.uiData["template13"]["offer_text_color"],
          title: widget.uiData["template13"]["title"],
          titleColor: widget.uiData["template13"]["titleColor"],
          bgcolor: widget.uiData["template13"]["background_color"],
          image: widget.uiData["template13"]["image"],
          cartbuttontextcolor: widget.uiData["template13"]
              ["cartbuttontextcolor"],
          mrpcolor: widget.uiData["template13"]["mrpcolor"],
          crosscolor: widget.uiData["template13"]["crosscolor"],
          prodoductbgcolor: widget.uiData["template13"]["prodoductbgcolor"],
          productTextColor: widget.uiData["template13"]["productTextColor"],
          sellingpricecolor: widget.uiData["template13"]["sellingpricecolor"],
          seeAllButtonBG: widget.uiData["template13"]["seeAllButtonBG"],
          seeAllButtontext: widget.uiData["template13"]["seeAllButtontext"],
          showcategory: widget.uiData["template13"]["show_Category"],
          buttonbgcolor: widget.uiData["template13"]["Button_bg_color"],
          buttontextcolor: widget.uiData["template13"]["button_text_color"],
          unitTextcolor: widget.uiData["template13"]["unitTextcolor"],
          unitbgcolor: widget.uiData["template13"]["unitbgcolor"],
        ),
        'order': widget.uiData["template13"]["ui_order_number"]
      },

      {
        'template': CategoryModel12(
          producttextcolor: widget.uiData["template14"]["producttextcolor"],
          topimage: widget.uiData["template14"]["top_image"],
          seeAllButtonBG: widget.uiData["template14"]["seeAllButtonBG"],
          seeAllButtontext: widget.uiData["template14"]["seeAllButtontext"],
          maincategories:
              List<String>.from(widget.uiData["template14"]["maincategories"]),
          categoryId: widget.uiData["template14"]["category_ref"],
          bgcolor: widget.uiData["template14"]["bgcolor"],
          subcatColor: widget.uiData["template14"]["bgcolor"],
          mrpColor: widget.uiData["template14"]["mrpColor"],
          productBgColor: widget.uiData["template14"]["productBgColor"],
          sellingPriceColor: widget.uiData["template14"]["sellingPriceColor"],
          buttontextcolor: widget.uiData["template14"]["buttontextcolor"],
          buttonbgcolor: widget.uiData["template14"]["btton_bg_color"],
          offerTextcolor: widget.uiData["template14"]["offerTextcolor"],
          offerbgcolor: widget.uiData["template14"]["offerBGcolor"],
          unitTextcolor: widget.uiData["template14"]["unitTextcolor"],
          unitbgcolor: widget.uiData["template14"]["unitbgcolor"],
          showcategory: widget.uiData["template14"]["show_Category"],
        ),
        'order': widget.uiData["template14"]["ui_order_number"]
      },

      {
        'template': CategoryModel14(
          producttextcolor: widget.uiData["template15"]["producttextcolor"],
          maincategories:
              List<String>.from(widget.uiData["template15"]["sub_categories"]),
          categoryId: widget.uiData["template15"]["category_ref"],
          bgcolor: widget.uiData["template15"]["background_color"],
          bgcolor2: widget.uiData["template15"]["bgcolor2"],
          titleColor: widget.uiData["template15"]["titleColor"],
          subcatColor: widget.uiData["template15"]["subcat_color"],
          offerBGcolor: widget.uiData["template15"]["offer_bg_color"],
          mrpColor: widget.uiData["template15"]["mrp_color"],
          productBgColor: widget.uiData["template15"]
              ["product_background_color"],
          sellingPriceColor: widget.uiData["template15"]["saleprice_color"],
          categoryName: widget.uiData["template15"]["category_name"],
          brandImage: widget.uiData["template15"]["brand_image"],
          indicatercolor: widget.uiData["template15"]["indicatercolor"],
          buttonbgcolor: widget.uiData["template15"]["buttonbgcolor"],
          buttontextcolor: widget.uiData["template15"]["buttontextcolor"],
          offertextcolor: widget.uiData["template15"]["offertextcolor"],
          unitbgcolor: widget.uiData["template15"]["unitbgcolor"],
          unitcolor: widget.uiData["template15"]["unit_text_color"],
          subcatbgcolor: widget.uiData["template15"]["subcatbgcolor"],
          seeallbgclr: widget.uiData["template15"]["seeallbgclr"],
          seealltextcolor: widget.uiData["template15"]["seealltextcolor"],
          showcategory: widget.uiData["template15"]["show_Category"],
        ),
        'order': widget.uiData["template15"]["ui_order_number"]
      },
      {
        'template': CategoryModel15(
          topimage: widget.uiData["template16"]["top_image"],
          seeAllButtonBG: widget.uiData["template16"]["seeAllButtonBG"],
          seeAllButtontext: widget.uiData["template16"]["seeAllButtontext"],
          productnamecolor: widget.uiData["template16"]["producttitlecolor"],
          offerbgcolor: widget.uiData["template16"]["offerbgcolor"],
          maincategories:
              List<String>.from(widget.uiData["template16"]["maincategories"]),
          categoryId: widget.uiData["template16"]["category_ref"],
          bgcolor: widget.uiData["template16"]["bgcolor"],
          subcatColor: widget.uiData["template16"]["bgcolor"],
          mrpColor: widget.uiData["template16"]["mrpColor"],
          productBgColor: widget.uiData["template16"]["productBgColor"],
          sellingPriceColor: widget.uiData["template16"]["sellingPriceColor"],
          buttontextcolor: widget.uiData["template16"]["buttontextcolor"],
          buttonbgcolor: widget.uiData["template16"]["buttonbgcolor"],
          offerTextcolor: widget.uiData["template16"]["offerTextcolor"],
          unitTextcolor: widget.uiData["template16"]["unitTextcolor"],
          unitbgcolor: widget.uiData["template16"]["unitbgcolor"],
          showcategory: widget.uiData["template16"]["show_Category"],
        ),
        'order': widget.uiData["template16"]["ui_order_number"]
      },
      {
        'template': CategoryModel16(
          subcategroylist:
              List<String>.from(widget.uiData["template17"]["subcategorylist"]),
          categorybgcolor: widget.uiData["template17"]["categorybgcolor"],
          offerbgcolor: widget.uiData["template17"]["offerbgcolor"],
          offertext1: widget.uiData["template17"]["offertext1"],
          offertext2: widget.uiData["template17"]["offertext2"],
          title: widget.uiData["template17"]["title"],
          categoryId: widget.uiData["template17"]["category"],
          bgcolor: widget.uiData["template17"]["background_color"],
          titleColor: widget.uiData["template17"]["titleColor"],
          subcattitleColor: widget.uiData["template17"]["subcattitleColor"],
          showcategory: widget.uiData["template17"]["show_Category"],
        ),
        'order': widget.uiData["template17"]["ui_order_number"]
      },
      {
        'template': CategoryModel17(
          category: widget.uiData["template18"]["categoryid"],
          categoryId1: widget.uiData["template18"]["categoryId1"],
          categoryId2: widget.uiData["template18"]["categoryId2"],
          categoryId3: widget.uiData["template18"]["categoryId3"],
          image1: widget.uiData["template18"]["image1"],
          image2: widget.uiData["template18"]["image2"],
          image3: widget.uiData["template18"]["image3"],
          title: widget.uiData["template18"]["title"],
          bgcolor: widget.uiData["template18"]["background_color"],
          titleColor: widget.uiData["template18"]["title_color"],
          showcategory: widget.uiData["template18"]["show_Category"],
        ),
        'order': widget.uiData["template18"]["ui_order_number"]
      },
      {
        'template': CategoryModel18(
          maincategories:
              List<String>.from(widget.uiData["template19"]["maincategories"]),
          categoryId: widget.uiData["template19"]["category_ref"],
          bgcolor: widget.uiData["template19"]["background_color"],
          offerBGcolor: widget.uiData["template19"]["offer_bg_color"],
          showcategory: widget.uiData["template19"]["show_Category"],
          bannerimageurl: widget.uiData["template19"]["bannerimageurl"],
          categoryBgColor: widget.uiData["template19"]["categoryBgColor"],
          categorytitlecolor: widget.uiData["template19"]["categorytitlecolor"],
          offertextcolor1: widget.uiData["template19"]["offertextcolor1"],
          offertextcolor2: widget.uiData["template19"]["offertextcolor2"],
          seeallbuttonbgcolor: widget.uiData["template19"]["seeallbuttonbg"],
          seeallbuttontextcolor: widget.uiData["template19"]
              ["seeallbuttontext"],
        ),
        'order': widget.uiData["template19"]["ui_order_number"]
      },
      {
        'template': CategoryModel19(
          producttextcolor: widget.uiData["template20"]["producttextcolor"],
          topimage: widget.uiData["template20"]["topimage"],
          maincategories:
              List<String>.from(widget.uiData["template20"]["sub_categories"]),
          categoryId: widget.uiData["template20"]["category_ref"],
          bgcolor: widget.uiData["template20"]["background_color"],
          subcatColor: widget.uiData["template20"]["subcat_color"],
          offerBGcolor1: widget.uiData["template20"]["offer_bg_color"],
          mrpColor: widget.uiData["template20"]["mrp_color"],
          productBgColor: widget.uiData["template20"]
              ["product_background_color"],
          sellingPriceColor: widget.uiData["template20"]["saleprice_color"],
          showcategory: widget.uiData["template20"]["show_Category"],
          buttonbgcolor: widget.uiData["template20"]["buttonbgcolor"],
          buttontextcolor: widget.uiData["template20"]["buttontextcolor"],
          indicatercolor: widget.uiData["template20"]["indicatercolor"],
          offertextcolor1: widget.uiData["template20"]["offertextcolor"],
          unitcolor: widget.uiData["template20"]["unitcolor"],
          unitbgcolor: widget.uiData["template20"]["unitbgcolor"],
          seeallbgcolorl: widget.uiData["template20"]["seeallbgcolor"],
          seealltextcolor: widget.uiData["template20"]["seealltextcolor"],
          offerBGcolor2: widget.uiData["template20"]["offerBGcolor2"],
          offerBordercolor: widget.uiData["template20"]["offerBordercolor"],
          offertextcolor2: widget.uiData["template20"]["offertextcolor2"],
        ),
        'order': widget.uiData["template20"]["ui_order_number"]
      },
      {
        'template': const DescriptiveWidget(
          title: "Skip the store, we're at your door!",
          logo: "assets/images/kwiklogo.png",
          showcategory: true,
        ),
        'order': "88888"
      },
      // Add all other templates here following the same pattern...
      // This is just a sample, include all your templates
    ];

    templates.sort(
      (a, b) => int.parse(a['order']).compareTo(int.parse(b['order'])),
    );

    return templates;
  }

  @override
  Widget build(BuildContext context) {
    final appBarColor = parseColor(widget.uiData["template1"]["appbarcolor"]);
    final hintText = widget.uiData["template1"]["hinttext"];
    final topText1Bg = parseColor(widget.uiData["template1"]["toptext1bg"]);
    final topText2Color = parseColor(widget.uiData["template1"]["toptext2clr"]);
    final iconColor = parseColor(widget.uiData["template1"]["iconcolor"]);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [.08, .1, .2, .5, .7, 1.0],
          colors: [
            appBarColor,
            appBarColor,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: InkWell(
            onTap: () {
              context
                  .read<NavbarBloc>()
                  .add(const UpdateNavBarVisibility(true));
            },
            child: RefreshIndicator(
              onRefresh: widget.onRefresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    floating: true,
                    automaticallyImplyLeading: false,
                    pinned: false,
                    snap: true,
                    expandedHeight: 93,
                    collapsedHeight: 93,
                    backgroundColor: appBarColor,
                    foregroundColor: appBarColor,
                    flexibleSpace: _AppBarContent(
                      bgcolor: appBarColor,
                      topText1: widget.uiData["template1"]["toptext1"],
                      topText1Bg: topText1Bg,
                      topText2: widget.uiData["template1"]["toptext2"],
                      topText2Color: topText2Color,
                      iconColor: iconColor,
                      toptextclr:
                          parseColor(widget.uiData["template1"]["toptext1clr"]),
                      addresscolor:
                          parseColor(widget.uiData["template1"]["addressclr"]),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0, top: 12),
                        child: InkWell(
                          onTap: () => context.push('/profile'),
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Image(
                                image:
                                    AssetImage("assets/images/User_fill.png")),
                          ),
                        ),
                      )
                    ],
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: SearchBarDelegate(hintText
                        // hintText: hintText,
                        // searchFieldFillColor: searchFieldFillColor,
                        // searchFieldTextColor: searchFieldTextColor,
                        // searchText: searchTerm == "no" ? null : searchTerm,
                        ),
                  ),
                  ..._getVisibleTemplates().map((template) {
                    return SliverToBoxAdapter(
                      child: template['template'],
                    );
                  }),
                  // Loading indicator at the bottom
                  if (_isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.korangeColor),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const Navbar(),
      ),
    );
  }
}

class _AppBarContent extends StatelessWidget {
  final String topText1;
  final Color bgcolor;
  final Color topText1Bg;
  final String topText2;
  final Color topText2Color;
  final Color iconColor;
  final Color toptextclr;
  final Color addresscolor;

  const _AppBarContent({
    required this.topText1,
    required this.topText1Bg,
    required this.topText2,
    required this.topText2Color,
    required this.iconColor,
    required this.bgcolor,
    required this.toptextclr,
    required this.addresscolor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgcolor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const MainLoadingIndicator()),
                );
              },
              child: InkWell(
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const NetworkErrorPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: topText1Bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    topText1,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: toptextclr,
                        ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LocationSearchPage(),
                ));
                // context.push('/locatiopage');
              },
              child: Row(
                children: [
                  Text(topText2,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: topText2Color,
                          )),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const LocationSearchPage()),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_drop_down_circle_rounded,
                      color: iconColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const LocationSearchPage()),
                );
              },
              child: Row(
                spacing: 8,
                children: [
                  SvgPicture.asset("assets/images/addresshome_icon.svg"),
                  BlocBuilder<AddressBloc, AddressState>(
                    builder: (context, state) {
                      if (state is LocationSearchResults) {
                        return Text(
                          "${state.currentlocationaddress.characters.take(35).string}...",
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 12,
                                    color: addresscolor,
                                  ),
                        );
                      }
                      return const Shimmer(width: 200, height: 12);
                    },
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

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final String searchText;

  SearchBarDelegate(this.searchText);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder<HomeUiBloc, HomeUiState>(builder: (context, state) {
      if (state is UiInitial) {
        context.read<HomeUiBloc>().add(FetchUiDataEvent());
        return const Center(child: MainLoadingIndicator());
      } else if (state is UiLoading) {
        return const Center(child: MainLoadingIndicator());
      } else if (state is UiLoaded) {
        final uiData = state.uiData;
        return SafeArea(
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              context.push('/searchpage');
            },
            child: Container(
              height: 80,
              color: parseColor(uiData["template1"]["appbarcolor"]),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color:
                      parseColor(uiData["template1"]["searchfieldfillcolor"]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/search.svg",
                      fit: BoxFit.contain,
                      width: 30,
                      height: 20,
                      color:
                          parseColor(uiData["template1"]["searchfieldtextclr"]),
                    ),
                    const SizedBox(width: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        uiData["template1"]["hinttext"] == "no"
                            ? 'Search "$searchText"'
                            : uiData["template1"]["hinttext"],
                        key: ValueKey(searchText),
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: parseColor(
                                uiData["template1"]["searchfieldtextclr"]),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
