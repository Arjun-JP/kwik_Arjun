import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwik/bloc/Add_Review_bloc/add_review_bloc.dart' show ReviewBloc;
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Auth_bloc/auth_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Categories%20Page%20Bloc/category_model_bloc/category_model_bloc.dart';
import 'package:kwik/bloc/Coupon_bloc/Coupon_bloc.dart';
import 'package:kwik/bloc/Network_bloc/network_bloc.dart';
import 'package:kwik/bloc/Order_management.dart/order_management_bloc.dart';
import 'package:kwik/bloc/Search_bloc/Search_bloc.dart';
import 'package:kwik/bloc/Super%20Saver%20Page%20Bloc/super_saver_ui_bloc/super_saver_ui_bloc.dart';
import 'package:kwik/bloc/all_sub_category_bloc/all_sub_category_bloc.dart';
import 'package:kwik/bloc/banner_bloc/banner_bloc.dart';
import 'package:kwik/bloc/brand_products/brand_products_bloc.dart';
import 'package:kwik/bloc/category_landing_page_bloc/category_landing_page_bloc.dart';
import 'package:kwik/bloc/force_update_bloc/force_update_bloc.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_bloc/category_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_13_bloc/category_model_13_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_14_bloc/category_model_14_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_16_bloc/category_model_16_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_18_bloc/category_model_18_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_19_bloc/category_model_19_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_2_bloc/category_model2_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_12_bloc/category_model_12_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_6_bloc/category_model_6_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_8_bloc/category_model_8_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_9_bloc/category_model_9_bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_bloc.dart';
import 'package:kwik/bloc/order_bloc/order_bloc.dart';
import 'package:kwik/bloc/product_details_page/product_details_bloc/product_details_page_bloc.dart';
import 'package:kwik/bloc/product_details_page/recommended_products_bloc/recommended_products_bloc.dart';
import 'package:kwik/bloc/product_details_page/similerproduct_bloc/similar_product_bloc.dart';
import 'package:kwik/bloc/subcategory_product_bloc/subcategory_product_bloc.dart';
import 'package:kwik/constants/FCM_token.dart';
import 'package:kwik/constants/network_check.dart';
import 'package:kwik/constants/textstyle.dart';
import 'package:kwik/firebase_options.dart';
import 'package:kwik/models/Hiveadapter/brand_model_adapter.dart';
import 'package:kwik/models/Hiveadapter/category_model_adapter.dart';
import 'package:kwik/models/Hiveadapter/review_model_adapter.dart';
import 'package:kwik/models/Hiveadapter/stock_model_adapter.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/product_model.dart' show ProductModel;
import 'package:kwik/repositories/add_review.dart';
import 'package:kwik/repositories/address_repo.dart';
import 'package:kwik/repositories/allsubcategory_repo.dart';
import 'package:kwik/repositories/auth_repo.dart';
import 'package:kwik/repositories/banner_repository.dart';
import 'package:kwik/repositories/brand_products_repo.dart';
import 'package:kwik/repositories/cart_repo.dart';
import 'package:kwik/repositories/categories_page_ui_repository.dart';
import 'package:kwik/repositories/category_landing_page_repo.dart';
import 'package:kwik/repositories/category_model1_repository.dart';
import 'package:kwik/repositories/category_model_12_repo.dart';
import 'package:kwik/repositories/category_model_13_repo.dart';
import 'package:kwik/repositories/category_model_18.dart';
import 'package:kwik/repositories/category_model_3_repo_home.dart';
import 'package:kwik/repositories/category_model_6_repo.dart';
import 'package:kwik/repositories/category_model_8_repo.dart';
import 'package:kwik/repositories/category_subcategory_product_repo.dart';
import 'package:kwik/repositories/coupon_repo.dart';
import 'package:kwik/repositories/get_app_data_repo.dart';
import 'package:kwik/repositories/googlemap_service.dart';
import 'package:kwik/repositories/home_Ui_repository.dart';
import 'package:kwik/repositories/home_category_repository.dart';
import 'package:kwik/repositories/manage_order_repo.dart';
import 'package:kwik/repositories/order_deiails_repo.dart';
import 'package:kwik/repositories/order_history_repo.dart';
import 'package:kwik/repositories/recommended_product_repo.dart';
import 'package:kwik/repositories/search_repo.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';
import 'package:kwik/repositories/subcategory_product_repo.dart';
import 'package:kwik/repositories/super_saver_ui_repo.dart';
import 'package:kwik/routes/routes.dart';
import 'package:kwik/pages/Error_pages/Error_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'bloc/Categories Page Bloc/categories_UI_bloc/categories_ui_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model1/categories_page_model1_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model2/categories_page_model2_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model3/categories_page_model3_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model4/categories_page_model4_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model5/categories_page_model5_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model6/categories_page_model6_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model7/categories_page_model7_bloc.dart';
import 'bloc/home_page_bloc/category_model_10_bloc/category_model_10_bloc.dart';
import 'bloc/home_page_bloc/category_model_15_bloc/category_model_15_bloc.dart';
import 'bloc/home_page_bloc/category_model_4_bloc/category_model_4_bloc.dart';
import 'bloc/home_page_bloc/category_model_7_bloc/category_model_7_bloc.dart';
import 'bloc/home_page_bloc/category_model_8_bloc/category_model_8_event.dart';
import 'models/Hiveadapter/banner_model_adapter.dart';
import 'models/Hiveadapter/product_model_adapter.dart';
import 'models/Hiveadapter/subcategory_model_adapter.dart';
import 'models/Hiveadapter/variation_model_adapter.dart';
import 'models/Hiveadapter/warehouse_model_adapter.dart';
import 'repositories/category_model2_repository.dart';
import 'repositories/category_model9_repo.dart';
import 'repositories/category_model_10_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  debugProfilePlatformChannelsEnabled:
  true;
  // debugPaintSizeEnabled = true;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception.toString().contains('memory') ||
        details.exception.toString().contains('dispose')) {
      print("*** POTENTIAL MEMORY LEAK : ${details.exception}");
      print("*** context : ${details.context}");
      print("*** stack trace : ${details.stack}");
    }
    FlutterError.presentError(details);
  };
// if(kDebugMode){
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     debugPrint("current memory use : ${ProcessInfo.currentRss / 1024 / 1024 }").toStringAsFixed(2)
//   },)
// }
  await Hive.initFlutter();
  Hive.registerAdapter(SubCategoryModelAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(WarehouseLocationAdapter());
  Hive.registerAdapter(ReviewModelAdapter());
  Hive.registerAdapter(StockModelAdapter());
  Hive.registerAdapter(VariationModelAdapter());
  Hive.registerAdapter(BannerModelAdapter());
  Hive.registerAdapter(WarehouseModelAdapter());
  Hive.registerAdapter(BrandAdapter());
  Hive.registerAdapter(CartProductAdapter());

  //hive delete box
  await Hive.deleteBoxFromDisk('product_cache');
  await Hive.deleteBoxFromDisk('product_cache_category_model7');
  await Hive.deleteBoxFromDisk('subCategoriesBox'); // Open boxes before usage
  await Hive.deleteBoxFromDisk('productsBox');
  await Hive.deleteBoxFromDisk('productsBoxcatmodel9');
  await Hive.deleteBoxFromDisk('productsBoxcatmodel12');
  await Hive.deleteBoxFromDisk('product_cache_category_model10');
  await Hive.deleteBoxFromDisk('categoryPagemodel1Cache');
  await Hive.deleteBoxFromDisk('subCategoryPagemodel1Cache');
  await Hive.deleteBoxFromDisk('categoryPagemodel2Cache');
  await Hive.deleteBoxFromDisk('subCategoryPagemodel2Cache');
  await Hive.deleteBoxFromDisk('categoryPagemodel3Cache');
  await Hive.deleteBoxFromDisk('subCategoryPagemodel3Cache');
  await Hive.deleteBoxFromDisk('subCategoriesBoxCatPage');
  await Hive.deleteBoxFromDisk('productsBoxCatPage');
  await Hive.deleteBoxFromDisk('categorymodel8Cache');
  await Hive.deleteBoxFromDisk('subCategorymodel8Cache');
  await Hive.deleteBoxFromDisk('categoryPagemodel10Cache');
  await Hive.deleteBoxFromDisk('subCategoriesBoxCM14');
  await Hive.deleteBoxFromDisk('productsBoxCM14');
  await Hive.deleteBoxFromDisk('subCategoryPagemodel10Cache');
  await Hive.deleteBoxFromDisk('product_cache_category_ss2');
  await Hive.deleteBoxFromDisk('product_cache_SS5');
  await Hive.deleteBoxFromDisk('productsBoxcatmodel15');
  await Hive.deleteBoxFromDisk('categorymodel16Cache');
  await Hive.deleteBoxFromDisk('subCategorymodel16Cache');
  // await Hive.deleteBoxFromDisk('subcategories_CatM5');
  await Hive.deleteBoxFromDisk('All_category_box');
  await Hive.deleteBoxFromDisk('all_subcategory_box');
  await Hive.deleteBoxFromDisk('subCategoriesBoxcategorylanding');
  await Hive.deleteBoxFromDisk('productsBoxcategorylanding');
  await Hive.deleteBoxFromDisk('subCategoriesBoxCM19');
  await Hive.deleteBoxFromDisk('productsBoxCM19');
  await Hive.deleteBoxFromDisk('similar_product_cache');
  await Hive.deleteBoxFromDisk('cart');
  await Hive.deleteBoxFromDisk('Supersaver_ui_cache_box');
  await Hive.deleteBoxFromDisk('subCategoriesallcategorypage');
  await Hive.deleteBoxFromDisk('productsallsubcategorypage');
  await Hive.deleteBoxFromDisk('search_productCache');
  await Hive.deleteBoxFromDisk('search_history');
  await Hive.deleteBoxFromDisk('Recommended_product_cache');

// hive open box
  await Hive.openBox('Supersaver_ui_cache_box');
  await Hive.openBox('product_cache');
  await Hive.openBox('product_cache_category_model7');
  await Hive.openBox('subCategoriesBox');
  await Hive.openBox('subCategoriesBoxCM18'); // Open boxes before usage
  await Hive.openBox('productsBox');
  await Hive.openBox('productsBoxcatmodel9');
  await Hive.openBox('productsBoxcatmodel12');
  await Hive.openBox('product_cache_category_model10');
  await Hive.openBox('categoryPagemodel1Cache');
  await Hive.openBox('subCategoryPagemodel1Cache');
  await Hive.openBox('categoryPagemodel2Cache');
  await Hive.openBox('subCategoryPagemodel2Cache');
  await Hive.openBox('categoryPagemodel3Cache');
  await Hive.openBox('subCategoryPagemodel3Cache');
  await Hive.openBox('subCategoriesBoxCatPage');
  await Hive.openBox('productsBoxCatPage');
  await Hive.openBox('categorymodel8Cache');
  await Hive.openBox('subCategorymodel8Cache');
  await Hive.openBox('categoryPagemodel10Cache');
  await Hive.openBox('subCategoriesBoxCM14');
  await Hive.openBox('productsBoxCM14');
  await Hive.openBox('subCategoryPagemodel10Cache');
  await Hive.openBox('product_cache_category_ss2');
  await Hive.openBox('product_cache_SS5');
  await Hive.openBox('productsBoxcatmodel15');
  await Hive.openBox('categorymodel16Cache');
  await Hive.openBox('subCategorymodel16Cache');
  await Hive.openBox('subCategoriesBoxCM19');
  await Hive.openBox('productsBoxCM19');
  // await Hive.openBox('subcategories_CatM5');
  await Hive.openBox('All_category_box');
  await Hive.openBox('all_subcategory_box');
  await Hive.openBox('subCategoriesBoxcategorylanding');
  await Hive.openBox('productsBoxcategorylanding');
  await Hive.openBox('similar_product_cache');
  await Hive.openBox('cart');
  await Hive.openBox('search_productCache');
  await Hive.openBox('search_history');
  await Hive.openBox('Recommended_product_cache');

  // await Hive.openBox<List<SubCategoryModel>>('subcategoriesallcategorypage');
  await Hive.openBox<List<ProductModel>>('productsallcategorypage');
  // await Hive.openBox('subcategoriesallcategorypage');
  // await Hive.openBox('productsallcategorypage');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // debugPrintScheduleFrameStacks:
  // true;
  WidgetsFlutterBinding.ensureInitialized();
  final fcmService = FCMService();
  await fcmService.initialize();
  fcmService.setupTokenRefresh();
  // Handle initial authentication state

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoRouter _router = router;

  @override
  void initState() {
    super.initState();
    // Wait for context to be ready
    requestNotificationPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthRepo()),
        ),
        BlocProvider<HomeUiBloc>(
            create: (_) => HomeUiBloc(uiRepository: HomeUiRepository())),

        BlocProvider<CategoryBloc>(
            create: (_) =>
                CategoryBloc(categoryRepository: CategoryRepository())),

        BlocProvider<BannerBloc>(
            create: (_) => BannerBloc(bannerepository: BannerRepository())),

        BlocProvider<CategoryBlocModel1>(
            create: (_) => CategoryBlocModel1(
                categoryRepositoryModel1: CategoryRepositoryModel3Home())),
        BlocProvider<CategoryBlocModel2>(
            create: (_) => CategoryBlocModel2(
                categoryRepositoryModel2: CategoryRepositoryModel2())),
        BlocProvider<NavbarBloc>(create: (_) => NavbarBloc()),
        BlocProvider<CategoryModel4Bloc>(
            create: (_) =>
                CategoryModel4Bloc(repository: SubcategoryProductRepository())),
        BlocProvider<CategoryBloc5>(
            create: (_) =>
                CategoryBloc5(categoryRepository: Categorymodel5Repository())),
        BlocProvider<CategoryBlocModel6>(
            create: (_) =>
                CategoryBlocModel6(categoryModel6Repo: CategoryModel6Repo())),
        BlocProvider<CategoryModel7Bloc>(
            create: (_) =>
                CategoryModel7Bloc(repository: SubcategoryProductRepository())),
        BlocProvider<CategoryModel8Bloc>(
            create: (_) => CategoryModel8Bloc(
                categoryRepository: Categorymodel8Repository())
              ..add(FetchCategoriesmodel8())),
        BlocProvider<CategoryBloc9>(
            create: (_) =>
                CategoryBloc9(categoryRepository: Categorymodel9Repository())),
        BlocProvider<CategoryModel10Bloc>(
            create: (_) =>
                CategoryModel10Bloc(repository: CategoryModel10Repo())),
        BlocProvider<CategoriesUiBloc>(
            create: (_) => CategoriesUiBloc(
                catUiRepository: CategoriesPageUiRepository())),
        BlocProvider<CategoryBloc12>(
          create: (_) =>
              CategoryBloc12(categoryRepository: Categorymodel12Repository()),
        ),
        BlocProvider<CategoryBloc13>(
            create: (_) => CategoryBloc13(
                categoryRepository: Categorymodel13Repository())),

        BlocProvider<CategoryBloc14>(
            create: (_) =>
                CategoryBloc14(categoryRepository: Categorymodel5Repository())),
        BlocProvider<CategoryBloc15>(
            create: (_) => CategoryBloc15(
                categoryRepository: Categorymodel12Repository())),
        BlocProvider<CategoryBlocModel16>(
            create: (_) => CategoryBlocModel16(
                categoryRepositoryModel2: CategoryRepositoryModel2())),
        BlocProvider<CategoryBloc18>(
            create: (_) => CategoryBloc18(
                categoryRepository: Categorymodel18Repository())),
        BlocProvider<CategoryBloc19>(
            create: (_) =>
                CategoryBloc19(categoryRepository: Categorymodel5Repository())),
        BlocProvider<VariationBloc>(create: (_) => VariationBloc()),

//for categories page

        BlocProvider<CategoriesPageModel1Bloc>(
            create: (_) => CategoriesPageModel1Bloc(
                categoryRepositoryModel2: CategoryRepositoryModel2())),
        BlocProvider<CategoriesPageModel2Bloc>(
            create: (_) => CategoriesPageModel2Bloc(
                categoryRepositoryModel2: CategoryRepositoryModel2())),
        BlocProvider<CategoriesPageModel3Bloc>(
            create: (_) => CategoriesPageModel3Bloc(
                categoryRepositoryModel2: CategoryRepositoryModel2())),
        BlocProvider<CategoriesPageModel4Bloc>(
            create: (_) => CategoriesPageModel4Bloc(
                repository: SubcategoryProductRepository())),

        BlocProvider<CategoriesPageModel5Bloc>(
            create: (_) => CategoriesPageModel5Bloc(
                categoryRepository: Categorymodel5Repository())),

        BlocProvider<CategoriesPageModel6Bloc>(
            create: (_) => CategoriesPageModel6Bloc(
                categoryRepository: Categorymodel8Repository())
              ..add(FetchCategoriesmodel6())),

        BlocProvider<CategoriesPageModel7Bloc>(
          create: (_) =>
              CategoriesPageModel7Bloc(repository: CategoryModel10Repo()),
        ),

        BlocProvider<CategoryBlocModel>(
          create: (_) => CategoryBlocModel(
              categoryRepositoryModel1: CategoryRepositoryModel1()),
        ),

        // categorylanding page bloc
        BlocProvider<CategoryLandingpageBloc>(
          create: (_) => CategoryLandingpageBloc(
              categoryRepository: CategoryLandingPageRepo()),
        ),

        // productdetailspagebloc

        BlocProvider<SubcategoryProductBloc>(
          create: (_) => SubcategoryProductBloc(SubcategoryProductRepository()),
        ),
        BlocProvider<RecommendedProductsBloc>(
          create: (_) => RecommendedProductsBloc(RecommendedProductRepo()),
        ),
        // Cart bloc
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(cartRepository: CartRepository()),
        ),

        //Supersaver page bloc
        BlocProvider<SuperSaverUiBloc>(
            create: (_) =>
                SuperSaverUiBloc(uiRepository: SuperSaverRepository())),
        // all sub category bloc
        BlocProvider<AllSubCategoryBloc>(
            create: (_) =>
                AllSubCategoryBloc(repository: AllsubcategoryRepo())),
        //search bloc
        BlocProvider<SearchBloc>(
            create: (_) => SearchBloc(repository: SearchRepo())),

        //brand page bloc
        BlocProvider<BrandProductBloc>(
            create: (_) => BrandProductBloc(BrandProductRepository())),

        BlocProvider<OrderBloc>(
            create: (_) => OrderBloc(orderRepository: OrderRepository())),
        BlocProvider<OrderDetailsBloc>(
            create: (_) => OrderDetailsBloc(OrderDeiailsRepo())),
        //appdata bloc

        BlocProvider<GetAppdataBloc>(
            create: (_) => GetAppdataBloc(GetAppDataRepo())),

//subcategory product page
        BlocProvider<SubcategoryProductBlocSubcategory>(
            create: (_) =>
                SubcategoryProductBlocSubcategory(SubcategProductRepository())),
        BlocProvider<AddressBloc>(
            create: (_) =>
                AddressBloc(GoogleMapsService(), AddressRepository())),

        //order managemnent bloc
        BlocProvider<OrderManagementBloc>(
            create: (_) => OrderManagementBloc(
                orderRepository: OrderManagementRepository())),

        BlocProvider<ReviewBloc>(
            create: (_) => ReviewBloc(reviewRepository: ReviewRepository())),
        BlocProvider<NetworkBloc>(
          create: (context) => NetworkBloc(),
        ),

        //forceupdate
        BlocProvider<UpdateBloc>(create: (_) => UpdateBloc(GetAppDataRepo())),
//coupon bloc
        BlocProvider<CouponBloc>(
            create: (_) => CouponBloc(repository: CouponRepository())),
      ],
      child: MaterialApp.router(
        builder: (context, child) {
          ErrorWidget.builder = (FlutterErrorDetails) {
            return KwikErrorWidget(errordetails: FlutterErrorDetails);
          };
          return child!;
        },
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        routerConfig: _router,
        title: 'Kwik',

        theme: appTheme(context),
        debugShowCheckedModeBanner: false,
        //  home:
      ),
    );
  }
}

void requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Process your data here
}
