import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Auth_bloc/auth_bloc.dart';
import 'package:kwik/bloc/Auth_bloc/auth_event.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_event.dart';
import 'package:kwik/constants/colors.dart';

class LogoutBottomSheet extends StatefulWidget {
  const LogoutBottomSheet({super.key});

  @override
  State<LogoutBottomSheet> createState() => _LogoutBottomSheetState();
}

TextEditingController lessoncontroller = TextEditingController();

class _LogoutBottomSheetState extends State<LogoutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // height: MediaQuery.of(context).size.height * .26,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 166, 28, 28), // Choose your color
              width: 2.0, // Thickness of the border
            ),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18))),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(height: 80, width: 80, "assets/images/kwiklogo.png"),
            Text("Taking a break?  We'll keep the cart warm for you!",
                // Your doorstep shopping buddy will be right here—just a tap away. Come back soon!
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.textColorblack,
                    fontSize: 24,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 50),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: AppColors.buttonColorOrange, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: AppColors.textColorWhite,
                        backgroundColor: AppColors.textColorWhite,
                      ),
                      child: Text(
                        "Close",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: AppColors.buttonColorOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();

                        context.read<AuthBloc>().add(LogoutEvent());
                        context
                            .read<NavbarBloc>()
                            .add(const UpdateNavBarIndex(0));
                        context.go('/loginPage');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: const Color.fromARGB(255, 166, 28, 28),
                        backgroundColor: const Color.fromARGB(255, 166, 28, 28),
                      ),
                      child: Text(
                        "Continue",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: AppColors.kwhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
