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
    // on<SaveAddress>(_onSaveAddress);
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<GetsavedAddressEvent>(_ongetalladdress);
    on<UpdateselectedaddressEvent>(_onupdateselectedaddress);
    on<AddanewAddressEvent>(_onaddnewaddress);
    on<GetWarehousedetailsEvent>(_ongetwarehousedetails);
  }

  FutureOr<void> _onupdateselectedaddress(
      UpdateselectedaddressEvent event, Emitter<AddressState> emit) {
    List<GoogleMapPlace> fallbackLovationlist = [];
    List<AddressModel> savedaddress = [];
    String placeId = "";
    String address = "";
    AddressModel? selecetdaddress = event.address;
    WarehouseModel? warehouse;

    if (state is LocationSearchResults) {
      // print((state as LocationSearchResults).selecteaddress?.id);
      fallbackLovationlist = (state as LocationSearchResults).placelist;
      placeId = (state as LocationSearchResults).currentplaceID;
      savedaddress = (state as LocationSearchResults).addresslist;
      // print(event.address.id);
      warehouse = (state as LocationSearchResults).warehouse;
    }
    savedaddressrepository.setDefaultAddress(event.address.id!);
    emit(LocationSearchResults(
      fallbackLovationlist, // Use the existing list here
      savedaddress,
      placeId,
      address,
      selecetdaddress,
      warehouse!,
    ));
  }

  Future<void> _ongetalladdress(
    GetsavedAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      // Get saved addresses from server

      Map<String, dynamic> useraddressdata =
          await savedaddressrepository.getAddressesFromServer();
      List<AddressModel> savedaddress = useraddressdata["addresses"];
      AddressModel? selectedaddressfromdb = useraddressdata["selectedAddress"];
      List<String> curentlocationdetails = await _loadPlaceDetails();
      // Get existing lovationlist from current state if available
      List<GoogleMapPlace> existingLovationlist = [];
      AddressModel? selectedaddress;
      WarehouseModel? warehouse;

      if (state is LocationSearchResults) {
        existingLovationlist = (state as LocationSearchResults).placelist;
        selectedaddress = (state as LocationSearchResults).selecteaddress ??
            savedaddress.first;

        warehouse = (state as LocationSearchResults).warehouse;
      }

      // Emit new state with saved addresses and existing lovationlist
      emit(LocationSearchResults(
          existingLovationlist,
          savedaddress,
          curentlocationdetails[0],
          curentlocationdetails[1],
          selectedaddress,
          warehouse!));
    } catch (error) {
      // Handle error case - use empty list if current state isn't LocationSearchResults
      List<GoogleMapPlace> fallbackLovationlist = [];
      String placeId = "";
      String address = "";
      AddressModel? selectedaddress;
      WarehouseModel? warehouse;

      if (state is LocationSearchResults) {
        fallbackLovationlist = (state as LocationSearchResults).placelist;
        placeId = (state as LocationSearchResults).currentplaceID;
        address = (state as LocationSearchResults).currentlocationaddress;
        selectedaddress = (state as LocationSearchResults).selecteaddress;

        warehouse = (state as LocationSearchResults).warehouse;
      }

      emit(LocationSearchResults(fallbackLovationlist, [], placeId, address,
          selectedaddress, warehouse!));

      // You might want to emit an error state here as well
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

      if (state is LocationSearchResults) {
        existingsavedaddresslist = (state as LocationSearchResults).addresslist;
        placeId = (state as LocationSearchResults).currentplaceID;
        address = (state as LocationSearchResults).currentlocationaddress;
        selectedaddress = (state as LocationSearchResults).selecteaddress;

        warehouse = (state as LocationSearchResults).warehouse;
      }
      emit(LocationSearchResults(lovationlist, existingsavedaddresslist,
          placeId, address, selectedaddress, warehouse!));
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

  // Future<void> _onSaveAddress(
  //   SaveAddress event,
  //   Emitter<AddressState> emit,
  // ) async {
  //   emit(AddressLoading());
  //   try {
  //     // Here you would typically save to your database/API
  //     // For now, we'll just emit the saved address
  //     await Future.delayed(const Duration(seconds: 1)); // Simulate API call
  //     emit(AddressSaved(event.address));
  //   } catch (e) {
  //     emit(AddressError('Failed to save address: $e'));
  //   }
  // }

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
      // print(event.userID);
      List<AddressModel> existingsavedaddresslist = [];
      String placeId = "";
      String address = "";
      AddressModel? selectedaddress;
      WarehouseModel? warehouse;

      if (state is LocationSearchResults) {
        existingsavedaddresslist = (state as LocationSearchResults).addresslist;
        placeId = (state as LocationSearchResults).currentplaceID;
        address = (state as LocationSearchResults).currentlocationaddress;
        selectedaddress = (state as LocationSearchResults).selecteaddress;

        warehouse = (state as LocationSearchResults).warehouse;
      }
      emit(LocationSearchResults([], existingsavedaddresslist, placeId, address,
          selectedaddress, warehouse!));
    } catch (error) {
      print("faild to add address");
    }
  }

  Future<void> _ongetwarehousedetails(
      GetWarehousedetailsEvent event, Emitter<AddressState> emit) async {
    try {
      WarehouseModel? warehouse =
          await savedaddressrepository.getwarehousedetails(event.pincode,
              event.location.lat.toString(), event.location.lang.toString());
      if (warehouse != null) {
        emit(LocationSearchResults([], [], "", "", null, warehouse));
      } else {
        emit(const NowarehousefoudState());
      }
    } catch (error) {
      print(error);
    }
  }
}

Future<Map<String, dynamic>?> getPlaceDetailsFromCurrentLocation() async {
  const String apiKey = 'AIzaSyAPLvvnotvyrbkQVynYChnZhyrgSWAjO1k';

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

    // 2. Construct the URL for the Google Maps Geocoding API (Reverse Geocoding)
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';

    // 3. Make the API request using the http package
    final response = await http.get(Uri.parse(url));

    // 4. Check the response status code
    if (response.statusCode == 200) {
      // 5. Decode the JSON response
      final Map<String, dynamic> data = json.decode(response.body);

      // 6. Check the API status in the response
      if (data['status'] == 'OK') {
        // 7. Extract the relevant information from the results
        final List<dynamic> results = data['results'];
        if (results.isNotEmpty) {
          // We take the first result as it is the most relevant
          final Map<String, dynamic> firstResult = results[0];

          // Create a map to hold the place details.  Customize this as needed.
          Map<String, dynamic> placeDetails = {
            'place_id': firstResult['place_id'],
            'formatted_address': firstResult['formatted_address'],
            // You can add more fields here, for example:
            // 'address_components': firstResult['address_components'],
            // 'geometry': firstResult['geometry'],
            // 'types': firstResult['types'],
          };

          // print(placeDetails);
          return placeDetails;
        } else {
          print('No results found for the given location.');
          return null; // Or throw an exception if you prefer.
        }
      } else {
        print('Google Maps API error: ${data['status']}');
        return null; // Or throw an exception.
      }
    } else {
      print(
          'Failed to fetch place details. HTTP status code: ${response.statusCode}');
      return null; // Or throw an exception.
    }
  } catch (e) {
    // Handle any exceptions that occur during the process
    print('Error getting place details: $e');
    return null; // Or rethrow the exception if you want the caller to handle it.
  }
}

Future<List<String>> _loadPlaceDetails() async {
  try {
    Map<String, dynamic>? placeDetails =
        await getPlaceDetailsFromCurrentLocation();
    if (placeDetails != null) {
      return [placeDetails['place_id'], placeDetails['formatted_address']];
    } else {
      // Handle the error:  show a message to the user, etc.
      print('Failed to get place details');
      return ["", ""];
    }
  } catch (e) {
    print('Exception occurred: $e');
    return ["", ""];
  }
}
