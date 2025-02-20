import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Auth_bloc/auth_bloc.dart';
import 'package:kwik/bloc/Auth_bloc/auth_event.dart';
import 'package:kwik/bloc/Auth_bloc/auth_state.dart';
import 'package:kwik/bloc/category_model1_bloc/category_model1_bloc.dart';
import 'package:kwik/bloc/category_model1_bloc/category_model1_event.dart';
import 'package:kwik/bloc/category_model2_bloc/category_model2_bloc.dart';
import 'package:kwik/bloc/category_model2_bloc/category_model2_event.dart';
import 'package:kwik/bloc/category_model_10_bloc/category_model_10_event.dart';
import 'package:kwik/bloc/category_model_4_bloc/category_model_4_bloc.dart';
import 'package:kwik/bloc/category_model_4_bloc/category_model_4_event.dart';
import 'package:kwik/bloc/category_model_5__Bloc/category_model5__bloc.dart';
import 'package:kwik/bloc/category_model_5__Bloc/category_model5__event.dart';
import 'package:kwik/bloc/category_model_6_bloc/category_model_6_bloc.dart';
import 'package:kwik/bloc/category_model_6_bloc/category_model_6_event.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/widgets/kiwi_button.dart';

import '../../bloc/category_model_10_bloc/category_model_10_bloc.dart';
import '../../bloc/category_model_7_bloc/category_model_7_bloc.dart';
import '../../bloc/category_model_7_bloc/category_model_7_event.dart';
import '../../bloc/category_model_9_bloc/category_model_9_bloc.dart';
import '../../bloc/category_model_9_bloc/category_model_9_event.dart';

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
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.03),
                        Text('Mobile Number',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.textColorGrey,
                              fontSize: 18,
                            )),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: mobileNumberController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Enter phone number",
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.kgreyColorlite)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.korangeColor)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.kgreyColorlite),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: const Icon(Icons.phone),
                          ),
                          validator: (value) {
                            String pattern = r'^\+?[0-9]{10,15}$';
                            RegExp regex = RegExp(pattern);
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            } else if (!regex.hasMatch(value)) {
                              return 'Enter a valid mobile number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: deviceHeight * 0.03),
                        KiwiButton(
                          text: 'Continue',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final phoneNumber =
                                  mobileNumberController.text.trim();
                              BlocProvider.of<AuthBloc>(context).add(
                                SendOtpToPhoneEvent(
                                    phoneNumber: '+91$phoneNumber'),
                              );
                            }
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              context
                                  .read<HomeUiBloc>()
                                  .add(ClearUiCacheEvent());
                              BlocProvider.of<CategoryBlocModel1>(context)
                                  .add(ClearCache());
                              BlocProvider.of<CategoryBlocModel2>(context)
                                  .add(ClearCacheCM2());
                              BlocProvider.of<CategoryModel4Bloc>(context)
                                  .add(Clearsubcatproduct1Cache());
                              BlocProvider.of<CategoryBloc5>(context)
                                  .add(ClearCacheEventCM5());
                              BlocProvider.of<CategoryBlocModel6>(context)
                                  .add(ClearCacheCM6());
                              BlocProvider.of<CategoryModel7Bloc>(context)
                                  .add(Clearsubcatproduct7Cache());
                              BlocProvider.of<CategoryBloc9>(context)
                                  .add(ClearCacheEventCM9());
                              BlocProvider.of<CategoryModel10Bloc>(context)
                                  .add(Clearsubcatproduct10Cache());
                              context
                                  .read<HomeUiBloc>()
                                  .add(FetchUiDataEvent());
                              context.go("/home");
                            },
                            child: const Text("Home"))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
