// lib/features/address/presentation/pages/address_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/models/address_model.dart';

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
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
    if (state is LocationSelected) {
      _areaController.text = state.selectedAddress;
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _flatNoNameController,
                  decoration: const InputDecoration(
                    labelText: 'Flat/Building Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter flat/building name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _floorController,
                  decoration: const InputDecoration(
                    labelText: 'Floor (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _areaController,
                  decoration: const InputDecoration(
                    labelText: 'Area/Street',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your area/street';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _landmarkController,
                  decoration: const InputDecoration(
                    labelText: 'Landmark (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNoController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pincodeController,
                  decoration: const InputDecoration(
                    labelText: 'Pincode',
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 16),
                const Text(
                  'Save address as',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: ['Home', 'Work', 'Other'].map((type) {
                    return Expanded(
                      child: RadioListTile<String>(
                        title: Text(type),
                        value: type,
                        groupValue: _addressType,
                        onChanged: (value) {
                          setState(() {
                            _addressType = value!;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final state = context.read<AddressBloc>().state;
                        if (state is LocationSelected) {
                          final address = AddressModel(
                            location: state.selectedLocation,
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
                          context.read<AddressBloc>().add(SaveAddress(address));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Save Address'),
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
