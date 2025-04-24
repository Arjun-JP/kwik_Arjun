import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:kwik/constants/colors.dart';
import 'package:kwik/pages/Address_management/address_form.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import the dart:convert package

class MapPage extends StatefulWidget {
  final String? initialPlaceId; // Add this line

  const MapPage({super.key, this.initialPlaceId}); // Modify this constructor

  @override
  State<MapPage> createState() => _AddadressState();
}

class _AddadressState extends State<MapPage> {
  //get map controller to access map
  final Completer<gmap.GoogleMapController> _googleMapController = Completer();
  final TextEditingController _searchController = TextEditingController();
  gmap.CameraPosition? _cameraPosition;
  late gmap.LatLng _draggedLatlng;
  String _draggedAddress = "";
  bool _isMapLoaded =
      false; // Track if the map is loaded to prevent errors.  Crucial.
  List<String> _suggestions = []; // List to store autocomplete suggestions
  bool _showSuggestions = false; //show/hide suggestion list
  String? _placeId; // Store the place ID

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    print(widget.initialPlaceId);
    _placeId = widget.initialPlaceId;
    // Initialize the map with a default location (Bangalore)
    _draggedLatlng = const gmap.LatLng(12.9716, 77.5946);
    _cameraPosition = gmap.CameraPosition(
      target: _draggedLatlng,
      zoom: 15,
      tilt: 30,
    );

    if (_placeId != null) {
      _getLatLngFromPlaceId(_placeId!); // Fetch and set location from Place ID
    } else {
      _getAddress(_draggedLatlng);
    }
  }

  Future<void> _getLatLngFromPlaceId(String placeId) async {
    // Replace YOUR_API_KEY with your actual Google Places API key
    const String apiKey = 'AIzaSyAPLvvnotvyrbkQVynYChnZhyrgSWAjO1k';
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final results = data['results'] as List;
          if (results.isNotEmpty) {
            final location = results[0]['geometry']['location'];
            final lat = location['lat'];
            final lng = location['lng'];
            _draggedLatlng = gmap.LatLng(lat, lng);

            _cameraPosition = gmap.CameraPosition(
              target: _draggedLatlng,
              zoom: 15,
              tilt: 30,
            );
            if (_isMapLoaded) {
              _gotoSpecificPosition(_draggedLatlng); //update map
            } else {
              _getAddress(_draggedLatlng); //get address
            }
            setState(() {}); // Trigger a rebuild to update the map
          } else {
            _getAddress(_draggedLatlng);
            print('No results found for Place ID: $placeId');
          }
        } else {
          _getAddress(_draggedLatlng);
          print('Geocoding API error: ${data['status']}');
        }
      } else {
        _getAddress(_draggedLatlng);
        print('Failed to fetch location: ${response.statusCode}');
      }
    } catch (e) {
      _getAddress(_draggedLatlng);
      print('Error fetching location: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose(); //prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(children: [
      _getMap(),
      _getCustomPin(),
      Positioned(
        top: 90,
        left: 10,
        right: 10,
        child: _buildSearchBar(),
      ),
      Positioned(
        bottom: 10,
        right: 15,
        left: 15,
        child: _showDraggedAddress(),
      ),
      if (_showSuggestions)
        Positioned(
          top: 150, // Adjust as needed to position below search bar
          left: 10,
          right: 10,
          child: _buildSuggestionsList(),
        ),
    ]);
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search location",
          fillColor: Colors.white,
          filled: true,
          prefixIcon: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
            ),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _suggestions = [];
                _showSuggestions = false;
              });
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.buttonColorOrange, width: .5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.buttonColorOrange, width: .5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.buttonColorOrange, width: .5),
          ),
        ),
        onChanged: (value) {
          _getPlaceSuggestions(value);
        },
        onSubmitted: (value) => _handleSearch(value),
      ),
    );
  }

  Future<void> _handleSearch(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final firstLocation = locations.first;
        gmap.LatLng newLatLng =
            gmap.LatLng(firstLocation.latitude, firstLocation.longitude);
        _gotoSpecificPosition(newLatLng);
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not found. Please try again.")),
      );
    }
  }

  Widget _showDraggedAddress() {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.dotColorSelected, width: .1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _draggedAddress,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: SizedBox(
                width: double.infinity,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    print("bttonclicked");
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddressFormPage(
                        latlanglocation: _draggedLatlng,
                        selectedaddress: _draggedAddress,
                      ),
                    ));
                    //  Pass the address and LatLng back
                    Navigator.pop(context, {
                      'address': _draggedAddress,
                      'latlng': _draggedLatlng,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 1, 170, 97),
                  ),
                  child: Text(
                    'Confirm Address',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMap() {
    return gmap.GoogleMap(
      initialCameraPosition: _cameraPosition!,
      mapType: gmap.MapType.normal,
      myLocationEnabled: true,
      onCameraIdle: () {
        if (_isMapLoaded) {
          _getAddress(_draggedLatlng);
        }
      },
      onCameraMove: (cameraPosition) {
        _draggedLatlng = cameraPosition.target;
      },
      onMapCreated: (gmap.GoogleMapController controller) {
        if (!_googleMapController.isCompleted) {
          _googleMapController.complete(controller);
        }
        _isMapLoaded =
            true; //  Set the flag when the map is created.  Important
      },
      zoomControlsEnabled:
          false, //hide zoom buttons, use gestures.  Good practice.
    );
  }

  Widget _getCustomPin() {
    return Center(
      child: SizedBox(
        width: 100,
        child: Lottie.network(
            "https://lottie.host/3f2ce26a-5954-4b7c-9ebd-da368483468f/vouedJMJBR.json"),
      ),
    );
  }

  Future _getAddress(gmap.LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark address = placemarks[0];
        String addressStr =
            "${address.street}, ${address.subLocality}, ${address.locality}, ${address.administrativeArea} ${address.postalCode}, ${address.country}";

        setState(() {
          _draggedAddress = addressStr;
        });
      } else {
        setState(() {
          _draggedAddress = "No address found for this location.";
        });
      }
    } catch (e) {
      print("Error fetching address: $e");
      setState(() {
        _draggedAddress = "Error fetching address.";
      });
    }
  }

  Future<void> _gotoSpecificPosition(gmap.LatLng position) async {
    final gmap.GoogleMapController mapController =
        await _googleMapController.future;
    mapController.animateCamera(gmap.CameraUpdate.newCameraPosition(
      gmap.CameraPosition(target: position, zoom: 17.5),
    ));
    _draggedLatlng =
        position; // Update the draggedLatLng.  VERY IMPORTANT for accurate address.
    await _getAddress(position);
    setState(() {
      _showSuggestions = false; // Hide suggestions after selecting a place.
      _searchController.text = _draggedAddress; //update search text.
    });
  }

  // Function to fetch place suggestions using Google Places Autocomplete API
  Future<void> _getPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    // Replace YOUR_API_KEY with your actual Google Places API key
    const String apiKey = 'AIzaSyAPLvvnotvyrbkQVynYChnZhyrgSWAjO1k';
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&sessiontoken=1234567890'; // Use a session token

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          List<String> suggestions = predictions
              .map((prediction) => prediction['description'] as String)
              .toList();
          setState(() {
            _suggestions = suggestions;
            _showSuggestions = true;
          });
        } else {
          setState(() {
            _suggestions = [];
            _showSuggestions = false;
          });
          print('Google Places API error: ${data['status']}');
        }
      } else {
        setState(() {
          _suggestions = [];
          _showSuggestions = false;
        });
        print(
            'Failed to fetch suggestions: ${response.statusCode}'); //important
      }
    } catch (e) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      print('Error fetching suggestions: $e');
    }
  }

  // Widget to display the list of suggestions
  Widget _buildSuggestionsList() {
    return Material(
      elevation: 4, // Add shadow for better visibility
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: _suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = _suggestions[index];
            return ListTile(
              onTap: () {
                _searchController.text = suggestion;
                _handleSearch(suggestion);
                setState(() {
                  _showSuggestions = false;
                });
              },
              title: Text(suggestion),
            );
          },
        ),
      ),
    );
  }
}
