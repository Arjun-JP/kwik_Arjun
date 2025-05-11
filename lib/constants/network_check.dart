import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Network_bloc/network_bloc.dart';
import 'package:kwik/bloc/Network_bloc/network_state.dart';

class NetworkController extends ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  NetworkController() {
    _init();
  }
  Future<void> _init() async {
    // Check initial connectivity
    var connectivityResults = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResults);

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final newStatus =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);
    if (newStatus != _isConnected) {
      _isConnected = newStatus;
      notifyListeners();
    }
  }
}

class NetworkAwareWidget extends StatelessWidget {
  final Widget child;

  const NetworkAwareWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(
      builder: (context, state) {
        return Stack(
          // Use non-directional alignment to avoid Directionality requirement
          alignment: Alignment.topCenter,
          children: [
            // Main content
            child,

            // Offline banner
            if (state is NetworkFailure)
              SafeArea(
                child: Material(
                  color: Colors.red,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'No Internet Connection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
