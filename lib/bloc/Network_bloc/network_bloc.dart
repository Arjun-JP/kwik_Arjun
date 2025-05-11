import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:kwik/bloc/Network_bloc/network_event.dart';
import 'package:kwik/bloc/Network_bloc/network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  StreamSubscription? _connectivitySubscription;

  NetworkBloc() : super(NetworkInitial()) {
    on<NetworkObserve>(_observe);
    on<NetworkNotify>(_notifyStatus);

    // Start observing right away
    add(NetworkObserve());
  }

  void _observe(event, emit) {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        add(NetworkNotify(isConnected: false));
      } else {
        add(NetworkNotify(isConnected: true));
      }
    });
    Connectivity().checkConnectivity().then((results) {
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        add(NetworkNotify(isConnected: false));
      } else {
        add(NetworkNotify(isConnected: true));
      }
    });
  }

  void _notifyStatus(NetworkNotify event, emit) {
    event.isConnected ? emit(NetworkSuccess()) : emit(NetworkFailure());
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
