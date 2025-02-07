import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kwik/bloc/banner_bloc/banner_bloc.dart';
import 'package:kwik/bloc/category_bloc/category_bloc.dart';
import 'package:kwik/bloc/category_model1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/constants/textstyle.dart';
import 'package:kwik/firebase_options.dart';
import 'package:kwik/repositories/banner_repository.dart';
import 'package:kwik/repositories/category_model1_repository.dart';
import 'package:kwik/repositories/home_Ui_repository.dart';
import 'package:kwik/repositories/home_category_repository.dart';
import 'package:kwik/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
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
        BlocProvider<CategoryBlocModel1>(
            create: (_) => CategoryBlocModel1(
                categoryRepositoryModel1: CategoryRepositoryModel1())),
        BlocProvider<NavbarBloc>(create: (_) => NavbarBloc())
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
