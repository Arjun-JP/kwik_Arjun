import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/constants/doted_devider.dart';
import 'package:kwik/models/address_model.dart';
import 'package:kwik/models/googlemap_place_model.dart';
import 'package:kwik/pages/Address_management/map.dart';
import 'package:kwik/widgets/change_defaultaddress_bottomsheet.dart';

class AddressSelectionBottomSheet extends StatefulWidget {
  const AddressSelectionBottomSheet({super.key});

  @override
  State<AddressSelectionBottomSheet> createState() =>
      _AddressSelectionBottomSheetState();
}

@override
State<AddressSelectionBottomSheet> createState() =>
    _AddressSelectionBottomSheetState();

class _AddressSelectionBottomSheetState
    extends State<AddressSelectionBottomSheet> {
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
  void initState() {
    context.read<AddressBloc>().add(const GetsavedAddressEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is LocationSelected) {
          // Navigator.pop(context, state.address); // Return selected address
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
            mainAxisSize: MainAxisSize.min,
            children: [
              currentlocationContainer(
                theme: theme,
                placeID:
                    state is LocationSearchResults ? state.currentplaceID : "",
                address: state is LocationSearchResults
                    ? state.currentlocationaddress
                    : "",
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    spacing: 15,
                    children: [
                      savedaddressContainer(
                          selecetdaddress: state is LocationSearchResults
                              ? state.selecteaddress
                              : null,
                          theme: theme,
                          savedaddress: state is LocationSearchResults
                              ? state.addresslist
                              : []),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget currentlocationContainer(
      {required ThemeData theme,
      required String placeID,
      required String address}) {
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapPage(
                              initialPlaceId: placeID,
                            )));
              },
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
                    address.isNotEmpty ? address : "Select from map",
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapPage(
                              initialPlaceId: placeID,
                            )));
              },
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

  Widget savedaddressContainer(
      {required ThemeData theme,
      required List<AddressModel> savedaddress,
      AddressModel? selecetdaddress}) {
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
        BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
          if (state is LocationSearchResults && state.addresslist.isNotEmpty) {
            return Column(
              children: List.generate(
                state.addresslist.length,
                (index) => Card(
                  color: Colors.white,
                  elevation: .5,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: ListTile(
                      onTap: () {
                        // Navigator.pop(context, state.addresslist[index].formattedAddress);
                      },
                      dense: true,
                      leading: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 244, 244, 244)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Icon(
                            (savedaddress[index].addressType) == "Home"
                                ? Icons.home_outlined
                                : (savedaddress[index].addressType) == "Work"
                                    ? Icons.work_history_outlined
                                    : (savedaddress[index].addressType) ==
                                            "Hotel"
                                        ? Icons.domain_add
                                        : Icons.location_on_outlined,
                            color: const Color.fromARGB(255, 66, 143, 68),
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: Color.fromARGB(255, 66, 143, 68),
                        ),
                        onPressed: () async {
                          HapticFeedback.mediumImpact();
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            enableDrag: false,
                            context: context,
                            builder: (context) {
                              return GestureDetector(
                                onTap: () => FocusScope.of(context).unfocus(),
                                child: Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child: ChangeDefaultaddressBottomsheet(
                                    selectedaddress: state.addresslist[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                savedaddress[index].addressType,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              selecetdaddress?.id == savedaddress[index].id
                                  ? Text(
                                      "   ( ${selecetdaddress!.id == savedaddress[index].id ? "Default address" : ""} )",
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 255, 94, 0),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          Text(
                            "${savedaddress[index].floor ?? ""}, ${savedaddress[index].flatNoName}, ${savedaddress[index].area}, ${savedaddress[index].landmark ?? ""}, ${savedaddress[index].pincode},\n ${savedaddress[index].phoneNo}",
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
            );
          } else if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(
              child: Text("No Address added yet"),
            );
          }
        })
      ],
    );
  }

  // Function to show the address selection bottom sheet
  static Future<String?> show(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const AddressSelectionBottomSheet(),
        );
      },
    );
  }
}
