// lib/features/address/presentation/bloc/address_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/models/googlemap_place_model.dart';
import 'package:kwik/models/order_model.dart' as Location;
import 'package:kwik/repositories/googlemap_service.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GoogleMapsService repository;
  AddressBloc(this.repository) : super(AddressInitial()) {
    on<SearchLocation>(_onSearchLocation);
    on<SelectLocation>(_onSelectLocation);
    on<SaveAddress>(_onSaveAddress);
    on<GetCurrentLocation>(_onGetCurrentLocation);
  }

  Future<void> _onSearchLocation(
    SearchLocation event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      if (event.query.isEmpty) {
        emit(const AddressError('Please enter a location'));
        return;
      }

      List<GoogleMapPlace> lovationlist =
          await repository.searchPlaces(event.query);

      if (lovationlist.isEmpty) {
        emit(const AddressError('No locations found'));
        return;
      }
      print(event.query);
      // print(lovationlist.map((e) => e.name).toList());
      // print(lovationlist.first.toJson());
      emit(LocationSearchResults(lovationlist));
    } catch (e) {
      emit(AddressError('Failed to search location: $e'));
    }
  }

  Future<void> _onSelectLocation(
    SelectLocation event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      emit(LocationSelected(event.location, event.address));
    } catch (e) {
      emit(AddressError('Failed to select location: $e'));
    }
  }

  Future<void> _onSaveAddress(
    SaveAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      // Here you would typically save to your database/API
      // For now, we'll just emit the saved address
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      emit(AddressSaved(event.address));
    } catch (e) {
      emit(AddressError('Failed to save address: $e'));
    }
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocation event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const AddressError('Location services are disabled'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const AddressError('Location permissions are denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(const AddressError(
            'Location permissions are permanently denied, we cannot request permissions.'));
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        emit(const AddressError('No address found for current location'));
        return;
      }

      Placemark placemark = placemarks.first;
      String address =
          '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';

      final location = Location.Location(
        lat: position.latitude,
        lang: position.longitude,
      );

      emit(LocationSelected(location, address));
    } catch (e) {
      emit(AddressError('Failed to get current location: $e'));
    }
  }
}
