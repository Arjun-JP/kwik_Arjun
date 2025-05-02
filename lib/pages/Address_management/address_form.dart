// lib/features/address/presentation/pages/address_form_page.dart
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/models/address_model.dart';
import 'package:kwik/models/order_model.dart' show Location;

class AddressFormPage extends StatefulWidget {
  final String selectedaddress;
  final LatLng latlanglocation;
  const AddressFormPage(
      {super.key,
      required this.selectedaddress,
      required this.latlanglocation});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String>? address;
  final _flatNoNameController = TextEditingController();
  final _floorController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _pincodeController = TextEditingController();
  String _addressType = 'Home';

  @override
  void initState() {
    super.initState();
    // Pre-fill area if we have selected address
    final state = context.read<AddressBloc>().state;

    _areaController.text =
        extractAddressDetails(widget.selectedaddress)["area"]!;
    _pincodeController.text =
        extractAddressDetails(widget.selectedaddress)["pin"]!;
  }

  @override
  void dispose() {
    _flatNoNameController.dispose();
    _floorController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _phoneNoController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    ThemeData theme = Theme.of(context);
    Map<String, String> address = extractAddressDetails(widget.selectedaddress);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: InkWell(
          onTap: () {
            print(widget.selectedaddress);
          },
          child: Text(
            'Add more address details',
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressSaved) {
            Navigator.pop(context, state.address);
          } else if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 15,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Save address as *',
                          style: theme.textTheme.bodyMedium!.copyWith(
                              color: const Color.fromARGB(255, 128, 127, 127)),
                        ),
                        Row(
                          spacing: 7,
                          children:
                              ["Home", "Work", "Hotel", "Other"].map((type) {
                            return InkWell(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                setState(() {
                                  _addressType = type;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: _addressType == type
                                        ? const Color.fromARGB(
                                            255, 240, 255, 240)
                                        : Colors.white,
                                    border: Border.all(
                                        color: _addressType == type
                                            ? Colors.green
                                            : const Color.fromARGB(
                                                255, 206, 206, 206)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Icon(
                                      type == "Home"
                                          ? Icons.home_outlined
                                          : type == "Work"
                                              ? Icons.work_history_outlined
                                              : type == "Hotel"
                                                  ? Icons.domain_add
                                                  : Icons.location_on_outlined,
                                      size: 15,
                                      color:
                                          const Color.fromARGB(255, 2, 118, 6),
                                    ),
                                    Text(
                                      type,
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              color: const Color.fromARGB(
                                                  255, 24, 24, 24),
                                              fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontSize: 12),
                          controller: _flatNoNameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, // top & bottom padding
                              horizontal: 10, // left & right padding
                            ),
                            labelText: 'Flat / House no / Building Name *',
                            labelStyle: theme.textTheme.bodyMedium!.copyWith(
                                color:
                                    const Color.fromARGB(255, 128, 127, 127)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 203, 203, 203))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffFC5B00), width: .2)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 127, 127))),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter flat/building name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontSize: 12),
                          controller: _floorController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, // top & bottom padding
                              horizontal: 10, // left & right padding
                            ),
                            labelText: 'Floor (optional)',
                            labelStyle: theme.textTheme.bodyMedium!.copyWith(
                                color:
                                    const Color.fromARGB(255, 128, 127, 127)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 203, 203, 203))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffFC5B00), width: .2)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 127, 127))),
                          ),
                        ),
                        TextFormField(
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 12,
                          ),
                          controller: _areaController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, // top & bottom padding
                              horizontal: 10, // left & right padding
                            ),
                            labelText: 'Area / Sector / Locality *',
                            labelStyle: theme.textTheme.bodyMedium!.copyWith(
                                color:
                                    const Color.fromARGB(255, 128, 127, 127)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 203, 203, 203))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffFC5B00), width: .2)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 127, 127))),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your area/street';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontSize: 12),
                          controller: _landmarkController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, // top & bottom padding
                              horizontal: 10, // left & right padding
                            ),
                            labelText: 'Landmark (Optional)',
                            labelStyle: theme.textTheme.bodyMedium!.copyWith(
                                color:
                                    const Color.fromARGB(255, 128, 127, 127)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 203, 203, 203))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffFC5B00), width: .2)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 127, 127))),
                          ),
                        ),
                        TextFormField(
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontSize: 12),
                          controller: _phoneNoController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, // top & bottom padding
                              horizontal: 10, // left & right padding
                            ),
                            suffixIcon: const Icon(Icons.phone_android_rounded,
                                size: 18,
                                color: Color.fromARGB(255, 128, 127, 127)),
                            labelText: 'Phone Number',
                            labelStyle: theme.textTheme.bodyMedium!.copyWith(
                                color:
                                    const Color.fromARGB(255, 128, 127, 127)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 203, 203, 203))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffFC5B00), width: .2)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 127, 127))),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length != 10) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _pincodeController,
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontSize: 12),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, // top & bottom padding
                              horizontal: 10, // left & right padding
                            ),
                            labelText: 'Pincode',
                            labelStyle: theme.textTheme.bodyMedium!.copyWith(
                                color:
                                    const Color.fromARGB(255, 128, 127, 127)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 203, 203, 203))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffFC5B00), width: .2)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 128, 127, 127))),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your pincode';
                            }
                            if (value.length != 6) {
                              return 'Please enter a valid 6-digit pincode';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {

                        final AddressModel address = AddressModel(
                          location: Location(
                              lat: widget.latlanglocation.latitude,
                              lang: widget.latlanglocation.longitude),
                          addressType: _addressType,
                          flatNoName: _flatNoNameController.text,
                          floor: _floorController.text.isEmpty
                              ? null
                              : _floorController.text,
                          area: _areaController.text,
                          landmark: _landmarkController.text.isEmpty
                              ? null
                              : _landmarkController.text,
                          phoneNo: _phoneNoController.text,
                          pincode: _pincodeController.text,
                        );
                        context
                            .read<AddressBloc>()
                            .add(AddanewAddressEvent(address, user!.uid));
                        context
                            .read<AddressBloc>()
                            .add(const GetsavedAddressEvent());
                        context.go("/homeWA");

                        // } else {
                        //   print("validation faild ${_formKey.currentState}");
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 1, 170, 97),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Save Address',
                        style: theme.textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Map<String, String> extractAddressDetails(String address) {
  final parts = address.split(',');
  if (parts.length < 4) {
    return {"area": "Invalid Address", "pin": ""};
  }

  final areaParts =
      parts.sublist(2, parts.length - 2).map((part) => part.trim()).toList();
  final area = areaParts.join(', ');

  String pin = "";
  final pinMatch = RegExp(r'\b\d{6}\b').firstMatch(address);
  if (pinMatch != null) {
    pin = pinMatch.group(0)!;
  }

  return {"area": area, "pin": pin};
}
