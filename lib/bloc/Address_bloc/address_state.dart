// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:kwik/models/address_model.dart' as AddressModel;
import 'package:kwik/models/googlemap_place_model.dart';
import 'package:kwik/models/order_model.dart' show Location;
import 'package:kwik/models/warehouse_model.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class LocationSearchResults extends AddressState {
  final List<GoogleMapPlace> placelist;
  final List<AddressModel.AddressModel> addresslist;
  final String currentplaceID;
  final String currentlocationaddress;
  final String pincode;
  AddressModel.AddressModel? selecteaddress;
  final WarehouseModel? warehouse;
  final bool orderfordefferentaddress;

  LocationSearchResults(
      this.placelist,
      this.addresslist,
      this.currentplaceID,
      this.currentlocationaddress,
      this.selecteaddress,
      this.warehouse,
      this.pincode,
      this.orderfordefferentaddress);

  LocationSearchResults copyWith({
    List<GoogleMapPlace>? placelist,
    List<AddressModel.AddressModel>? addresslist,
    String? currentplaceID,
    String? currentlocationaddress,
    String? pincode,
    AddressModel.AddressModel? selecteaddress,
    WarehouseModel? warehouse,
    bool? orderfordefferentaddress,
  }) {
    return LocationSearchResults(
      placelist ?? this.placelist,
      addresslist ?? this.addresslist,
      currentplaceID ?? this.currentplaceID,
      currentlocationaddress ?? this.currentlocationaddress,
      selecteaddress ?? this.selecteaddress,
      warehouse ?? this.warehouse,
      pincode ?? this.pincode,
      orderfordefferentaddress ?? this.orderfordefferentaddress,
    );
  }

  @override
  List<Object> get props => [
        placelist,
        addresslist,
        pincode,
        currentplaceID,
        currentlocationaddress,
        orderfordefferentaddress,
        selecteaddress ?? const Object(),
        warehouse ?? const Object(),
      ];
}

class LocationSelected extends AddressState {
  final Location selectedLocation;
  final String selectedAddress;

  const LocationSelected(this.selectedLocation, this.selectedAddress);

  @override
  List<Object> get props => [selectedLocation, selectedAddress];
}

class AddressSaved extends AddressState {
  final AddressModel.AddressModel address;

  const AddressSaved(this.address);

  @override
  List<Object> get props => [address];
}

class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object> get props => [message];
}

class NowarehousefoudState extends AddressState {
  const NowarehousefoudState();

  @override
  List<Object> get props => [];
}
