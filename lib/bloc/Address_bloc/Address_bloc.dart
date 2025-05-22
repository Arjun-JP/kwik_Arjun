// lib/features/address/presentation/bloc/address_bloc.dart
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/models/address_model.dart';
import 'package:kwik/models/googlemap_place_model.dart';
import 'package:kwik/models/order_model.dart' as Location;
import 'package:kwik/models/warehouse_model.dart';
import 'package:kwik/repositories/address_repo.dart';
import 'package:kwik/repositories/googlemap_service.dart';
import 'package:http/http.dart' as http;

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GoogleMapsService repository;
  final AddressRepository savedaddressrepository;

  AddressBloc(this.repository, this.savedaddressrepository)
      : super(AddressInitial()) {
    on<SearchLocation>(_onSearchLocation);
    on<SelectLocation>(_onSelectLocation);
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<GetsavedAddressEvent>(_ongetalladdress);
    on<UpdateselectedaddressEvent>(_onupdateselectedaddress);
    on<AddanewAddressEvent>(_onaddnewaddress);
    on<GetWarehousedetailsEvent>(_ongetwarehousedetails);
  }

  FutureOr<void> _onupdateselectedaddress(
      UpdateselectedaddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading()); // Emit loading state

    try {
      await savedaddressrepository.setDefaultAddress(event.address.id!);
      // Fetch warehouse details for the newly selected address
      final warehouse = await _fetchWarehouseDetails(
          event.address.pincode, event.address.location);
      List<GoogleMapPlace> fallbackLovationlist = [];
      List<AddressModel> savedaddressList = [];
      if (state is LocationSearchResults) {
        print("222222");
        fallbackLovationlist = (state as LocationSearchResults).placelist;
        savedaddressList = (state as LocationSearchResults).addresslist;
      }
      print("333333");
      emit(LocationSearchResults(
        fallbackLovationlist,
        savedaddressList,
        "",
        "${event.address.flatNoName}, ${event.address.area}, ${event.address.pincode}",
        event.address,
        warehouse,
        event.address.pincode,
        false,
      ));
    } catch (error) {
      print("444444");
      emit(const NowarehousefoudState());
    }
  }

  Future<void> _ongetalladdress(
    GetsavedAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading()); // Emit loading state
    try {
      final useraddressdata =
          await savedaddressrepository.getAddressesFromServer();
      final List<AddressModel> savedaddress =
          (useraddressdata["addresses"] as List?)?.cast<AddressModel>() ?? [];
      final AddressModel? selectedaddressfromdb =
          useraddressdata["selectedAddress"];

      List<GoogleMapPlace> existingLovationlist = [];
      WarehouseModel? warehouse;
      String currentPlaceId = "";
      String currentLocationAddress = "";
      String currentPincode = "";

      if (selectedaddressfromdb != null) {
        currentLocationAddress =
            "${selectedaddressfromdb.flatNoName}, ${selectedaddressfromdb.area}, ${selectedaddressfromdb.pincode}";
        currentPincode = selectedaddressfromdb.pincode;
        warehouse = await _fetchWarehouseDetails(
            selectedaddressfromdb.pincode, selectedaddressfromdb.location);
        if (state is LocationSearchResults) {
          existingLovationlist = (state as LocationSearchResults).placelist;
        }
        emit(LocationSearchResults(
          existingLovationlist,
          savedaddress,
          currentPlaceId,
          currentLocationAddress,
          selectedaddressfromdb,
          warehouse,
          currentPincode,
          false,
        ));
      } else {
        List<String> curentlocationdetails = await _loadPlaceDetails();
        String fetchedPlaceId = curentlocationdetails.firstOrNull ?? "";
        String fetchedAddress = curentlocationdetails.lastOrNull ?? "";
        String fetchedPincode =
            extractAddressDetails(fetchedAddress)["pin"] ?? "";
        if (state is LocationSearchResults) {
          existingLovationlist = (state as LocationSearchResults).placelist;
          warehouse = (state as LocationSearchResults).warehouse;
        }
        emit(LocationSearchResults(
          existingLovationlist,
          savedaddress,
          fetchedPlaceId,
          fetchedAddress,
          null,
          warehouse,
          fetchedPincode,
          false,
        ));
      }
    } catch (error) {
      // Handle error case
      List<GoogleMapPlace> fallbackLovationlist = [];
      String placeId = "";
      String address = "";
      AddressModel? selectedaddress;
      WarehouseModel? warehouse;
      bool differentaddress = false;

      if (state is LocationSearchResults) {
        fallbackLovationlist = (state as LocationSearchResults).placelist;
        placeId = (state as LocationSearchResults).currentplaceID;
        address = (state as LocationSearchResults).currentlocationaddress;
        selectedaddress = (state as LocationSearchResults).selecteaddress;
        warehouse = (state as LocationSearchResults).warehouse;
        differentaddress =
            (state as LocationSearchResults).orderfordefferentaddress;
      }

      emit(LocationSearchResults(
        fallbackLovationlist,
        [],
        placeId,
        address,
        selectedaddress,
        warehouse,
        extractAddressDetails(address)["pin"] ?? "",
        differentaddress,
      ));

      emit(AddressError('Failed to load saved addresses: $error'));
    }
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
      List<AddressModel> existingsavedaddresslist = [];
      String placeId = "";
      String address = "";
      AddressModel? selectedaddress;
      WarehouseModel? warehouse;
      bool differentaddress = false;
      if (state is LocationSearchResults) {
        existingsavedaddresslist = (state as LocationSearchResults).addresslist;
        placeId = (state as LocationSearchResults).currentplaceID;
        address = (state as LocationSearchResults).currentlocationaddress;
        selectedaddress = (state as LocationSearchResults).selecteaddress;
        differentaddress =
            (state as LocationSearchResults).orderfordefferentaddress;
        warehouse = (state as LocationSearchResults).warehouse;
      }
      emit(LocationSearchResults(
          lovationlist,
          existingsavedaddresslist,
          placeId,
          address,
          selectedaddress,
          warehouse!,
          extractAddressDetails(address)["pin"]!,
          differentaddress));
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
      // emit(AddressError('Failed to select location: $e'));
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

  Future<void> _onaddnewaddress(
      AddanewAddressEvent event, Emitter<AddressState> emit) async {
    try {
      await savedaddressrepository.addAddress(event.address, event.userID);
      List<GoogleMapPlace> existingLovationlist = [];
      List<AddressModel> existingsavedaddresslist = [];
      String placeId = "";
      String address = "";
      AddressModel? selectedaddress;
      WarehouseModel? warehouse;
      bool differentaddress = false;
      if (state is LocationSearchResults) {
        existingLovationlist = (state as LocationSearchResults).placelist;
        existingsavedaddresslist = (state as LocationSearchResults).addresslist;
        placeId = (state as LocationSearchResults).currentplaceID;
        address = event.address.flatNoName +
            event.address.area +
            event.address.pincode;
        selectedaddress = (state as LocationSearchResults).selecteaddress;
        differentaddress =
            (state as LocationSearchResults).orderfordefferentaddress;
        warehouse = (state as LocationSearchResults).warehouse;
      }
      emit(LocationSearchResults(
          existingLovationlist,
          existingsavedaddresslist,
          placeId,
          address,
          selectedaddress,
          warehouse!,
          extractAddressDetails(address)["pin"]!,
          differentaddress));
    } catch (error) {
      print("faild to add address");
    }
  }

  Future<void> _ongetwarehousedetails(
      GetWarehousedetailsEvent event, Emitter<AddressState> emit) async {
    try {
      emit(AddressLoading());
      WarehouseModel? warehouse =
          await savedaddressrepository.getwarehousedetails(event.pincode,
              event.location.lat.toString(), event.location.lang.toString());
      if (warehouse != null) {
        // Get the current state and update warehouse
        if (state is LocationSearchResults) {
          final currentState = state as LocationSearchResults;
          emit(currentState.copyWith(warehouse: warehouse));
        } else {
          emit(LocationSearchResults(
              [], [], "", "", null, warehouse, "", false));
        }
      } else {
        emit(const NowarehousefoudState());
      }
    } catch (error) {
      print(error);
    }
  }

  Future<WarehouseModel?> _fetchWarehouseDetails(
      String pincode, Location.Location location) async {
    try {
      return await savedaddressrepository.getwarehousedetails(
          pincode, location.lat.toString(), location.lang.toString());
    } catch (e) {
      print("Error fetching warehouse details: $e");
      return null;
    }
  }
}

Future<Map<String, dynamic>?> getPlaceDetailsFromCurrentLocation() async {
  final String apiKey = dotenv.env['GOOGLEMAP_APIKEY']!;

  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request them.');
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final List<dynamic> results = data['results'];
        if (results.isNotEmpty) {
          final Map<String, dynamic> firstResult = results[0];
          Map<String, dynamic> placeDetails = {
            'place_id': firstResult['place_id'],
            'formatted_address': firstResult['formatted_address'],
          };
          return placeDetails;
        } else {
          print('No results found for the given location.');
          return null;
        }
      } else {
        print('Google Maps API error: ${data['status']}');
        return null;
      }
    } else {
      print(
          'Failed to fetch place details. HTTP status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error getting place details: $e');
    return null;
  }
}

Future<List<String>> _loadPlaceDetails() async {
  try {
    Map<String, dynamic>? placeDetails =
        await getPlaceDetailsFromCurrentLocation();
    if (placeDetails != null) {
      return [
        placeDetails['place_id'] as String,
        placeDetails['formatted_address'] as String
      ];
    } else {
      print('Failed to get place details');
      return ["", ""];
    }
  } catch (e) {
    print('Exception occurred: $e');
    return ["", ""];
  }
}

Map<String, String> extractAddressDetails(String formattedAddress) {
  final parts = formattedAddress.split(', ');
  String? pin;
  if (parts.isNotEmpty) {
    final lastPart = parts.last;
    final pinMatch = RegExp(r'\d{6}').firstMatch(lastPart);
    if (pinMatch != null) {
      pin = pinMatch.group(0);
    }
  }
  return {'pin': pin ?? ''};
}
