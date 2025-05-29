import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkUtils {
  static Future<void> checkConnection(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    final hasConnection = connectivityResult != ConnectivityResult.none;

    if (!hasConnection) {
      // Avoid navigating again if already on the NetworkErrorPage
      final isAlreadyOnErrorPage =
          ModalRoute.of(context)?.settings.name == '/network-error';

      if (!isAlreadyOnErrorPage) {
        Navigator.pushReplacementNamed(context, '/network-error');
      }
    }
  }
}
