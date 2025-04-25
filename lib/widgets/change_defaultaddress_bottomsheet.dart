import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/address_model.dart';

class ChangeDefaultaddressBottomsheet extends StatefulWidget {
  final AddressModel selectedaddress;
  const ChangeDefaultaddressBottomsheet(
      {super.key, required this.selectedaddress});

  @override
  State<ChangeDefaultaddressBottomsheet> createState() =>
      _ChangeDefaultaddressBottomsheetState();
}

TextEditingController lessoncontroller = TextEditingController();

class _ChangeDefaultaddressBottomsheetState
    extends State<ChangeDefaultaddressBottomsheet> {
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
              color: AppColors.buttonColorOrange, // Choose your color
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
            const SizedBox(height: 15),
            Text(
                "Are you sure you want to set this as your new default delivery address?This will be used for all your future orders.",
                // Your doorstep shopping buddy will be right here—just a tap away. Come back soon!
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.textColorblack,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 15),
            SizedBox(
              height: 35,
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
                              color: AppColors.buttonColorOrange, width: .3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: AppColors.textColorWhite,
                        backgroundColor: AppColors.textColorWhite,
                      ),
                      child: Text(
                        "Close",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: AppColors.buttonColorOrange,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        context.read<AddressBloc>().add(
                            UpdateselectedaddressEvent(widget.selectedaddress));
                        print(widget.selectedaddress.addressType);
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: AppColors.buttonColorOrange,
                        backgroundColor: AppColors.buttonColorOrange,
                      ),
                      child: Text(
                        "Continue",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: AppColors.kwhiteColor,
                          fontSize: 14,
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
