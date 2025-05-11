import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/models/address_model.dart';

class ChangeDefaultaddressBottomsheet extends StatefulWidget {
  final AddressModel selectedaddress;
  final bool iscart;
  const ChangeDefaultaddressBottomsheet(
      {super.key, required this.selectedaddress, required this.iscart});

  @override
  State<ChangeDefaultaddressBottomsheet> createState() =>
      _ChangeDefaultaddressBottomsheetState();
}

class _ChangeDefaultaddressBottomsheetState
    extends State<ChangeDefaultaddressBottomsheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.buttonColorOrange,
            width: 2.0,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
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
              "Are you sure you want to set this as your new default delivery address? This will be used for all your future orders.",
              textAlign: TextAlign.center,
              style: theme.textTheme.displayMedium?.copyWith(
                color: AppColors.textColorblack,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 35,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
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
                        foregroundColor: AppColors.buttonColorOrange,
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
                    child: BlocListener<AddressBloc, AddressState>(
                      listener: (context, state) {
                        print(state);
                        if (state is LocationSearchResults) {
                          // context.go('/home');
                        } else if (state is NowarehousefoudState) {
                          // context.push('/no-service');
                        } else if (state is AddressError) {
                          context.pop();
                        }
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AddressBloc>().add(
                                UpdateselectedaddressEvent(
                                    widget.selectedaddress),
                              );
                          // if (widget.iscart) {
                          //   context.go('/cartaddresschange');
                          // } else {
                          context.go('/mainloading');
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: AppColors.kwhiteColor,
                          backgroundColor: AppColors.buttonColorOrange,
                        ),
                        child: BlocBuilder<AddressBloc, AddressState>(
                          buildWhen: (previous, current) =>
                              current is AddressLoading,
                          builder: (context, state) {
                            if (state is AddressLoading) {
                              return const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              );
                            } else {
                              return Text(
                                "Continue",
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  color: AppColors.kwhiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            }
                          },
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
