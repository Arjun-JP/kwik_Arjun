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
    return Container(
      color: Colors.amber,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text(widget.errordetails.summary.toString()),
      ),
    );
  }
}
