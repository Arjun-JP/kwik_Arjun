import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
    child: Center(child: CircularProgressIndicator()),

    );


  }
}
