// lib/features/address/presentation/bloc/address_bloc.dart
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
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
    on<ResetaddressEvent>(_onResetAddress);
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
    print("GetSavedAddressEventcalled11111");
    List<GoogleMapPlace> existingLovationlist = [];
    WarehouseModel? warehouse;
    String currentPlaceId = "";
    String currentLocationAddress = "";
    String currentPincode = "";

    // Preserve existing warehouse if available
    if (state is LocationSearchResults) {
      existingLovationlist = (state as LocationSearchResults).placelist;
      warehouse = (state as LocationSearchResults).warehouse;
    }
    emit(AddressLoading()); // Emit loading state
    try {
      final useraddressdata =
          await savedaddressrepository.getAddressesFromServer();
      final List<AddressModel> savedaddress =
          (useraddressdata["addresses"] as List?)?.cast<AddressModel>() ?? [];
      final AddressModel? selectedaddressfromdb =
          useraddressdata["selectedAddress"];

      // Get existing state data if available

      if (selectedaddressfromdb != null) {
        currentLocationAddress =
            "${selectedaddressfromdb.flatNoName}, ${selectedaddressfromdb.area}, ${selectedaddressfromdb.pincode}";
        currentPincode = selectedaddressfromdb.pincode;

        // Only fetch warehouse if we don't already have one
        if (warehouse == null) {
          warehouse = await _fetchWarehouseDetails(
              selectedaddressfromdb.pincode, selectedaddressfromdb.location);
        }
        print("addresslength: ${savedaddress.length}");
        emit(LocationSearchResults(
          existingLovationlist,
          savedaddress,
          currentPlaceId,
          currentLocationAddress,
          selectedaddressfromdb,
          warehouse, // Use existing or newly fetched warehouse
          currentPincode,
          false,
        ));
      } else {
        List<String> curentlocationdetails = await _loadPlaceDetails();
        String fetchedPlaceId = curentlocationdetails.firstOrNull ?? "";
        String fetchedAddress = curentlocationdetails.lastOrNull ?? "";
        String fetchedPincode =
            extractAddressDetails(fetchedAddress)["pin"] ?? "";

        emit(LocationSearchResults(
          existingLovationlist,
          savedaddress,
          fetchedPlaceId,
          fetchedAddress,
          null,
          warehouse, // Use existing warehouse if available
          fetchedPincode,
          false,
        ));
      }
    } catch (error) {
      // Handle error case - preserve existing warehouse if available
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
        warehouse = (state as LocationSearchResults)
            .warehouse; // Preserve existing warehouse
        differentaddress =
            (state as LocationSearchResults).orderfordefferentaddress;
      }

      emit(LocationSearchResults(
        fallbackLovationlist,
        [],
        placeId,
        address,
        selectedaddress,
        warehouse, // Keep existing warehouse on error
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
    print("current loacation called");
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
      await savedaddressrepository.updatecurrentpincode(placemark.postalCode!);
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
        print("warehouse: $warehouse");
      }
      emit(LocationSearchResults(
          existingLovationlist,
          existingsavedaddresslist,
          placeId,
          address,
          selectedaddress,
          null,
          extractAddressDetails(address)["pin"]!,
          differentaddress));
    } catch (error) {
      print(error);
      print("faild to add address");
    }
  }

  Future<void> _ongetwarehousedetails(
      GetWarehousedetailsEvent event, Emitter<AddressState> emit) async {
    try {
      emit(AddressLoading());
      print("GetWarehousedataEventcalled");
      print(event.pincode);
      // await savedaddressrepository.updatecurrentpincode(event.pincode!);
      WarehouseModel? warehouse =
          await savedaddressrepository.getwarehousedetails(event.pincode,
              event.location.lat.toString(), event.location.lang.toString());
      print(warehouse.toString());
      if (warehouse != null) {
        // Get the current state and update warehouse
        if (state is LocationSearchResults) {
          final currentState = state as LocationSearchResults;
          emit(currentState.copyWith(
            warehouse: warehouse,
            currentlocationaddress: event.usedaddress,
            pincode: currentState.pincode.isNotEmpty
                ? currentState.pincode
                : event.pincode,
          ));
        } else {
          emit(LocationSearchResults([], [], "", event.usedaddress, null,
              warehouse, event.pincode, false));
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

  Future<void> _onResetAddress(
      ResetaddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressInitial()); // Reset to initial state
  }
}

Future<Map<String, dynamic>?> getPlaceDetailsFromCurrentLocation() async {
  final String apiKey = "AIzaSyAPLvvnotvyrbkQVynYChnZhyrgSWAjO1k";

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
  print(formattedAddress);
  // final parts = formattedAddress.split(', ');
  // String? pin;
  // if (parts.isNotEmpty) {
  //   final lastPart = parts.last;
  //   final pinMatch = RegExp(r'\d{6}').firstMatch(lastPart);
  //   if (pinMatch != null) {
  //     pin = pinMatch.group(0);
  //   }
  // }
  // print(pin);
  // return {'pin': pin ?? ''};
  final pinMatch = RegExp(r'\b\d{6}\b').firstMatch(formattedAddress);

  // Extract the matched pin code
  final pin = pinMatch?.group(0) ?? '';

  print('Extracted Pincode: $pin');
  return {'pin': pin};
}
