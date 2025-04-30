import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Auth_bloc/auth_bloc.dart';
import 'package:kwik/bloc/Auth_bloc/auth_event.dart';
import 'package:kwik/bloc/Auth_bloc/auth_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/pages/OtpVerificationPage/otp_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mobileNumberController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    mobileNumberController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print("cuttent state from UI");
          print(state);
          if (state is PhoneAuthCodeSentSuccess) {
            setState(() => _isLoading = false);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationPage(
                  verificationId: state.verificationId,
                  // phoneNumber: mobileNumberController.text.trim(),
                ),
              ),
            );
          } else if (state is AuthFailureState) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is AuthLoading) {
            setState(() => _isLoading = true);
          }
        },
        child: SingleChildScrollView(
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        'You\'ll receive a 6-digit code for verification.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textColorGrey,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      Text(
                        'Mobile Number',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textColorGrey,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: mobileNumberController,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Enter phone number",
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.kgreyColorlite),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.buttonColorOrange,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.kgreyColorlite,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: const Icon(Icons.phone),
                        ),
                        validator: (value) {
                          String pattern = r'^[0-9]{10}$';
                          RegExp regex = RegExp(pattern);
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          } else if (!regex.hasMatch(value)) {
                            return 'Enter a valid 10-digit mobile number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    final phoneNumber =
                                        '+91${mobileNumberController.text.trim()}';
                                    context.read<AuthBloc>().add(
                                          SendOtpToPhoneEvent(
                                              phoneNumber: phoneNumber),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColorOrange,
                            minimumSize: Size(deviceWidth * 0.9, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Continue",
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    color: AppColors.textColorWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ),
                      ),
                      // Temporary button for development - remove in production
                      if (kDebugMode) ...[
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () => context.go("/home"),
                            child: const Text("Skip to Home (Dev Only)"),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
