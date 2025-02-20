import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Auth_bloc/auth_bloc.dart';
import 'package:kwik/bloc/Auth_bloc/auth_state.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/constants/colors.dart';

import '../../bloc/category_model1_bloc/category_model1_event.dart';
import '../../bloc/category_model2_bloc/category_model2_event.dart';
import '../../bloc/category_model_4_bloc/category_model_4_event.dart';
import '../../bloc/category_model_5__Bloc/category_model5__event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mobileNumberController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PhoneAuthCodeSentSuccess) {
          context.go('/OtpVerificationPage/${state.verificationId}');
        } else if (state is AuthFailureState) {
          context.pop();
        } else if (state is AuthenticatedState) {
          context.go("/home");
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/image2.jpeg',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: deviceHeight * 0.55,
                ),
                SizedBox(height: deviceHeight * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login with phone',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: AppColors.textColorblack,
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.01),
                        Text(
                          'You’ll receive a 6-digit code for verification.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textColorGrey,
                            fontWeight: FontWeight.w400,
                            height: deviceWidth * 0.0035,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        SizedBox(height: deviceHeight * 0.03),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'Mobile Number',
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: AppColors.textColorGrey,
                                fontWeight: FontWeight.w400,
                                height: deviceWidth * 0.0035,
                                fontSize: 18),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<HomeUiBloc>().add(FetchUiDataEvent());
                            context.go("/home");
                          },
                          child: const Text("Home"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
