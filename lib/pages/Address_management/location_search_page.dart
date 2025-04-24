import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/doted_devider.dart';
import 'package:kwik/models/googlemap_place_model.dart';
import 'package:kwik/pages/Address_management/map.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  GoogleMapPlace? _selectedPlace;
  final FocusNode _searchFocusNode = FocusNode();
  GoogleMapPlace? selectedplace;
  List<GoogleMapPlace> suggestions = [];
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Select delivery Location',
          style: theme.textTheme.bodyLarge,
        ),
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is LocationSelected) {
          } else if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                      spacing: 15,
                      children: [
                        SizedBox(
                          height: 40,
                          child: BlocBuilder<AddressBloc, AddressState>(
                              builder: (context, state) {
                            if (state is LocationSearchResults) {
                              suggestions = state.placelist;
                            }
                            return TypeAheadField<GoogleMapPlace>(
                              debounceDuration:
                                  const Duration(milliseconds: 300),
                              hideOnEmpty: true,
                              hideOnLoading: false,
                              hideOnError: true,
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              suggestionsCallback: (pattern) async {
                                if (pattern.isNotEmpty) {
                                  print("suggestion call abck called");
                                  context
                                      .read<AddressBloc>()
                                      .add(SearchLocation(pattern));

                                  if (state is LocationSearchResults) {
                                    print(state.placelist.length);
                                    return state.placelist;
                                  }
                                }
                              },
                              builder: (context, controller, focusNode) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  // onSubmitted: _onSearch,
                                  onChanged: (value) {
                                    if (value.length >= 3) {
                                      context
                                          .read<AddressBloc>()
                                          .add(SearchLocation(value));

                                      setState(() {});
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.dotColorUnSelected,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: .5,
                                        color: AppColors.dotColorUnSelected,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 18, 23, 25),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    fillColor: AppColors.backgroundColorWhite,
                                    hintText:
                                        "Search for area, street  name...",
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon:
                                        _searchController.text.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(Icons.clear),
                                                onPressed: () {
                                                  _searchController.clear();
                                                },
                                              )
                                            : null,
                                  ),
                                );
                              },
                              itemBuilder: (context, place) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MapPage(
                                                  initialPlaceId: place.placeId,
                                                )));
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      // margin: const EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green[50],
                                      ),
                                      child: ListTile(
                                        dense: true,
                                        leading: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 232, 232, 232)),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 10),
                                            child: Icon(
                                              Icons.add_location_alt,
                                              color: Color.fromARGB(
                                                  255, 255, 94, 0),
                                            ),
                                          ),
                                        ),
                                        trailing: const Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          color:
                                              Color.fromARGB(255, 66, 143, 68),
                                        ),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              place.mainText,
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                            Text(
                                              place.description,
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 78, 78, 78),
                                                      fontWeight:
                                                          FontWeight.w500),
                                              maxLines: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onSelected: (place) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapPage(
                                              initialPlaceId: place.placeId,
                                            )));
                              },
                              loadingBuilder: (context) => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            );
                          }),
                        ),
                        currentlocationContainer(theme: theme),
                        savedaddressContainer(theme: theme),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapPage(
                                      initialPlaceId: selectedplace?.placeId,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Confirm Location'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget currentlocationContainer({required ThemeData theme}) {
    return Card(
      elevation: .5,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          spacing: 10,
          children: [
            ListTile(
              dense: true,
              leading: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 232, 232, 232)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Icon(
                    Icons.add_location_alt,
                    color: Color.fromARGB(255, 66, 143, 68),
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Color.fromARGB(255, 156, 154, 154),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Use your current location",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color.fromARGB(255, 66, 143, 68),
                    ),
                  ),
                  Text(
                    "place.description",
                    style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 156, 154, 154),
                        fontWeight: FontWeight.w500),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const DottedDivider(
              color: Color.fromARGB(255, 195, 195, 196),
            ),
            ListTile(
              dense: true,
              leading: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 232, 232, 232)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 66, 143, 68),
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Color.fromARGB(255, 156, 154, 154),
              ),
              title: Text(
                "Add new address",
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: const Color.fromARGB(255, 66, 143, 68),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget savedaddressContainer({required ThemeData theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Your saved address",
          style: theme.textTheme.bodyMedium!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: const Color.fromARGB(255, 84, 84, 84),
          ),
        ),
        Column(
          children: List.generate(
            5,
            (index) => Card(
              color: Colors.white,
              elevation: .5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: ListTile(
                  dense: true,
                  leading: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 232, 232, 232)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Icon(
                        Icons.home_outlined,
                        color: Color.fromARGB(255, 255, 94, 0),
                      ),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Color.fromARGB(255, 66, 143, 68),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Home",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Text(
                        "No. 20,E184 3rd cross, Patelappa Layout, Nagashetty Halli, R.M.V 2nd Stage, Bengaluru 560094",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 78, 78, 78),
                            fontWeight: FontWeight.w500),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
