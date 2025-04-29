import 'package:equatable/equatable.dart';
import 'package:kwik/models/address_model.dart' as AddressModel;
import 'package:kwik/models/order_model.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class GetsavedAddressEvent extends AddressEvent {
  const GetsavedAddressEvent();

  @override
  List<Object> get props => [];
}

class GetWarehousedataEvent extends AddressEvent {
  final String pincode;
  final String destinationLat;
  final String destinationLon;

  const GetWarehousedataEvent(
      this.pincode, this.destinationLat, this.destinationLon);

  @override
  List<Object> get props => [pincode, destinationLat, destinationLon];
}

class SearchLocation extends AddressEvent {
  final String query;

  const SearchLocation(this.query);

  @override
  List<Object> get props => [query];
}

class AddanewAddressEvent extends AddressEvent {
  final AddressModel.AddressModel address;
  final String userID;

  const AddanewAddressEvent(this.address, this.userID);

  @override
  List<Object> get props => [address, userID];
}

class GetWarehousedetailsEvent extends AddressEvent {
  final String pincode;
  final Location location;

  const GetWarehousedetailsEvent(this.pincode, this.location);

  @override
  List<Object> get props => [pincode, location];
}

class UpdateselectedaddressEvent extends AddressEvent {
  final AddressModel.AddressModel address;

  const UpdateselectedaddressEvent(this.address);

  @override
  List<Object> get props => [address];
}

class SelectLocation extends AddressEvent {
  final Location location;
  final String address;

  const SelectLocation(this.location, this.address);

  @override
  List<Object> get props => [location, address];
}

class SaveAddress extends AddressEvent {
  final AddressModel.AddressModel address;

  const SaveAddress(this.address);

  @override
  List<Object> get props => [address];
}

class GetCurrentLocation extends AddressEvent {}
