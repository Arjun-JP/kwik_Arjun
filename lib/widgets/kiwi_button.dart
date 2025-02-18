import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';

class KiwiButton extends StatelessWidget {
  const KiwiButton({
    super.key,
    this.onPressed,
    required this.text,
  });
  final void Function()? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final devicewidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColorOrange,
          minimumSize: Size(devicewidth, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      child: Text(text,
          style: theme.textTheme.titleMedium!.copyWith(
              color: AppColors.textColorWhite,
              fontSize: 20,
              fontWeight: FontWeight.w400)),
    );
  }
}
