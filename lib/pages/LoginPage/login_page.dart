import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/constants/colors.dart';

import '../../bloc/category_model1_bloc/category_model1_bloc.dart';
import '../../bloc/category_model1_bloc/category_model1_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 8,
              child: Image.asset(
                'assets/images/image2.png',
                fit: BoxFit.fill,
                width: double.infinity,
              )),
          SizedBox(height: deviceheight * 0.03),
          Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: deviceheight * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Login with phone',
                        style: theme.textTheme.displaySmall!.copyWith(
                            color: AppColors.textColorblack,
                            fontWeight: FontWeight.w700,
                            fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: deviceheight * 0.01),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'You’ll receive 6 digit code to verify next.',
                        style: theme.textTheme.bodyLarge!.copyWith(
                            color: AppColors.textColorGrey,
                            fontWeight: FontWeight.w400,
                            height: devicewidth * 0.0035,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height: deviceheight * 0.03),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Mobile Number',
                        style: theme.textTheme.bodyLarge!.copyWith(
                            color: AppColors.textColorGrey,
                            fontWeight: FontWeight.w400,
                            height: devicewidth * 0.0035,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          context.read<HomeUiBloc>().add(ClearUiCacheEvent());
                          BlocProvider.of<CategoryBlocModel1>(context)
                              .add(ClearCache());
                          context.go("/home");
                        },
                        child: const Text("Home"))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
