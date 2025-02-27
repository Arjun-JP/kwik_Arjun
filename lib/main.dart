import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwik/bloc/Auth_bloc/auth_bloc.dart';
import 'package:kwik/bloc/banner_bloc/banner_bloc.dart';
import 'package:kwik/bloc/category_bloc/category_bloc.dart';
import 'package:kwik/bloc/category_model1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/category_model2_bloc/category_model2_bloc.dart';
import 'package:kwik/bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/category_model_6_bloc/category_model_6_bloc.dart';
import 'package:kwik/bloc/category_model_8_bloc/category_model_8_bloc.dart';
import 'package:kwik/bloc/category_model_9_bloc/category_model_9_bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/constants/textstyle.dart';
import 'package:kwik/firebase_options.dart';
import 'package:kwik/models/Hiveadapter/brand_model_adapter.dart';
import 'package:kwik/models/Hiveadapter/category_model_adapter.dart';
import 'package:kwik/models/Hiveadapter/review_model_adapter.dart';
import 'package:kwik/models/Hiveadapter/stock_model_adapter.dart';
import 'package:kwik/repositories/banner_repository.dart';
import 'package:kwik/repositories/category_model1_repository.dart';
import 'package:kwik/repositories/category_model_6_repo.dart';
import 'package:kwik/repositories/category_model_8_repo.dart';
import 'package:kwik/repositories/category_subcategory_product_repo.dart';
import 'package:kwik/repositories/home_Ui_repository.dart';
import 'package:kwik/repositories/home_category_repository.dart';
import 'package:kwik/repositories/sub_category_product_repository.dart';
import 'package:kwik/routes/routes.dart';
import 'bloc/category_model_10_bloc/category_model_10_bloc.dart';
import 'bloc/category_model_4_bloc/category_model_4_bloc.dart';
import 'bloc/category_model_7_bloc/category_model_7_bloc.dart';
import 'bloc/category_model_8_bloc/category_model_8_event.dart';
import 'models/Hiveadapter/banner_model_adapter.dart';
import 'models/Hiveadapter/product_model_adapter.dart';
import 'models/Hiveadapter/subcategory_model_adapter.dart';
import 'models/Hiveadapter/variation_model_adapter.dart';
import 'models/Hiveadapter/warehouse_model_adapter.dart';
// import 'models/subcategory_model.dart' as subcategory;
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

  await Hive.openBox('subCategoryPagemodel10Cache');

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
