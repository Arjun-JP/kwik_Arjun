// lib/features/address/presentation/pages/location_search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/models/order_model.dart' as Location;
import 'package:kwik/pages/Address_management/address_form.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  Location.Location? _selectedLocation;
  String? _selectedAddress;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is LocationSelected) {
            _selectedLocation = state.selectedLocation;
            _selectedAddress = state.selectedAddress;
            _mapController.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  state.selectedLocation.lat,
                  state.selectedLocation.lang,
                ),
              ),
            );
          } else if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TypeAheadField<String>(
                  // textFieldConfiguration: TextFieldConfiguration(
                  controller: _searchController,
                  // decoration: InputDecoration(
                  // hintText: 'Search for area, street name...',
                  // prefixIcon: const Icon(Icons.search),
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(8.0),
                  // ),
                  // filled: true,
                  // fillColor: Colors.grey[200],
                  // ),
                  //
                  suggestionsCallback: (pattern) async {
                    if (pattern.isNotEmpty) {
                      context.read<AddressBloc>().add(SearchLocation(pattern));
                      if (state is LocationSearchResults) {
                        return state.addresses;
                      }
                    }
                    return [];
                  },
                  itemBuilder: (context, address) {
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(address),
                    );
                  },
                  onSelected: (address) {
                    _searchController.text = address;
                    if (state is LocationSearchResults) {
                      final index = state.addresses.indexOf(address);
                      if (index != -1) {
                        context.read<AddressBloc>().add(
                              SelectLocation(
                                state.locations[index],
                                address,
                              ),
                            );
                      }
                    }
                  },
                ),
              ),
              Expanded(
                child: GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(28.6139, 77.2090), // Default to Delhi
                    zoom: 12,
                  ),
                  markers: _selectedLocation != null
                      ? {
                          Marker(
                            markerId: const MarkerId('selectedLocation'),
                            position: LatLng(
                              _selectedLocation!.lat,
                              _selectedLocation!.lang,
                            ),
                            infoWindow: InfoWindow(
                              title: _selectedAddress ?? 'Selected Location',
                            ),
                          ),
                        }
                      : {},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedLocation != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddressFormPage(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Confirm Location'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AddressBloc>().add(GetCurrentLocation());
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
