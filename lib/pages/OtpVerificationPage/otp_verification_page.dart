import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Auth_bloc/auth_bloc.dart';
import 'package:kwik/bloc/Auth_bloc/auth_event.dart';
import 'package:kwik/bloc/Auth_bloc/auth_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/network_check.dart';
import 'package:kwik/widgets/shimmer/main_loading_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const OtpVerificationPage(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NetworkUtils.checkConnection(context);
    });
    _startCountdown();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _countdown = 60; // Initial countdown in seconds
  bool _isResending = false; // Flag to prevent multiple resend requests
  String? _successMessage; // Message for successful OTP send
  String? _errorMessage; // Message for errors during OTP send
  Timer? _timer;
  void _startCountdown() {
    _countdown = 60; // Reset countdown
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel(); // Stop the timer
        setState(() {}); // Rebuild to enable the resend button
      } else {
        setState(() {
          _countdown--; // Decrement countdown
        });
      }
    });
  }

  Future<void> resendOtp() async {
    if (_isResending || _countdown > 0) {
      // Prevent resending if already in progress or countdown is active
      return;
    }

    setState(() {
      _isResending = true; // Set resending flag to true
      _successMessage = null; // Clear previous messages
      _errorMessage = null;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91${widget.phoneNumber}",
        timeout: const Duration(seconds: 60), // OTP timeout
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval of OTP on Android, or instant verification
          // This typically happens if the user has enabled auto-fill for OTPs
          // or if the phone number is already verified.
          print('Verification completed: ${credential.smsCode}');
          setState(() {
            _successMessage = 'Phone number automatically verified!';
            _isResending = false;
            _countdown = 0; // End countdown as verification is complete
            _timer?.cancel();
          });
          // You might sign in the user here
          // await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle errors during verification
          print('Verification failed: ${e.message}');
          setState(() {
            _errorMessage = 'OTP verification failed: ${e.message}';
            _isResending = false;
            // Do not reset countdown here, let user retry after current countdown ends
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          // OTP code sent successfully
          print(
              'Code sent to ${widget.phoneNumber}. Verification ID: $verificationId');
          setState(() {
            _successMessage = 'New OTP sent successfully!';
            _isResending = false;
            _startCountdown(); // Restart countdown for the new OTP
          });
          // Store verificationId and resendToken if needed for manual OTP entry
          // You'll need verificationId to complete sign-in later
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timed out (e.g., on Android)
          print('Auto-retrieval timed out. Verification ID: $verificationId');
          setState(() {
            _errorMessage =
                'OTP auto-retrieval timed out. Please enter manually.';
            _isResending = false;
            // The countdown will naturally end here if it hasn't already
          });
        },
      );
    } catch (e) {
      print('Error initiating phone verification: $e');
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
        _isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthenticatedState) {
        context.go("/home");
      } else if (state is AuthFailureState) {
        _focusNode.unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error)),
        );
      }
    }, builder: (context, state) {
      if (state is PhoneAuthCodeSentSuccess || state is AuthFailureState) {
        return Scaffold(
          body: InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/image2.jpeg',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: deviceheight * 0.55,
                  ),
                  SizedBox(height: deviceheight * 0.03),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: devicewidth * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "OTP Verification",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: deviceheight * 0.03),
                          child: Text(
                            'OTP has been sent on mobile number\nPlease enter OTP to verify the number',
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: AppColors.textColorGrey,
                                fontWeight: FontWeight.w400,
                                height: devicewidth * 0.0035,
                                fontSize: 16),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: deviceheight * 0.03),
                          child: PinCodeTextField(
                            cursorColor: AppColors.kgreyColorlite,
                            autoDisposeControllers: false,
                            appContext: context,
                            length: 6,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            enableActiveFill: false,
                            autoFocus: true,
                            enablePinAutofill: false,
                            errorTextSpace: 16,
                            showCursor: true,
                            obscureText: false,
                            hintCharacter: '●',
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                                fieldHeight: 50,
                                fieldWidth: 45,
                                borderWidth: 0.5,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                shape: PinCodeFieldShape.box,
                                activeColor: AppColors.buttonColorOrange,
                                inactiveColor: AppColors.kgreyColorlite,
                                selectedColor: AppColors.buttonColorOrange),
                            controller: _otpController,
                            onChanged: (_) {},
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _countdown > 0
                                ? Text(
                                    "($_countdown)",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                        color: AppColors.dotColorSelected),
                                  )
                                : const SizedBox(),
                            TextButton(
                                onPressed: () {
                                  _startCountdown();
                                  resendOtp();
                                },
                                child: Text(
                                  "Resend OTP",
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                      color: _countdown > 0
                                          ? Colors.grey
                                          : AppColors.textColorblack),
                                )),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (state is AuthLoading) {
                            } else {
                              String otpCode = _otpController.text.trim();
                              if (otpCode.isEmpty || otpCode.length < 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please enter a valid OTP code'),
                                  ),
                                );
                              } else if (state is IncorrectOTP) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Incorrect OTP")));
                              } else {
                                BlocProvider.of<AuthBloc>(context).add(
                                  VerifySentOtp(
                                    otpCode: otpCode,
                                    verificationId: widget.verificationId,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColorOrange,
                              minimumSize: Size(devicewidth, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: state is AuthLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text('Verify & Login',
                                  style: theme.textTheme.titleMedium!.copyWith(
                                      color: AppColors.textColorWhite,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        // } else if (state is AuthFailureState) {
        //   return const KwikErrorWidget(
        //     errordetails: FlutterErrorDetails(exception: Object()),
        //   );
      } else {
        return const MainLoadingIndicator();
      }
    });
  }
}
