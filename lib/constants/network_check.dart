import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NetworkMonitor {
  static final NetworkMonitor _instance = NetworkMonitor._internal();
  factory NetworkMonitor() => _instance;
  NetworkMonitor._internal();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _subscription;
  bool isOffline = false;

  void startMonitoring(BuildContext context) {
    _subscription = _connectivity.onConnectivityChanged.listen((status) {
      final hasInternet = status != ConnectivityResult.none;

      if (!hasInternet && !isOffline) {
        isOffline = true;
        context.go('/network-error');
      } else if (hasInternet && isOffline) {
        isOffline = false;
        context.go('/'); // or any route you want to return to
      }
    });
  }

  void dispose() {
    _subscription.cancel();
  }
}
