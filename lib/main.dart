import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwik/bloc/Auth_bloc/auth_bloc.dart';
import 'package:kwik/bloc/banner_bloc/banner_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_bloc/category_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_13_bloc/category_model_13_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_14_bloc/category_model_14_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_16_bloc/category_model_16_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_2_bloc/category_model2_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_12_bloc/category_model_12_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_6_bloc/category_model_6_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_8_bloc/category_model_8_bloc.dart';
import 'package:kwik/bloc/home_page_bloc/category_model_9_bloc/category_model_9_bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/constants/textstyle.dart';
import 'package:kwik/firebase_options.dart';
import 'package:kwik/models/Hiveadapter/brand_model_adapter.dart';
import 'package:kwik/models/Hiveadapter/category_model_adapter.dart';
import 'package:kwik/models/Hiveadapter/review_model_adapter.dart';
import 'package:kwik/models/Hiveadapter/stock_model_adapter.dart';
import 'package:kwik/repositories/banner_repository.dart';
import 'package:kwik/repositories/categories_page_ui_repository.dart';
import 'package:kwik/repositories/category_model1_repository.dart';
import 'package:kwik/repositories/category_model_12_repo.dart';
import 'package:kwik/repositories/category_model_13_repo.dart';
import 'package:kwik/repositories/category_model_6_repo.dart';
import 'package:kwik/repositories/category_model_8_repo.dart';
import 'package:kwik/repositories/category_subcategory_product_repo.dart';
import 'package:kwik/repositories/home_Ui_repository.dart';
import 'package:kwik/repositories/home_category_repository.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';
import 'package:kwik/routes/routes.dart';
import 'bloc/Categories Page Bloc/categories_UI_bloc/categories_ui_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model1/categories_page_model1_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model2/categories_page_model2_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model3/categories_page_model3_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model4/categories_page_model4_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model5/categories_page_model5_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model6/categories_page_model6_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model7/categories_page_model7_bloc.dart';
import 'bloc/Categories Page Bloc/categories_page_model8/categories_page_model8_bloc.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
// Print the path to the console
  await Hive.openBox('product_cache');
  await Hive.openBox('product_cache_category_model7');
  await Hive.openBox('subCategoriesBox'); // Open boxes before usage
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
  // await Hive.openBox('subcategories_CatM5');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
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
                categoryRepositoryModel1: CategoryRepositoryModel1())),
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
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Kwik',
        theme: appTheme(context),
        debugShowCheckedModeBanner: false,
        //  home:
      ),
    );
  }
}
