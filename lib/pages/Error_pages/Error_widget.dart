import 'package:flutter/material.dart';

class KwikErrorWidget extends StatefulWidget {
  final FlutterErrorDetails errordetails;
  const KwikErrorWidget({super.key, required this.errordetails});

  @override
  State<KwikErrorWidget> createState() => _KwikErrorWidgetState();
}

class _KwikErrorWidgetState extends State<KwikErrorWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          spacing: 10,
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg',
                width: 100,
                height: 100,
              ),
            ),
            Flexible(
              child: Text(
                "The application has encountered an unexpected error and needs to restart.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              child: Text(
                widget.errordetails.exception.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }
}
